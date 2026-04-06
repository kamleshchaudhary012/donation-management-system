<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    double totalDonated = 0;
    int donationsCount = 0;
    int causesCount = 0;
    int activeMonthlyCount = 0;

    try {
        // Fetch stats
        String statsQuery = "SELECT SUM(amount) as total, COUNT(*) as count, COUNT(DISTINCT charity_id) as causes FROM donations WHERE user_id = ?";
        PreparedStatement pstmtStats = conn.prepareStatement(statsQuery);
        pstmtStats.setInt(1, userId);
        ResultSet rsStats = pstmtStats.executeQuery();
        if (rsStats.next()) {
            totalDonated = rsStats.getDouble("total");
            donationsCount = rsStats.getInt("count");
            causesCount = rsStats.getInt("causes");
        }

        String activeMonthlyQuery = "SELECT COUNT(*) as count FROM donations WHERE user_id = ? AND frequency = 'Monthly' AND is_active = 1";
        PreparedStatement pstmtActiveMonthly = conn.prepareStatement(activeMonthlyQuery);
        pstmtActiveMonthly.setInt(1, userId);
        ResultSet rsActiveMonthly = pstmtActiveMonthly.executeQuery();
        if (rsActiveMonthly.next()) {
            activeMonthlyCount = rsActiveMonthly.getInt("count");
        }
    } catch (Exception e) {
        out.println("Error stats: " + e.getMessage());
    }
%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - My Dashboard" />
    <jsp:param name="cssFile" value="dashboard.css" />
    <jsp:param name="jsFile" value="dashboard.js" />
</jsp:include>

        <div class="dashboard-header">
            <h1>Welcome back, <%= (userName != null ? userName : "User") %>!</h1>
        </div>

        <div class="stats-grid">
            <div class="stat-card"><i class="fas fa-hand-holding-heart"></i><h3>Total Donated</h3><p>₹<%= String.format("%,.0f", totalDonated) %></p></div>
            <div class="stat-card"><i class="fas fa-calendar-alt"></i><h3>Donations Made</h3><p><%= donationsCount %></p></div>
            <div class="stat-card"><i class="fas fa-users"></i><h3>Causes Supported</h3><p><%= causesCount %></p></div>
            <div class="stat-card"><i class="fas fa-repeat"></i><h3>Active Monthly Plans</h3><p><%= activeMonthlyCount %></p></div>
        </div>

        <div class="donation-history">
            <h3>Active Monthly Donations</h3>
            <table>
                <thead>
                    <tr><th>Charity</th><th>Amount</th><th>Monthly Date</th><th>Next Date</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String activeQuery = "SELECT d.id, d.amount, d.recurring_day, d.next_charge_date, d.status, c.name FROM donations d JOIN charities c ON d.charity_id = c.id WHERE d.user_id = ? AND d.frequency = 'Monthly' AND d.is_active = 1 ORDER BY d.next_charge_date ASC";
                            PreparedStatement psActive = conn.prepareStatement(activeQuery);
                            psActive.setInt(1, userId);
                            ResultSet rsActive = psActive.executeQuery();
                            boolean hasActive = false;
                            while (rsActive.next()) {
                                hasActive = true;
                    %>
                    <tr>
                        <td><%= rsActive.getString("name") %></td>
                        <td>₹<%= String.format("%,.0f", rsActive.getDouble("amount")) %></td>
                        <td><%= rsActive.getInt("recurring_day") %></td>
                        <td><%= rsActive.getDate("next_charge_date") %></td>
                        <td><%= rsActive.getString("status") %></td>
                        <td>
                            <form action="stop_monthly.jsp" method="post" class="inline-form">
                                <input type="hidden" name="donationId" value="<%= rsActive.getInt("id") %>">
                                <button type="submit" class="btn-sm btn-delete">Stop</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                            if (!hasActive) {
                                out.println("<tr><td colspan='6' style='text-align:center;'>No active monthly donations.</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'>Error loading active monthly donations.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="donation-history">
            <h3>Monthly Donation History</h3>
            <table>
                <thead>
                    <tr><th>Created Date</th><th>Charity</th><th>Amount</th><th>Monthly Date</th><th>Next Date</th><th>Stopped At</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String monthlyHistoryQuery = "SELECT d.*, c.name FROM donations d JOIN charities c ON d.charity_id = c.id WHERE d.user_id = ? AND d.frequency = 'Monthly' ORDER BY d.donation_date DESC";
                            PreparedStatement psMHistory = conn.prepareStatement(monthlyHistoryQuery);
                            psMHistory.setInt(1, userId);
                            ResultSet rsMHistory = psMHistory.executeQuery();
                            boolean hasMonthly = false;
                            while (rsMHistory.next()) {
                                hasMonthly = true;
                    %>
                    <tr>
                        <td><%= rsMHistory.getTimestamp("donation_date") %></td>
                        <td><%= rsMHistory.getString("name") %></td>
                        <td>₹<%= String.format("%,.0f", rsMHistory.getDouble("amount")) %></td>
                        <td><%= rsMHistory.getInt("recurring_day") %></td>
                        <td><%= rsMHistory.getDate("next_charge_date") %></td>
                        <td><%= rsMHistory.getTimestamp("stopped_at") %></td>
                        <td><%= rsMHistory.getString("status") %></td>
                    </tr>
                    <%
                            }
                            if (!hasMonthly) {
                                out.println("<tr><td colspan='7' style='text-align:center;'>No monthly donation history.</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7'>Error loading monthly history.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="donation-history">
            <h3>Recent Donations</h3>
            <table>
                <thead>
                    <tr><th>Date</th><th>Charity</th><th>Amount</th><th>Frequency</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String historyQuery = "SELECT d.*, c.name FROM donations d JOIN charities c ON d.charity_id = c.id WHERE d.user_id = ? ORDER BY d.donation_date DESC";
                            PreparedStatement pstmtHistory = conn.prepareStatement(historyQuery);
                            pstmtHistory.setInt(1, userId);
                            ResultSet rsHistory = pstmtHistory.executeQuery();
                            boolean hasDonations = false;
                            while (rsHistory.next()) {
                                hasDonations = true;
                    %>
                    <tr>
                        <td><%= rsHistory.getTimestamp("donation_date") %></td>
                        <td><%= rsHistory.getString("name") %></td>
                        <td>₹<%= String.format("%,.0f", rsHistory.getDouble("amount")) %></td>
                        <td><%= rsHistory.getString("frequency") %></td>
                        <td><%= rsHistory.getString("status") %></td>
                    </tr>
                    <%
                            }
                            if (!hasDonations) {
                                out.println("<tr><td colspan='5' style='text-align:center;'>No donations found. <a href='index.jsp'>Donate Now</a></td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("Error history: " + e.getMessage());
                        } finally {
                            if (conn != null) conn.close();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
