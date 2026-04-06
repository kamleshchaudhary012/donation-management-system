<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    double totalDonations = 0;
    int donorsCount = 0;
    int activeCharities = 0;
    int activeMonthlyPlans = 0;
    int stoppedMonthlyPlans = 0;

    try {
        // Fetch stats
        String statsQuery = "SELECT SUM(amount) as total FROM donations";
        Statement stmtStats = conn.createStatement();
        ResultSet rsStats = stmtStats.executeQuery(statsQuery);
        if (rsStats.next()) {
            totalDonations = rsStats.getDouble("total");
        }

        String donorsQuery = "SELECT COUNT(DISTINCT id) as count FROM users WHERE role='user'";
        ResultSet rsDonors = stmtStats.executeQuery(donorsQuery);
        if (rsDonors.next()) {
            donorsCount = rsDonors.getInt("count");
        }

        String charitiesQuery = "SELECT COUNT(*) as count FROM charities";
        ResultSet rsCharities = stmtStats.executeQuery(charitiesQuery);
        if (rsCharities.next()) {
            activeCharities = rsCharities.getInt("count");
        }

        String activeMonthlyQuery = "SELECT COUNT(*) as count FROM donations WHERE frequency='Monthly' AND is_active = 1";
        ResultSet rsActiveMonthly = stmtStats.executeQuery(activeMonthlyQuery);
        if (rsActiveMonthly.next()) {
            activeMonthlyPlans = rsActiveMonthly.getInt("count");
        }

        String stoppedMonthlyQuery = "SELECT COUNT(*) as count FROM donations WHERE frequency='Monthly' AND is_active = 0";
        ResultSet rsStoppedMonthly = stmtStats.executeQuery(stoppedMonthlyQuery);
        if (rsStoppedMonthly.next()) {
            stoppedMonthlyPlans = rsStoppedMonthly.getInt("count");
        }
    } catch (Exception e) {
        out.println("Error stats: " + e.getMessage());
    }
%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Admin Dashboard" />
    <jsp:param name="cssFile" value="admin_dashboard.css" />
    <jsp:param name="jsFile" value="admin_dashboard.js" />
</jsp:include>

        <div class="dashboard-header">
            <h1>Admin Dashboard</h1>
            <p>Welcome, <%= adminEmail %></p>
        </div>

        <div class="stats-grid">
            <div class="stat-card"><i class="fas fa-hand-holding-heart"></i><h3>Total Donations</h3><p>₹<%= String.format("%,.0f", totalDonations) %></p></div>
            <div class="stat-card"><i class="fas fa-users"></i><h3>Total Donors</h3><p><%= donorsCount %></p></div>
            <div class="stat-card"><i class="fas fa-building"></i><h3>Active Charities</h3><p><%= activeCharities %></p></div>
            <div class="stat-card"><i class="fas fa-repeat"></i><h3>Active Monthly Plans</h3><p><%= activeMonthlyPlans %></p></div>
            <div class="stat-card"><i class="fas fa-ban"></i><h3>Stopped Monthly Plans</h3><p><%= stoppedMonthlyPlans %></p></div>
        </div>

        <!-- Recent Donations -->
        <div class="admin-section">
            <h3>Recent Donations</h3>
            <table class="admin-table">
                <thead>
                    <tr><th>Date</th><th>Donor</th><th>Charity</th><th>Amount</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String recentQuery = "SELECT d.*, u.email, c.name as cname FROM donations d JOIN users u ON d.user_id = u.id JOIN charities c ON d.charity_id = c.id ORDER BY d.donation_date DESC LIMIT 10";
                            Statement stmtRecent = conn.createStatement();
                            ResultSet rsRecent = stmtRecent.executeQuery(recentQuery);
                            while (rsRecent.next()) {
                    %>
                    <tr>
                        <td><%= rsRecent.getTimestamp("donation_date") %></td>
                        <td><%= rsRecent.getString("email") %></td>
                        <td><%= rsRecent.getString("cname") %></td>
                        <td>₹<%= String.format("%,.0f", rsRecent.getDouble("amount")) %></td>
                        <td><%= rsRecent.getString("status") %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Error recent: " + e.getMessage());
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="admin-section">
            <h3>Monthly Donations - Active</h3>
            <table class="admin-table">
                <thead>
                    <tr><th>User</th><th>Charity</th><th>Amount</th><th>Monthly Date</th><th>Next Date</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String monthlyActiveQuery = "SELECT d.amount, d.recurring_day, d.next_charge_date, d.status, u.name as uname, u.email, c.name as cname FROM donations d JOIN users u ON d.user_id = u.id JOIN charities c ON d.charity_id = c.id WHERE d.frequency='Monthly' AND d.is_active = 1 ORDER BY d.next_charge_date ASC";
                            Statement stmtMonthlyActive = conn.createStatement();
                            ResultSet rsMonthlyActive = stmtMonthlyActive.executeQuery(monthlyActiveQuery);
                            boolean hasActiveMonthly = false;
                            while (rsMonthlyActive.next()) {
                                hasActiveMonthly = true;
                    %>
                    <tr>
                        <td><%= rsMonthlyActive.getString("uname") %> (<%= rsMonthlyActive.getString("email") %>)</td>
                        <td><%= rsMonthlyActive.getString("cname") %></td>
                        <td>₹<%= String.format("%,.0f", rsMonthlyActive.getDouble("amount")) %></td>
                        <td><%= rsMonthlyActive.getInt("recurring_day") %></td>
                        <td><%= rsMonthlyActive.getDate("next_charge_date") %></td>
                        <td><%= rsMonthlyActive.getString("status") %></td>
                    </tr>
                    <%
                            }
                            if (!hasActiveMonthly) {
                                out.println("<tr><td colspan='6' style='text-align:center;'>No active monthly plans.</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'>Error loading active monthly plans.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="admin-section">
            <h3>Monthly Donations - Stopped</h3>
            <table class="admin-table">
                <thead>
                    <tr><th>User</th><th>Charity</th><th>Amount</th><th>Monthly Date</th><th>Stopped At</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String monthlyStoppedQuery = "SELECT d.amount, d.recurring_day, d.stopped_at, d.status, u.name as uname, u.email, c.name as cname FROM donations d JOIN users u ON d.user_id = u.id JOIN charities c ON d.charity_id = c.id WHERE d.frequency='Monthly' AND d.is_active = 0 ORDER BY d.stopped_at DESC";
                            Statement stmtMonthlyStopped = conn.createStatement();
                            ResultSet rsMonthlyStopped = stmtMonthlyStopped.executeQuery(monthlyStoppedQuery);
                            boolean hasStoppedMonthly = false;
                            while (rsMonthlyStopped.next()) {
                                hasStoppedMonthly = true;
                    %>
                    <tr>
                        <td><%= rsMonthlyStopped.getString("uname") %> (<%= rsMonthlyStopped.getString("email") %>)</td>
                        <td><%= rsMonthlyStopped.getString("cname") %></td>
                        <td>₹<%= String.format("%,.0f", rsMonthlyStopped.getDouble("amount")) %></td>
                        <td><%= rsMonthlyStopped.getInt("recurring_day") %></td>
                        <td><%= rsMonthlyStopped.getTimestamp("stopped_at") %></td>
                        <td><%= rsMonthlyStopped.getString("status") %></td>
                    </tr>
                    <%
                            }
                            if (!hasStoppedMonthly) {
                                out.println("<tr><td colspan='6' style='text-align:center;'>No stopped monthly plans.</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'>Error loading stopped monthly plans.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- Manage Charities -->
        <div class="admin-section">
            <h3>Manage Charities</h3>
            <table class="admin-table">
                <thead>
                    <tr><th>ID</th><th>Name</th><th>Cause</th><th>Goal</th><th>Raised</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String manageQuery = "SELECT * FROM charities";
                            Statement stmtManage = conn.createStatement();
                            ResultSet rsManage = stmtManage.executeQuery(manageQuery);
                            while (rsManage.next()) {
                    %>
                    <tr>
                        <td><%= rsManage.getInt("id") %></td>
                        <td><%= rsManage.getString("name") %></td>
                        <td><%= rsManage.getString("cause") %></td>
                        <td>₹<%= String.format("%,.0f", rsManage.getDouble("goal_amount")) %></td>
                        <td>₹<%= String.format("%,.0f", rsManage.getDouble("raised_amount")) %></td>
                        <td>
                            <a href="edit_charity.jsp?id=<%= rsManage.getInt("id") %>" class="btn-sm btn-edit">Edit</a>
                            <a href="delete_charity.jsp?id=<%= rsManage.getInt("id") %>"
                               class="btn-sm btn-delete btn-confirm-delete"
                               data-name="<%= rsManage.getString("name") %>">Delete</a>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Error manage: " + e.getMessage());
                        }
                    %>
                </tbody>
            </table>
            <div class="admin-actions">
                <a href="add_charity.jsp" class="btn-primary">Add New Charity</a>
            </div>
        </div>

        <!-- Manage Users -->
        <div class="admin-section">
            <h3>Manage Users</h3>
            <table class="admin-table">
                <thead>
                    <tr><th>ID</th><th>Name</th><th>Email</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String usersQuery = "SELECT id, name, email FROM users WHERE role = 'user' ORDER BY id DESC";
                            Statement stmtUsers = conn.createStatement();
                            ResultSet rsUsers = stmtUsers.executeQuery(usersQuery);
                            boolean anyUser = false;
                            while (rsUsers.next()) {
                                anyUser = true;
                    %>
                    <tr>
                        <td><%= rsUsers.getInt("id") %></td>
                        <td><%= rsUsers.getString("name") %></td>
                        <td><%= rsUsers.getString("email") %></td>
                        <td>
                            <a href="edit_user.jsp?id=<%= rsUsers.getInt("id") %>" class="btn-sm btn-edit">Edit</a>
                            <a href="delete_user.jsp?id=<%= rsUsers.getInt("id") %>"
                               class="btn-sm btn-delete btn-confirm-delete"
                               data-name="<%= rsUsers.getString("name") %>">Delete</a>
                        </td>
                    </tr>
                    <%
                            }
                            if (!anyUser) {
                                out.println("<tr><td colspan='5' style='text-align:center;color:#64748b;'>No users found.</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5'>Error loading users: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (conn != null) conn.close();
                        }
                    %>
                </tbody>
            </table>
        </div>

    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
