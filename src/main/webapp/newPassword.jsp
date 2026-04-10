<%

int userOtp =
Integer.parseInt(
request.getParameter("userOtp"));

int realOtp =
(Integer) session.getAttribute("otp");

if (userOtp == realOtp) {

%>

<form action="updatePassword.jsp"
      method="post">

<label>New Password</label>

<input type="password"
       name="password"
       required>

<button type="submit">
Update Password
</button>

</form>

<%

} else {

out.println("Invalid OTP");

}

%>