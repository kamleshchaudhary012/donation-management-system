<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Admin Login" />
    <jsp:param name="cssFile" value="admin_login.css" />
    <jsp:param name="jsFile" value="admin_login.js" />
</jsp:include>

        <div class="form-container">
            <h2 style="color: #0f172a;">Admin Access</h2>
            <%
                String error = request.getParameter("error");
                if (error != null) {
            %>
                <p style="color: red; text-align: center; margin-bottom: 15px;">Invalid admin credentials</p>
            <% } %>
            <form action="admin_login_process.jsp" method="post">
                <div class="form-group">
                    <label for="email">Admin Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <button type="submit" class="form-submit">Log In to Admin Panel</button>
            </form>
            <div class="form-footer">
                <p><a href="login.jsp">Back to Donor Login</a></p>
            </div>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
