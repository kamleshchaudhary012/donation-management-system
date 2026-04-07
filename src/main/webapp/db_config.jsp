<%--<%@ page import="java.sql.*" %>
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
%>--%>


<%@ page import="java.sql.*" %>
<%
    String dbUrl = "jdbc:mysql://mysql-31d74879-donation-project.a.aivencloud.com:27685/defaultdb?sslMode=REQUIRED";
    String dbUser = "avnadmin";

    // Environment variable password
    String dbPass = System.getenv("DB_PASSWORD");
out.println("DB_PASS: " + dbPass);
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        if (dbPass == null || dbPass.isEmpty()) {
            out.println("Error: DB_PASSWORD not set ");
        } else {
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            if (conn != null) {
                out.println("DB Connected Successfully ");
            }
        }

    } catch (Exception e) {
        out.println("Connection Error: " + e.getMessage());
    }
%>