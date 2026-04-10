<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String userOtpStr = request.getParameter("userOtp");
    
    // Check if OTP exists in session
    if (session.getAttribute("otp") == null) {
        response.sendRedirect("forget.jsp?msg=session_expired");
        return;
    }
    
    // Check OTP expiry (10 minutes = 600000 milliseconds)
    Long otpTimestamp = (Long) session.getAttribute("otpTimestamp");
    if (otpTimestamp != null && (System.currentTimeMillis() - otpTimestamp) > 600000) {
        session.removeAttribute("otp");
        session.removeAttribute("otpTimestamp");
        response.sendRedirect("verifyOtp.jsp?msg=expired");
        return;
    }
    
    int userOtp = Integer.parseInt(userOtpStr);
    int realOtp = (Integer) session.getAttribute("otp");
    
    if (userOtp == realOtp) {
        // OTP is valid, show password reset form
%>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="Reset Password - CharityX" />
    <jsp:param name="cssFile" value="register.css" />
</jsp:include>

<div class="form-container">
    <h2>Reset Password</h2>
    
    <%
        String msg = request.getParameter("msg");
        
        if ("nomatch".equals(msg)) {
    %>
        <p style="color: red; text-align: center; margin-bottom: 15px;">
             Passwords do not match! Please try again.
        </p>
    <%
        } else if ("weak_password".equals(msg)) {
    %>
        <p style="color: red; text-align: center; margin-bottom: 15px;">
             Password must be at least 6 characters long!
        </p>
    <%
        } else if ("password_empty".equals(msg)) {
    %>
        <p style="color: red; text-align: center; margin-bottom: 15px;">
             Please enter a password!
        </p>
    <%
        } else if ("update_failed".equals(msg)) {
    %>
        <p style="color: red; text-align: center; margin-bottom: 15px;">
             Failed to update password. Please try again!
        </p>
    <%
        } else if ("success".equals(msg)) {
    %>
        <p style="color: green; text-align: center; margin-bottom: 15px;">
            Password updated successfully! Please login.
        </p>
    <%
        }
    %>
    
    <form action="updatePassword.jsp" method="post" onsubmit="return validatePassword()">
        <div class="form-group">
            <label for="password">New Password</label>
            <input type="password" id="password" name="password" required placeholder="Enter new password">
            <small style="color: #666; font-size: 12px; display: block; margin-top: 5px;">
                Password must be at least 6 characters long
            </small>
        </div>
        
        <div class="form-group">
            <label for="confirmPassword">Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Confirm new password">
        </div>
        
        <button type="submit" class="form-submit">Update Password</button>
    </form>
    
    <div class="form-footer">
        <p><a href="login.jsp">Back to Login</a></p>
    </div>
</div>

<script>
function validatePassword() {
    var password = document.getElementById('password').value;
    var confirmPassword = document.getElementById('confirmPassword').value;
    
    if (password === "") {
        alert('Please enter a password!');
        return false;
    }
    
    if (password.length < 6) {
        alert('Password must be at least 6 characters long!');
        return false;
    }
    
    if (password !== confirmPassword) {
        alert('Passwords do not match!');
        return false;
    }
    
    return true;
}
</script>

<jsp:include page="footer.jsp" />

<%
    } else {
        // Invalid OTP
        response.sendRedirect("verifyOtp.jsp?msg=invalid");
    }
%>