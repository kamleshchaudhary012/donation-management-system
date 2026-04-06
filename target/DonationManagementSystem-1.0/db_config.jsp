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
    String dbUrl = "jdbc:mysql://mysql-31d74879-donation-project.a.aivencloud.com:27685/defaultdb?useSSL=false&allowPublicKeyRetrieval=true";
    String dbUser = "avnadmin";
    String dbPass = "AVNS_KMhIEZRrjGkFHQEIGcb"; // yaha apna Aiven password daalo

    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        if (conn != null) {
            out.println("DB Connected Successfully ?");
        }

    } catch (Exception e) {
        out.println("Connection Error: " + e.getMessage());
    }
%>