<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Add Charity" />
    <jsp:param name="cssFile" value="add_charity.css" />
    <jsp:param name="jsFile" value="add_charity.js" />
</jsp:include>

        <div class="form-container">
            <h2>Add New Charity</h2>
            <form action="add_charity_process.jsp" method="post">
                <div class="form-group">
                    <label for="name">Charity Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="cause">Cause</label>
                    <input type="text" id="cause" name="cause" required>
                </div>
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="5" required></textarea>
                </div>
                <div class="form-group">
                    <label for="location">Location</label>
                    <input type="text" id="location" name="location" placeholder="e.g., Pan India" required>
                </div>
                <div class="form-group">
                    <label for="image_url">Image URL (Poster)</label>
                    <input type="text" id="image_url" name="image_url" placeholder="https://example.com/image.jpg" required>
                </div>
                <div class="form-group">
                    <label for="goal_amount">Goal Amount (₹)</label>
                    <input type="number" id="goal_amount" name="goal_amount" placeholder="e.g. 10000" required>
                </div>
                <button type="submit" class="form-submit">Add Charity</button>
            </form>
            <div class="back-link">
                <a href="admin_dashboard.jsp"><i class="fas fa-arrow-left"></i> Back to Admin Dashboard</a>
            </div>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
