<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String name = request.getParameter("name");
    String cause = request.getParameter("cause");
    String description = request.getParameter("description");
    String location = request.getParameter("location");
    String imageUrl = request.getParameter("image_url");
    String goalStr = request.getParameter("goal_amount");
    
    if (name != null && cause != null && goalStr != null) {
        try {
            double goal = Double.parseDouble(goalStr);
            String query = "INSERT INTO charities (name, cause, description, location, image_url, goal_amount) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setString(2, cause);
            pstmt.setString(3, description);
            pstmt.setString(4, location);
            pstmt.setString(5, imageUrl);
            pstmt.setDouble(6, goal);
            pstmt.executeUpdate();
            
            response.sendRedirect("admin_dashboard.jsp?msg=added");
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("add_charity.jsp?error=missing_fields");
    }
%>
