<%@ page import="java.sql.*" %>

<%

String email = request.getParameter("email");
String newPassword = request.getParameter("new_password");

Connection conn = null;
PreparedStatement ps = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/charity_db",
        "root",
        ""
    );

    // Check email exists
    ps = conn.prepareStatement(
        "SELECT * FROM users WHERE email=?"
    );

    ps.setString(1, email);

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {

        // Update password
        ps = conn.prepareStatement(
            "UPDATE users SET password=? WHERE email=?"
        );

        ps.setString(1, newPassword);
        ps.setString(2, email);

        ps.executeUpdate();

        response.sendRedirect(
            "forget.jsp?msg=success"
        );

    } else {

        response.sendRedirect(
            "forget.jsp?msg=not_found"
        );

    }

} catch (Exception e) {

    out.println(e);

}

%>