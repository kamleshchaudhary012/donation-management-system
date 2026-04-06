<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String donationIdStr = request.getParameter("donationId");
    if (donationIdStr != null && !donationIdStr.trim().isEmpty()) {
        try {
            int donationId = Integer.parseInt(donationIdStr);
            String q = "UPDATE donations SET is_active = 0, status = 'Stopped', stopped_at = NOW() WHERE id = ? AND user_id = ? AND frequency = 'Monthly'";
            PreparedStatement ps = conn.prepareStatement(q);
            ps.setInt(1, donationId);
            ps.setInt(2, userId);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            // ignore and continue redirect
        } finally {
            if (conn != null) conn.close();
        }
    }

    response.sendRedirect("dashboard.jsp");
%>
