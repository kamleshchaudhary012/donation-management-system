<jsp:include page="header.jsp"/>

<div class="form-container">

<h2>Verify OTP</h2>

<form action="newPassword.jsp"
      method="post">

<label>Enter OTP</label>

<input type="number"
       name="userOtp"
       required>

<button type="submit">
Verify OTP
</button>

</form>

</div>

<jsp:include page="footer.jsp"/>