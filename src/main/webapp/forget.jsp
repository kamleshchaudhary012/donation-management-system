
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="Forgot Password - CharityX" />
    <jsp:param name="cssFile" value="register.css" />
</jsp:include>

<div class="form-container">
    <h2>Forgot Password</h2>
    
    <%
        String msg = request.getParameter("msg");
        
        if ("not_found".equals(msg)) {
    %>
        <p style="color: red; text-align: center; margin-bottom: 15px;">
             Email not found! Please <a href="register.jsp" style="color: red; text-decoration: underline;">register here</a>
        </p>
    <%
        } else if ("check_email".equals(msg)) {
    %>
        <p style="color: red; text-align: center; margin-bottom: 15px;">
            ⚠️ Please enter your email address
        </p>
    <%
        }
    %>
    
    <form action="sendOtp.jsp" method="post">
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" required placeholder="Enter your registered email">
        </div>
        
        <button type="submit" class="form-submit">Send OTP</button>
    </form>
    
    <div class="form-footer">
        <p>Remember password? <a href="login.jsp">Login here</a></p>
        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>
</div>

<jsp:include page="footer.jsp" />