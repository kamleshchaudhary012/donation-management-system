<%@ page import="java.sql.*" %>
<%
    // Database connection details
    // Update these values to match your MySQL setup in NetBeans
    String dbUrl = "jdbc:mysql://localhost:3306/charityx_db"; 
    String dbUser = "root";
    String dbPass = ""; // Your MySQL password

    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
    } catch (Exception e) {
        out.println("Connection Error: " + e.getMessage());
    }
%>