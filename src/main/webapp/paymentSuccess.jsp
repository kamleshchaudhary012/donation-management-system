<%@ page import="java.sql.*" %>

<%

    String paymentId
            = request.getParameter("payment_id");

    String dbUrl
            = "jdbc:mysql://localhost:3306/charityx_db";

    Connection conn = DriverManager.getConnection(
                    dbUrl, "root", ""
            );

    PreparedStatement ps= conn.prepareStatement("INSERT INTO donations(payment_id) VALUES(?)"
            );
    ps.setString(1, paymentId);
    ps.executeUpdate();

%>

<h2>
    Thank You for Donation ??
</h2>