<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if (email != null && !email.isEmpty() && password != null && !password.isEmpty()) {
        try {
            String query = "SELECT id, name FROM users WHERE email = ? AND password = ? AND role = 'admin'";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                session.setAttribute("adminId", rs.getInt("id"));
                session.setAttribute("adminEmail", email);
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("admin_login.jsp?error=1");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("admin_login.jsp?error=1");
    }
%>
