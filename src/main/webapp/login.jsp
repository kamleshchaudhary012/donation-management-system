<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<--<!-- redirection on after login on selected.... -->
<%
    String redirect = request.getParameter("redirect");
    if (redirect != null) {
        session.setAttribute("redirectAfterLogin", redirect);
    }
%>


<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Login" />
    <jsp:param name="cssFile" value="login.css" />
    <jsp:param name="jsFile" value="login.js" />
</jsp:include>

<div class="form-container">
    <h2>Welcome Back</h2>

    <%
        String error = request.getParameter("error");
        if ("not_found".equals(error)) {
    %>
    <p style="color: red; text-align: center; margin-bottom: 15px;">Account not found. Please register.</p>
    <% } else if ("wrong_pass".equals(error)) { %>
    <p style="color: red; text-align: center; margin-bottom: 15px;">Incorrect password.</p>
    <% } else if (error != null) { %>
    <p style="color: red; text-align: center; margin-bottom: 15px;">Invalid login attempt.</p>
    <% }%>
    <form action="login_process.jsp" method="post">
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit" class="form-submit">Log In</button>
    </form>
    <div class="form-footer">
        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>
</div>
</div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
