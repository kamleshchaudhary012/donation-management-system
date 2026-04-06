<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if (name != null && email != null && password != null) {
        try {
            // Check if email already exists
            String checkQuery = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkPstmt = conn.prepareStatement(checkQuery);
            checkPstmt.setString(1, email);
            ResultSet checkRs = checkPstmt.executeQuery();
            
            if (checkRs.next()) {
                response.sendRedirect("register.jsp?error=exists");
            } else {
                String query = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'user')";
                PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
                pstmt.setString(1, name);
                pstmt.setString(2, email);
                pstmt.setString(3, password);
                int affectedRows = pstmt.executeUpdate();
                
                if (affectedRows > 0) {
                    ResultSet generatedKeys = pstmt.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        session.setAttribute("userId", generatedKeys.getInt(1));
                        session.setAttribute("userEmail", email);
                        session.setAttribute("userName", name);
                        response.sendRedirect("dashboard.jsp");
                    }
                } else {
                    response.sendRedirect("register.jsp?error=1");
                }
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("register.jsp?error=1");
    }
%>
