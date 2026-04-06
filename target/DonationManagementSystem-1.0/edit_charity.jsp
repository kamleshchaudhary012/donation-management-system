<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    String charityId = request.getParameter("id");
    String name = "", cause = "", desc = "", loc = "", imageUrl = "";
    double goal = 0;

    if (charityId != null) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String query = "SELECT * FROM charities WHERE id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(charityId));
            rs = pstmt.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                cause = rs.getString("cause");
                desc = rs.getString("description");
                loc = rs.getString("location");
                imageUrl = rs.getString("image_url");
                goal = rs.getDouble("goal_amount");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ex) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) {}
            if (conn != null) try { conn.close(); } catch (SQLException ex) {}
        }
    }
%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Edit Charity" />
    <jsp:param name="cssFile" value="edit_charity.css" />
    <jsp:param name="jsFile" value="edit_charity.js" />
</jsp:include>

        <div class="form-container">
            <h2>Edit Charity (ID: <%= (charityId != null ? charityId : "N/A") %>)</h2>
            <form action="edit_charity_process.jsp" method="post">
                <input type="hidden" name="id" value="<%= (charityId != null ? charityId : "") %>">
                <div class="form-group">
                    <label for="name">Charity Name</label>
                    <input type="text" id="name" name="name" value="<%= name %>" required>
                </div>
                <div class="form-group">
                    <label for="cause">Cause</label>
                    <input type="text" id="cause" name="cause" value="<%= cause %>" required>
                </div>
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="5" required><%= desc %></textarea>
                </div>
                <div class="form-group">
                    <label for="location">Location</label>
                    <input type="text" id="location" name="location" value="<%= loc %>" required>
                </div>
                <div class="form-group">
                    <label for="image_url">Image URL (Poster)</label>
                    <input type="text" id="image_url" name="image_url" value="<%= imageUrl %>" required>
                </div>
                <div class="form-group">
                    <label for="goal_amount">Goal Amount (₹)</label>
                    <input type="number" id="goal_amount" name="goal_amount" value="<%= (int)goal %>" required>
                </div>
                <button type="submit" class="form-submit">Update Charity</button>
            </form>
            <div class="back-link">
                <a href="admin_dashboard.jsp"><i class="fas fa-arrow-left"></i> Back to Admin Dashboard</a>
            </div>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
