<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title != null ? param.title : "CharityX - Donation Management System"}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/${param.cssFile}">
    <script src="js/${param.jsFile}" defer></script>
</head>
<body>
    <div class="container">
        <div class="navbar">
            <div class="logo"><h1>CharityX</h1></div>
            <div class="nav-links">
                <a href="index.jsp">Donate</a>
                <a href="about.jsp">About</a>
                <%
                    String adminEmail = (String) session.getAttribute("adminEmail");
                    String userEmail = (String) session.getAttribute("userEmail");
                    String userName = (String) session.getAttribute("userName");

                    if (adminEmail != null) {
                        // Admin is logged in
                %>
                    <span class="nav-greeting">Hello, Admin</span>
                    <a href="profile.jsp" class="btn-login">Profile</a>
                    <a href="admin_dashboard.jsp" class="btn-login">Admin Panel</a>
                    <a href="admin_logout.jsp" class="btn-login btn-logout">Logout</a>
                <% } else if (userEmail != null) { %>
                    <span class="nav-greeting">Hello, <%= (userName != null ? userName : userEmail) %></span>
                    <a href="profile.jsp" class="btn-login">Profile</a>
                    <a href="dashboard.jsp" class="btn-login">Dashboard</a>
                    <a href="logout.jsp" class="btn-login btn-logout">Logout</a>
                <% } else { %>
                    <a href="login.jsp" class="btn-login">Login</a>
                <% } %>
            </div>
        </div>
