<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%  
    String charityId = request.getParameter("id");
    String type = request.getParameter("type"); // "Monthly" or null/One-time
    boolean isMonthly = "Monthly".equals(type);
    boolean showAll = (charityId == null || charityId.trim().isEmpty());

    String charityName = "Cause Not Found";
    String cause = "";
    String location = "";
    String imageUrl = "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?q=80&w=1470&auto=format&fit=crop";
    String description = "We couldn't find the charity you're looking for. Please go back to the home page.";
    double goalAmount = 0;
    double raisedAmount = 0;
    double progressPercent = 0;
    boolean found = false;

    if (!showAll) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            if (conn != null) {
                String query = "SELECT * FROM charities WHERE id = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, Integer.parseInt(charityId.trim()));
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    found = true;
                    charityName = rs.getString("name");
                    cause = rs.getString("cause");
                    location = rs.getString("location");
                    imageUrl = rs.getString("image_url");
                    description = rs.getString("description");
                    goalAmount = rs.getDouble("goal_amount");
                    raisedAmount = rs.getDouble("raised_amount");
                    if (goalAmount > 0) {
                        progressPercent = (raisedAmount / goalAmount) * 100;
                        if (progressPercent > 100) {
                            progressPercent = 100;
                        }
                    }
                }
            }
        } catch (NumberFormatException e) {
            // Invalid ID format
        } catch (SQLException e) {
            out.println("<!-- Database Error: " + e.getMessage() + " -->");
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException ex) {
            }
            if (pstmt != null) try {
                pstmt.close();
            } catch (SQLException ex) {
            }
            if (!showAll && conn != null) try {
                conn.close();
            } catch (SQLException ex) {
            }
        }
    }
%>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<jsp:include page="header.jsp">
    <jsp:param name="title" value='<%= showAll ? "CharityX - All Charities" : "CharityX - " + charityName%>' />
    <jsp:param name="cssFile" value="charity.css" />
    <jsp:param name="jsFile" value="charity.js" />
</jsp:include>

<% if (showAll) { %>
<!-- ===== ALL CHARITIES LISTING ===== -->
<div class="all-charities-header" style="margin: 40px 0 20px; text-align: center;">
    <h1 style="font-size: 2.2rem; font-weight: 800; color: #1e293b;">Support a Cause</h1>
    <p style="color: #64748b; margin-top: 10px; font-size: 1.1rem;">Choose a charity below and make a difference today.</p>
</div>
<div class="charity-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 28px; margin-bottom: 60px;">
    <%
        PreparedStatement pstmtAll = null;
        ResultSet rsAll = null;
        try {
            if (conn != null) {
                String queryAll = "SELECT * FROM charities";
                pstmtAll = conn.prepareStatement(queryAll);
                rsAll = pstmtAll.executeQuery();
                boolean anyCharity = false;
                while (rsAll.next()) {
                    anyCharity = true;
                    double goal = rsAll.getDouble("goal_amount");
                    double raised = rsAll.getDouble("raised_amount");
                    double pct = (goal > 0) ? Math.min((raised / goal) * 100.0, 100.0) : 0;
                    String imgUrl = rsAll.getString("image_url");
                    String cardName = rsAll.getString("name");
                    String cardDesc = rsAll.getString("description");
                    int cardId = rsAll.getInt("id");
                    String shortDesc = (cardDesc.length() > 120) ? cardDesc.substring(0, 120) + "..." : cardDesc;
                    // Force dot decimal separator so generated widths are valid CSS values.
                    String pctFormatted = String.format(java.util.Locale.US, "%.1f", pct);
    %>
    <div class="charity-card" style="background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.07); border: 1px solid #eef2f6; display: flex; flex-direction: column;">
        <div style="background: url('<%= imgUrl%>') center/cover no-repeat; height: 200px;"></div>
        <div style="padding: 20px; flex: 1; display: flex; flex-direction: column;">
            <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 8px; color: #1e293b;"><%= cardName%></h3>
            <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6; flex: 1;"><%= shortDesc%></p>
            <div style="margin-top: 14px; background: #e2e8f0; border-radius: 20px; height: 8px; overflow: hidden;">
                <div class="pbar-<%= cardId%> progress-bar-fill"
                     style="background: linear-gradient(90deg, #f97316, #ea580c); height: 100%; width: 0%; border-radius: 20px; transition: width 0.3s ease-in-out;"
                     data-charity-id="<%= cardId%>"
                     data-progress-width="<%= pctFormatted%>"></div>
            </div>
            <div style="display: flex; justify-content: space-between; font-size: 0.82rem; color: #64748b; margin-top: 6px;">
                <span>₹<%= String.format("%,.0f", raised)%> raised</span>
                <span><%= String.format("%.0f", pct)%>% of ₹<%= String.format("%,.0f", goal)%></span>
            </div>
            <a href="charity.jsp?id=<%= cardId%>" style="display: block; margin-top: 16px; background: linear-gradient(135deg, #f97316, #ea580c); color: white; text-align: center; padding: 12px; border-radius: 40px; text-decoration: none; font-weight: 600; font-size: 0.9rem; transition: opacity 0.2s;" onmouseover="this.style.opacity = '0.85'" onmouseout="this.style.opacity = '1'">Donate to this cause →</a>
        </div>
    </div>
    <%
                }
                if (!anyCharity) {
                    out.println("<p style='text-align:center;color:#64748b;'>No charities found.</p>");
                }
            } else {
                out.println("<p>Database connection unavailable.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Error fetching charities: " + e.getMessage() + "</p>");
        } finally {
            if (rsAll != null) try {
                rsAll.close();
            } catch (SQLException e) {
            }
            if (pstmtAll != null) try {
                pstmtAll.close();
            } catch (SQLException e) {
            }
            if (conn != null) try {
                conn.close();
            } catch (SQLException e) {
            }
        }
    %>
</div>

<% } else {%>
<!-- ===== SINGLE CHARITY DETAIL ===== -->
<div class="charity-detail">
    <div class="detail-left">
        <div class="image-poster" style="background: url('<%= imageUrl%>'); background-size: cover; background-position: center; border-radius: 24px; height: 350px; margin-bottom: 24px;"></div>

        <% if (found) {%>
        <div class="progress-section" style="background: #f8fafc; padding: 24px; border-radius: 24px; border: 1px solid #eef2f6;">
            <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-weight: 700; color: #1e293b;">
                <span>Funding Progress</span>
                <span><%= String.format("%.1f", progressPercent)%>%</span>
            </div>
            <div style="background: #e2e8f0; border-radius: 20px; height: 16px; overflow: hidden; margin-bottom: 16px;">
                <div id="progressBar"
                     class="progress-bar-fill"
                     data-charity-id="<%= charityId%>"
                     data-progress-width="<%= String.format(java.util.Locale.US, "%.1f", progressPercent)%>"
                     style="background: linear-gradient(90deg, #f97316, #ea580c); width: 0%; height: 100%; border-radius: 20px; transition: width 1s ease-in-out;"></div>
            </div>
            <div style="display: flex; justify-content: space-between; margin-top: 10px; font-size: 0.95rem; font-weight: 500;">
                <span>Raised: ₹<%= String.format("%,.0f", raisedAmount)%></span>
                <span>Goal: ₹<%= String.format("%,.0f", goalAmount)%></span>
            </div>
            <div style="text-align: center; margin-top: 20px; font-weight: 800; color: #f97316; font-size: 1.1rem; background: #fff7ed; padding: 12px; border-radius: 12px;">
                Needs Remaining: ₹<%= String.format("%,.0f", (goalAmount - raisedAmount > 0 ? goalAmount - raisedAmount : 0))%>
            </div>
        </div>
        <% } %>
    </div>

    <div class="detail-right">
        <% if (found) {%>
        <span class="tag-badge"><i class="fas fa-shield-heart"></i> Verified NGO</span>
        <span class="tag-badge" style="background: #e0f2fe; color: #0369a1;"><i class="fas fa-file-invoice-dollar"></i> Tax Benefits</span>
        <h1><%= charityName%></h1>
        <div class="charity-info">
            <p style="font-size: 1.15rem; line-height: 1.7; color: #475569;"><%= description%></p>
            <div style="margin-top: 24px; display: flex; gap: 20px; flex-wrap: wrap;">
                <p style="background: #f1f5f9; padding: 8px 16px; border-radius: 10px;"><strong>Cause:</strong> <%= cause%></p>
                <p style="background: #f1f5f9; padding: 8px 16px; border-radius: 10px;"><strong>Location:</strong> <%= location%></p>
            </div>
        </div>

        <div class="donate-box">
            <h3><%= isMonthly ? "Start Monthly Support" : "Empower this cause"%></h3>
            <% if (isMonthly) { %>
            <p style="margin-bottom: 15px; font-size: 0.9rem; color: #0d9488;">You are setting up a monthly recurring donation.</p>
            <% } %>
            <% if (session.getAttribute("userEmail") == null) {%>
            <div class="login-prompt" style="background: #fff7ed; border: 1px dashed #f97316; padding: 24px; border-radius: 16px; text-align: center;">
                <p style="margin-bottom: 12px; font-weight: 500;">Ready to make a difference?</p>
                <a href="login.jsp?redirect=charity.jsp?id=<%= request.getParameter("id")%>" class="btn-primary">Login to Support Us</a>
                <p style="margin-top: 12px; font-size: 0.9rem;">Don't have an account? <a href="register.jsp" style="color: #f97316; font-weight: 600;">Register here</a></p>
            </div>
            <% } else {%>
            <form action="thankyou.jsp" method="post">
                <input type="hidden" name="charityId" value="<%= charityId%>">
                <input type="hidden" name="frequency" value="<%= isMonthly ? "Monthly" : "One-time"%>">
                <div class="amount-grid">
                    <button type="button" class="amount-btn" data-amount="500">₹500</button>
                    <button type="button" class="amount-btn" data-amount="1000">₹1000</button>
                    <button type="button" class="amount-btn" data-amount="2500">₹2500</button>
                    <button type="button" class="amount-btn" data-amount="5000">₹5000</button>
                </div>
                <div class="input-box">
                    <label for="amount">Or enter custom amount (₹):</label>
                    <input type="number" name="amount" id="amount" min="10" step="1" placeholder="e.g., 750" required>
                </div>
                <% if (isMonthly) { %>
                <div class="input-box">
                    <label for="recurringDay">Monthly donation date (day of month)</label>
                    <input type="number" name="recurringDay" id="recurringDay" min="1" max="28" value="1" required>
                </div>
                <% }%>
<!--                            <button type="submit" class="submit-btn"><%= isMonthly ? "Set Up Monthly Donation" : "Proceed to Secure Donation"%></button>-->
                <button type="button" class="submit-btn" onclick="startPayment()">Proceed to Secure Donation</button>
            </form>
            <% } %>
            <p class="security-note">
                <i class="fas fa-lock"></i> SSL Secured Payment · 100% Transparency
            </p>
        </div>
        <% } else { %>
        <h1>Charity Not Found</h1>
        <p>The charity ID provided is invalid or the cause has been removed.</p>
        <a href="index.jsp" class="btn-primary" style="margin-top: 20px;">Back to Home</a>
        <% } %>
    </div>
</div>

<div class="back-btn">
    <a href="charity.jsp"><i class="fas fa-arrow-left"></i> Back to all charities</a>
</div>
<% }%>

</div> <!-- Close container from header.jsp -->
<script>

// Auto fill preset amount buttons
    document.addEventListener("DOMContentLoaded", function () {

        var buttons =
                document.querySelectorAll(".amount-btn");

        buttons.forEach(function (btn) {

            btn.addEventListener("click", function () {

                document.getElementById("amount").value =
                        this.getAttribute("data-amount");

            });

        });

    });



    function startPayment() {

        var amount = document.getElementById("amount").value;

        if (amount == "" || amount < 10) {

            alert("Please enter minimum ₹10");
            return;

        }

        // Get recurring day (if monthly donation)

        var recurringDayField =
                document.getElementById("recurringDay");

        var recurringDay =
                recurringDayField ?
                recurringDayField.value :
                "";



        var options = {

            "key": "rzp_test_Sb3rEnuMz9b4ki",

            "amount": amount * 100,

            "currency": "INR",

            "name": "CharityX",

            "description": "Donation Payment",

            "handler": function (response) {

                const paymentId = response.razorpay_payment_id;

                // POST form create
                var form = document.createElement("form");
                form.method = "POST";
                form.action = "thankyou.jsp";

                form.innerHTML = `
            <input type="hidden" name="payment_id" value="${paymentId}">
            <input type="hidden" name="amount" value="${amount}">
            <input type="hidden" name="charityId" value="<%= charityId%>">
            <input type="hidden" name="frequency" value="<%= isMonthly ? "Monthly" : "One-time"%>">
            <input type="hidden" name="recurringDay" value="${recurringDay}">
        `;

                document.body.appendChild(form);
                form.submit();
            }

        };

        var rzp = new Razorpay(options);

        rzp.open();

    }

</script>




<!--
<script>

// Auto fill preset amount buttons
    document.addEventListener("DOMContentLoaded", function () {

        var buttons = document.querySelectorAll(".amount-btn");

        buttons.forEach(function (btn) {

            btn.addEventListener("click", function () {

                document.getElementById("amount").value =
                        this.getAttribute("data-amount");

            });

        });

    });


// =============================
// START RAZORPAY PAYMENT
// =============================

    function startPayment() {

        var amount = document.getElementById("amount").value;

        if (amount == "" || amount < 10) {

            alert("Minimum donation is ₹10");
            return;

        }

        // Monthly donation support

        var recurringDayField =
                document.getElementById("recurringDay");

        var recurringDay =
                recurringDayField ?
                recurringDayField.value :
                "";


        // =============================
        // CREATE ORDER FROM SERVLET
        // =============================

        fetch("CreateOrderServlet", {

            method: "POST",

            headers: {
                'Content-Type':
                        'application/x-www-form-urlencoded'
            },

            body: "amount=" + amount

        })

                .then(response => response.json())

                .then(order => {

                    var options = {

                        //  PUT YOUR LIVE KEY HERE
                        "key": "rzp_test_Sb3rEnuMz9b4ki",
//                        rzp_live_Sa9wJWyUqpcoXs

                        "amount": order.amount,

                        "currency": "INR",

                        "order_id": order.id,

                        "name": "CharityX",

                        "description": "Donation Payment",

                        "handler": function (response) {

                            const paymentId =
                                    response.razorpay_payment_id;

                            const orderId =
                                    response.razorpay_order_id;

                            const signature =
                                    response.razorpay_signature;


                            // =============================
                            // SEND DATA TO THANKYOU PAGE
                            // =============================

                            var form =
                                    document.createElement("form");

                            form.method = "POST";

                            form.action = "thankyou.jsp";

                            form.innerHTML = `

                        <input type="hidden" name="payment_id" value="${paymentId}">
                        <input type="hidden" name="order_id" value="${orderId}">
                        <input type="hidden" name="signature" value="${signature}">
                        <input type="hidden" name="amount" value="${amount}">
                        <input type="hidden" name="charityId" value="<%= charityId%>">
                        <input type="hidden" name="frequency" value="<%= isMonthly ? "Monthly" : "One-time"%>">
                        <input type="hidden" name="recurringDay" value="${recurringDay}">

                                        `;

                            document.body.appendChild(form);

                            form.submit();

                        }

                    };

                    var rzp =
                            new Razorpay(options);

                    rzp.open();

                });

    }

</script>-->
<jsp:include page="footer.jsp" />