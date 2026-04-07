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

<%--<%@ page import="java.sql.*" %>
<%
String dbUrl = "jdbc:mysql://mysql-31d74879-donation-project.a.aivencloud.com:27685/defaultdb?sslMode=VERIFY_CA&enabledTLSProtocols=TLSv1.2&allowPublicKeyRetrieval=true";
String dbUser = "avnadmin";
String dbPass = System.getenv("DB_PASSWORD");

Connection conn = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    // SSL properties (IMPORTANT ?)
    java.util.Properties props = new java.util.Properties();
    props.setProperty("user", dbUser);
    props.setProperty("password", dbPass);
    props.setProperty("sslMode", "VERIFY_CA");

    conn = DriverManager.getConnection(dbUrl, props);

    if (conn != null) {
        out.println("DB CONNECTED SUCCESS ?");
    }

} catch (Exception e) {
    out.println("Connection Error: " + e.getMessage());
}
%>--%>

<%@ page import="java.sql.*" %>
<%
    String dbUrl = "jdbc:mysql://mysql-31d74879-donation-project.a.aivencloud.com:27685/defaultdb?useSSL=true&requireSSL=true&verifyServerCertificate=false&allowPublicKeyRetrieval=true&connectTimeout=10000&socketTimeout=10000";

String dbUser = "avnadmin";
String dbPass = System.getenv("DB_PASSWORD");

Connection conn = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    java.util.Properties props = new java.util.Properties();
    props.setProperty("user", dbUser);
    props.setProperty("password", dbPass);
    props.setProperty("useSSL", "true");
    props.setProperty("requireSSL", "true");
    props.setProperty("verifyServerCertificate", "false");

    conn = DriverManager.getConnection(dbUrl, props);

    if (conn != null) {
//        out.println("DB CONNECTED SUCCESS ");
    }

} catch (Exception e) {
    out.println("Connection Error: " + e.getMessage());
}
%>