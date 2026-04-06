<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String idParam = request.getParameter("id");
        StringBuilder json = new StringBuilder();
        json.append("{\"success\":true,\"data\":[");

        if (idParam != null && !idParam.trim().isEmpty()) {
            String query = "SELECT id, goal_amount, raised_amount FROM charities WHERE id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(idParam.trim()));
            rs = pstmt.executeQuery();
        } else {
            String query = "SELECT id, goal_amount, raised_amount FROM charities";
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
        }

        boolean first = true;
        while (rs.next()) {
            int id = rs.getInt("id");
            double goal = rs.getDouble("goal_amount");
            double raised = rs.getDouble("raised_amount");
            double progress = (goal > 0) ? Math.min((raised / goal) * 100.0, 100.0) : 0.0;

            if (!first) json.append(",");
            first = false;

            json.append("{");
            json.append("\"id\":").append(id).append(",");
            json.append("\"goal\":").append(String.format(java.util.Locale.US, "%.2f", goal)).append(",");
            json.append("\"raised\":").append(String.format(java.util.Locale.US, "%.2f", raised)).append(",");
            json.append("\"progress\":").append(String.format(java.util.Locale.US, "%.1f", progress));
            json.append("}");
        }

        json.append("]}");
        out.print(json.toString());
    } catch (Exception e) {
        out.print("{\"success\":false,\"message\":\"Unable to load charity progress.\"}");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
