<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>

<%
    String email = (String) session.getAttribute("resetEmail");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    
    if (email == null || password == null) {
        response.sendRedirect("forget.jsp");
        return;
    }
    
    if (!password.equals(confirmPassword)) {
        response.sendRedirect("newPassword.jsp?msg=nomatch");
        return;
    }
    
    try {
        PreparedStatement ps = conn.prepareStatement("UPDATE users SET password=? WHERE email=?");
        ps.setString(1, password);
        ps.setString(2, email);
        
        int updated = ps.executeUpdate();
        
        if (updated > 0) {
            // Clear session attributes
            session.removeAttribute("otp");
            session.removeAttribute("resetEmail");
            session.removeAttribute("otpTimestamp");
            response.sendRedirect("login.jsp?msg=reset_success");
        } else {
            response.sendRedirect("newPassword.jsp?msg=update_failed");
        }
        
        ps.close();
        
    } catch (Exception e) {
        out.println("Error: " + e);
    }
%>