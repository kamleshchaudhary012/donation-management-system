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
    // Aiven MySQL Connection Details
    String dbUrl = "jdbc:mysql://mysql-31d74879-donation-project.a.aivencloud.com:27685/defaultdb?useSSL=false&allowPublicKeyRetrieval=true";
    String dbUser = "avnadmin";

    // Password from environment variable (IMPORTANT)
    String dbPass = System.getenv("DB_PASSWORD");

    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        if (dbPass == null || dbPass.isEmpty()) {
            out.println("Error: DB_PASSWORD not set ?");
        } else {
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            if (conn != null) {
                // Connection success (don't print in production)
                //out.println("DB Connected Successfully ?");
            }
        }

    } catch (Exception e) {
        out.println("Connection Error: " + e.getMessage());
    }
%>