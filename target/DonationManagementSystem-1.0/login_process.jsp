<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if (email != null && !email.isEmpty() && password != null && !password.isEmpty()) {
        try {
            String query = "SELECT id, name, role FROM users WHERE email = ? AND password = ? LIMIT 1";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");

                if ("admin".equalsIgnoreCase(role)) {
                    // Keep admin and user sessions isolated.
                    session.removeAttribute("userId");
                    session.removeAttribute("userEmail");
                    session.removeAttribute("userName");

                    session.setAttribute("adminId", rs.getInt("id"));
                    session.setAttribute("adminEmail", email);
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    session.removeAttribute("adminId");
                    session.removeAttribute("adminEmail");

                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userName", rs.getString("name"));
                    // After login, show the landing page first.
                    response.sendRedirect("index.jsp");
                }
            } else {
                String checkQuery = "SELECT id FROM users WHERE email = ? LIMIT 1";
                PreparedStatement checkPstmt = conn.prepareStatement(checkQuery);
                checkPstmt.setString(1, email);
                ResultSet checkRs = checkPstmt.executeQuery();

                if (!checkRs.next()) {
                    response.sendRedirect("login.jsp?error=not_found");
                } else {
                    response.sendRedirect("login.jsp?error=wrong_pass");
                }
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("login.jsp?error=1");
    }
%>
