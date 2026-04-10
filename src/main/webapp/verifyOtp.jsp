<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="Verify OTP - CharityX" />
    <jsp:param name="cssFile" value="register.css" />
</jsp:include>

<div class="form-container">
    <h2>Verify OTP</h2>
    
    <%
        String msg = request.getParameter("msg");
        
        if ("otp_sent".equals(msg)) {
    %>
        <p style="color: green; text-align: center; margin-bottom: 15px;">
            OTP sent successfully! Check your email.
        </p>
    <%
        } else if ("invalid".equals(msg)) {
    %>
        <p style="color: red; text-align: center; margin-bottom: 15px;">
             Invalid OTP! Please try again.
        </p>
    <%
        } else if ("expired".equals(msg)) {
    %>
        <p style="color: red; text-align: center; margin-bottom: 15px;">
             OTP expired! Please request a new one.
        </p>
    <%
        }
    %>
    
    <form action="newPassword.jsp" method="post">
        <div class="form-group">
            <label for="userOtp">Enter OTP</label>
            <input type="number" id="userOtp" name="userOtp" required placeholder="Enter 6-digit OTP">
        </div>
        
        <button type="submit" class="form-submit">Verify OTP</button>
    </form>
    
    <div class="form-footer">
        <p>Didn't receive OTP? <a href="forget.jsp">Request again</a></p>
    </div>
</div>

<jsp:include page="footer.jsp" />