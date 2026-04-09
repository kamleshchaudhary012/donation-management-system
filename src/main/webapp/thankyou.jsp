<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>

<%
    /* =========================
   GET DATA (Razorpay + fallback)
   ========================= */
// Razorpay params
    String paymentId = request.getParameter("razorpay_payment_id");

// Fallback from session (VERY IMPORTANT)
    String charityIdStr = request.getParameter("charityId");
    String amountStr = request.getParameter("amount");

    if (charityIdStr == null) {
        charityIdStr = (String) session.getAttribute("charityId");
    }
    if (amountStr == null) {
        amountStr = (String) session.getAttribute("amount");
    }

    String frequency = request.getParameter("frequency");
    if (frequency == null) {
        frequency = (String) session.getAttribute("frequency");
    }
    if (frequency == null) {
        frequency = "One-time";
    }

    String recurringDayStr = request.getParameter("recurringDay");
    if (recurringDayStr == null) {
        recurringDayStr = (String) session.getAttribute("recurringDay");
    }

    Integer userId = (Integer) session.getAttribute("userId");

    boolean success = false;

    /* =========================
   MAIN LOGIC
   ========================= */
    if (paymentId != null && charityIdStr != null && amountStr != null && userId != null) {

        try {

            // ✅ START TRANSACTION
            conn.setAutoCommit(false);

            int charityId = Integer.parseInt(charityIdStr);
            double amount = Double.parseDouble(amountStr);

            Integer recurringDay = null;
            Date nextChargeDate = null;

            // ✅ MONTHLY LOGIC
            if ("Monthly".equalsIgnoreCase(frequency)) {

                if (recurringDayStr != null && !recurringDayStr.isEmpty()) {
                    recurringDay = Integer.parseInt(recurringDayStr);
                } else {
                    recurringDay = 1;
                }

                if (recurringDay < 1 || recurringDay > 28) {
                    recurringDay = 1;
                }

                String nextDateQuery
                        = "SELECT DATE_ADD(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH) + INTERVAL (? - 1) DAY AS next_date";

                PreparedStatement nextStmt = conn.prepareStatement(nextDateQuery);
                nextStmt.setInt(1, recurringDay);

                ResultSet rs = nextStmt.executeQuery();

                if (rs.next()) {
                    nextChargeDate = rs.getDate("next_date");
                }

                rs.close();
                nextStmt.close();
            }

            // INSERT DONATION
            String insertDonation
                    = "INSERT INTO donations "
                    + "(user_id, charity_id, amount, frequency, recurring_day, next_charge_date, is_active, status, payment_id) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement pstmt1 = conn.prepareStatement(insertDonation);

            pstmt1.setInt(1, userId);
            pstmt1.setInt(2, charityId);
            pstmt1.setDouble(3, amount);
            pstmt1.setString(4, frequency);

            if (recurringDay == null) {
                pstmt1.setNull(5, Types.INTEGER);
                pstmt1.setNull(6, Types.DATE);
                pstmt1.setInt(7, 0);
                pstmt1.setString(8, "Completed");
            } else {
                pstmt1.setInt(5, recurringDay);
                pstmt1.setDate(6, nextChargeDate);
                pstmt1.setInt(7, 1);
                pstmt1.setString(8, "Active");
            }

            pstmt1.setString(9, paymentId);

            pstmt1.executeUpdate();
            pstmt1.close();

            // ✅ UPDATE CHARITY
            String updateCharity
                    = "UPDATE charities SET raised_amount = raised_amount + ? WHERE id = ?";

            PreparedStatement pstmt2 = conn.prepareStatement(updateCharity);

            pstmt2.setDouble(1, amount);
            pstmt2.setInt(2, charityId);

            pstmt2.executeUpdate();
            pstmt2.close();

            //  COMMIT
            conn.commit();
            success = true;

        } catch (Exception e) {

            //  SAFE ROLLBACK
            if (conn != null) {
                try {
                    if (!conn.getAutoCommit()) {
                        conn.rollback();
                    }
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }

            out.println("DB Error: " + e.getMessage());
        } finally {

            //  RESET CONNECTION
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        }
    }

    /* =========================
   REDIRECT IF FAILED
   ========================= */
    if (!success) {

        if (userId == null) {
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("payment_failure.jsp");
        }

        return;
    }
%>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Thank You" />
    <jsp:param name="cssFile" value="thankyou.css" />
    <jsp:param name="jsFile" value="thankyou.js" />
</jsp:include>

<div class="status-container">

    <i class="fas fa-check-circle" style="font-size:80px;color:green;"></i>

    <h2>
        Thank You for Your
        <%= "Monthly".equals(frequency)
                ? " Monthly Support!"
                : " Donation!"%>
    </h2>

    <p>
        Your contribution of
        <strong>₹<%= amountStr%></strong>

        <%= "Monthly".equals(frequency)
                ? " every month"
                : ""%>

        has been successfully received 🎉
    </p>

    <div class="status-actions">

        <a href="dashboard.jsp" class="btn-primary">
            View My Donations
        </a>

        <br><br>

        <a href="index.jsp" style="color:#f97316;text-decoration:none;font-weight:600;">
            Back to Home
        </a>

    </div>

</div>

<jsp:include page="footer.jsp" />


<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>

<%

// Get parameters from Razorpay redirect

String charityIdStr = request.getParameter("charityId");
String amountStr = request.getParameter("amount");
String paymentId = request.getParameter("payment_id");
String frequency = request.getParameter("frequency");
String recurringDayStr = request.getParameter("recurringDay");

if (frequency == null) {
    frequency = "One-time";
}

Integer userId = (Integer) session.getAttribute("userId");

boolean success = false;

if (paymentId != null &&
    charityIdStr != null &&
    amountStr != null &&
    userId != null) {

    try {

        int charityId = Integer.parseInt(charityIdStr);
        double amount = Double.parseDouble(amountStr);

        Integer recurringDay = null;
        Date nextChargeDate = null;

        // Handle Monthly Donation
        if ("Monthly".equalsIgnoreCase(frequency)) {

            recurringDay = Integer.parseInt(recurringDayStr);

            if (recurringDay < 1 || recurringDay > 28) {
                recurringDay = 1;
            }

            String nextDateQuery =
            "SELECT DATE_ADD(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH) + INTERVAL (? - 1) DAY AS next_date";

            PreparedStatement nextStmt =
            conn.prepareStatement(nextDateQuery);

            nextStmt.setInt(1, recurringDay);

            ResultSet rs = nextStmt.executeQuery();

            if (rs.next()) {
                nextChargeDate =
                rs.getDate("next_date");
            }

            rs.close();
            nextStmt.close();
        }

        // Start Transaction
        conn.setAutoCommit(false);

        // Insert Donation

        String insertDonation =
        "INSERT INTO donations " +
        "(user_id, charity_id, amount, frequency, recurring_day, next_charge_date, is_active, status, payment_id) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement pstmt1 =
        conn.prepareStatement(insertDonation);

        pstmt1.setInt(1, userId);
        pstmt1.setInt(2, charityId);
        pstmt1.setDouble(3, amount);
        pstmt1.setString(4, frequency);

        if (recurringDay == null) {

            pstmt1.setNull(5, Types.INTEGER);
            pstmt1.setNull(6, Types.DATE);
            pstmt1.setInt(7, 0);
            pstmt1.setString(8, "Completed");

        } else {

            pstmt1.setInt(5, recurringDay);
            pstmt1.setDate(6, nextChargeDate);
            pstmt1.setInt(7, 1);
            pstmt1.setString(8, "Active");

        }

        pstmt1.setString(9, paymentId);

        pstmt1.executeUpdate();

        // Update Charity Amount

        String updateCharity =
        "UPDATE charities SET raised_amount = raised_amount + ? WHERE id = ?";

        PreparedStatement pstmt2 =
        conn.prepareStatement(updateCharity);

        pstmt2.setDouble(1, amount);
        pstmt2.setInt(2, charityId);

        pstmt2.executeUpdate();

        // Commit

        conn.commit();

        success = true;

    } catch (Exception e) {

        if (conn != null) {
            conn.rollback();
        }

        out.println("Error: " + e.getMessage());

    } finally {

        if (conn != null) {
            conn.setAutoCommit(true);
            conn.close();
        }
    }
}

// Redirect if failed

if (!success) {

    if (userId == null) {
        response.sendRedirect("login.jsp");
    } else {
        response.sendRedirect("payment_failure.jsp");
    }

    return;
}

%>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Thank You" />
    <jsp:param name="cssFile" value="thankyou.css" />
    <jsp:param name="jsFile" value="thankyou.js" />
</jsp:include>


<div class="status-container">

    <i class="fas fa-check-circle"
       style="font-size:80px;color:green;"></i>

    <h2>
        Thank You for Your
        <%= "Monthly".equals(frequency)
            ? " Monthly Support!"
            : " Donation!" %>
    </h2>

    <p>

        Your generous contribution of

        <strong>
        ₹<%= amountStr %>
        </strong>

        <%= "Monthly".equals(frequency)
            ? " every month"
            : "" %>

        has been successfully received.

        Your support makes a real difference!

    </p>

    <div class="status-actions">

        <a href="dashboard.jsp"
           class="btn-primary">

           View My Donations

        </a>

        <br><br>

        <a href="index.jsp"
           style="color:#f97316;
                  text-decoration:none;
                  font-weight:600;">

           Back to Home

        </a>

    </div>

</div>


<jsp:include page="footer.jsp" />--%>