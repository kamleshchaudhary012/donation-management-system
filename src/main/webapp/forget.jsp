<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="Forgot Password - CharityX" />
    <jsp:param name="cssFile" value="login.css" />
</jsp:include>

<div class="form-container">
    <h2>Forgot Password</h2>



    <%
        String msg = request.getParameter("msg");

        if ("not_found".equals(msg)) {
    %>
    <p style="color:red; text-align:center;">
        Email not found in our system.
    </p>
    <%
    } else if ("success".equals(msg)) {
    %>
    <p style="color:green; text-align:center;">
        Password updated successfully. Please login.
    </p>
    <%
        }
    %>

    <form action="sendOtp.jsp" method="post">

        <label>Email Address</label>

        <input type="email"
               name="email"
               required placeholder="Enter Email Address">

        <button type="submit">
            Send OTP
        </button>

    </form>

    <div class="form-footer">
        <p>
            Remember password ?
            <a href="login.jsp">Login here</a>
        </p>
    </div>

</div>


<jsp:include page="footer.jsp" />