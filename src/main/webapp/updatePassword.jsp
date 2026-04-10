<%@ page import="java.sql.*" %>

<%@ include file="db_config.jsp" %>

<%    String email
            = (String) session.getAttribute("resetEmail");

    String password
            = request.getParameter("password");

    try {

        PreparedStatement ps
                = conn.prepareStatement(
                        "UPDATE users SET password=? WHERE email=?");

        ps.setString(1, password);
        ps.setString(2, email);

        ps.executeUpdate();

        response.sendRedirect(
                "login.jsp?msg=reset_success");

    } catch (Exception e) {

        out.println("Error: " + e);

    }

%>