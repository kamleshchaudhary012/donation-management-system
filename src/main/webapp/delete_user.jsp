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
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            int userId = Integer.parseInt(idParam.trim());
            // Delete user's donations first
            PreparedStatement pstmtDel = conn.prepareStatement("DELETE FROM donations WHERE user_id = ?");
            pstmtDel.setInt(1, userId);
            pstmtDel.executeUpdate();
            pstmtDel.close();

            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM users WHERE id = ? AND role = 'user'");
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
            pstmt.close();
        } catch (Exception e) {
            // log silently
        } finally {
            if (conn != null) conn.close();
        }
    }
    response.sendRedirect("admin_dashboard.jsp");
%>
