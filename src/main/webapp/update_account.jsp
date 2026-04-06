<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String action = request.getParameter("action");

    if ("user_profile".equals(action)) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            String check = "SELECT id FROM users WHERE email = ? AND id <> ?";
            PreparedStatement cps = conn.prepareStatement(check);
            cps.setString(1, email);
            cps.setInt(2, userId);
            ResultSet crs = cps.executeQuery();
            if (crs.next()) {
                response.sendRedirect("dashboard.jsp?profileError=email_exists");
                return;
            }
            crs.close();
            cps.close();

            String q;
            PreparedStatement ps;
            if (password != null && !password.trim().isEmpty()) {
                q = "UPDATE users SET name = ?, email = ?, password = ? WHERE id = ? AND role = 'user'";
                ps = conn.prepareStatement(q);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setInt(4, userId);
            } else {
                q = "UPDATE users SET name = ?, email = ? WHERE id = ? AND role = 'user'";
                ps = conn.prepareStatement(q);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setInt(3, userId);
            }
            ps.executeUpdate();
            ps.close();

            session.setAttribute("userName", name);
            session.setAttribute("userEmail", email);
            String redirectTo = request.getParameter("redirectTo");
            if ("profile".equals(redirectTo)) {
                response.sendRedirect("profile.jsp?profileUpdated=1");
            } else {
                response.sendRedirect("dashboard.jsp?profileUpdated=1");
            }
            return;
        } catch (Exception e) {
            response.sendRedirect("dashboard.jsp?profileError=1");
            return;
        } finally {
            if (conn != null) conn.close();
        }
    }

    if ("admin_password".equals(action)) {
        String adminEmail = (String) session.getAttribute("adminEmail");
        if (adminEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        try {
            String check = "SELECT id FROM users WHERE email = ? AND password = ? AND role = 'admin'";
            PreparedStatement cps = conn.prepareStatement(check);
            cps.setString(1, adminEmail);
            cps.setString(2, currentPassword);
            ResultSet crs = cps.executeQuery();
            if (!crs.next()) {
                response.sendRedirect("admin_dashboard.jsp?pwdError=wrong_current");
                return;
            }
            int adminId = crs.getInt("id");
            crs.close();
            cps.close();

            String update = "UPDATE users SET password = ? WHERE id = ? AND role = 'admin'";
            PreparedStatement ups = conn.prepareStatement(update);
            ups.setString(1, newPassword);
            ups.setInt(2, adminId);
            ups.executeUpdate();
            ups.close();

            String redirectTo2 = request.getParameter("redirectTo");
            if ("profile".equals(redirectTo2)) {
                response.sendRedirect("profile.jsp?pwdUpdated=1");
            } else {
                response.sendRedirect("admin_dashboard.jsp?pwdUpdated=1");
            }
            return;
        } catch (Exception e) {
            response.sendRedirect("admin_dashboard.jsp?pwdError=1");
            return;
        } finally {
            if (conn != null) conn.close();
        }
    }

    if (conn != null) conn.close();
    response.sendRedirect("index.jsp");
%>
