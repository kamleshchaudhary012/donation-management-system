<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");

    if (idParam != null && name != null && email != null
            && !idParam.trim().isEmpty() && !name.trim().isEmpty() && !email.trim().isEmpty()) {
        try {
            int userId = Integer.parseInt(idParam.trim());
            PreparedStatement pstmt = conn.prepareStatement(
                "UPDATE users SET name = ?, email = ? WHERE id = ? AND role = 'user'"
            );
            pstmt.setString(1, name.trim());
            pstmt.setString(2, email.trim());
            pstmt.setInt(3, userId);
            pstmt.executeUpdate();
            pstmt.close();
        } catch (Exception e) {
            // ignore
        } finally {
            if (conn != null) conn.close();
        }
    }
    response.sendRedirect("admin_dashboard.jsp");
%>
