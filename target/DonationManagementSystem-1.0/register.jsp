<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Register" />
    <jsp:param name="cssFile" value="register.css" />
    <jsp:param name="jsFile" value="register.js" />
</jsp:include>

        <div class="form-container">
            <h2>Join CharityX</h2>
            <%
                String error = request.getParameter("error");
                if ("exists".equals(error)) {
            %>
                <p style="color: red; text-align: center; margin-bottom: 15px;">Email already registered. Please login.</p>
            <% } else if (error != null) { %>
                <p style="color: red; text-align: center; margin-bottom: 15px;">Registration failed. Please try again.</p>
            <% } %>
            <form action="register_process.jsp" method="post">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="confirm-password">Confirm Password</label>
                    <input type="password" id="confirm-password" name="confirm-password" required>
                </div>
                <button type="submit" class="form-submit">Register</button>
            </form>
            <div class="form-footer">
                <p>Already have an account? <a href="login.jsp">Login here</a></p>
            </div>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
