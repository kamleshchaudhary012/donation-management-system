<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    // Only allow admin
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            int charityId = Integer.parseInt(idParam.trim());
            // Delete related donations first to avoid FK constraint
            PreparedStatement pstmtDel = conn.prepareStatement("DELETE FROM donations WHERE charity_id = ?");
            pstmtDel.setInt(1, charityId);
            pstmtDel.executeUpdate();
            pstmtDel.close();

            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM charities WHERE id = ?");
            pstmt.setInt(1, charityId);
            pstmt.executeUpdate();
            pstmt.close();
        } catch (Exception e) {
            // log error silently
        } finally {
            if (conn != null) conn.close();
        }
    }
    response.sendRedirect("admin_dashboard.jsp");
%>
