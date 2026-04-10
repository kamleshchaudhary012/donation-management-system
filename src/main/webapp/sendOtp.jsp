<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ include file="db_config.jsp" %>

<%
    String email = request.getParameter("email");
    
    if (email == null || email.trim().isEmpty()) {
        response.sendRedirect("forget.jsp?msg=check_email");
        return;
    }
    
    // Check if email exists in database
    boolean emailExists = false;
    
    try {
        PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
        checkStmt.setString(1, email);
        ResultSet rs = checkStmt.executeQuery();
        
        if (rs.next()) {
            emailExists = true;
        }
        rs.close();
        checkStmt.close();
    } catch (Exception e) {
        out.println("Database error: " + e);
        return;
    }
    
    if (!emailExists) {
        response.sendRedirect("forget.jsp?msg=not_found");
        return;
    }
    
    // Generate OTP
    Random rand = new Random();
    int otp = 100000 + rand.nextInt(900000);
    
    // Save OTP in session
    session.setAttribute("otp", otp);
    session.setAttribute("resetEmail", email);
    session.setAttribute("otpTimestamp", System.currentTimeMillis());
    
    final String fromEmail = "chaudharykamlesh185@gmail.com";
    final String password = "obep lcse gwryxomf";
    
    Properties props = new Properties();
    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.starttls.enable", "true");
    
    Session mailSession = Session.getInstance(props,
        new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });
    
    try {
        Message message = new MimeMessage(mailSession);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
        message.setSubject("Password Reset OTP - CharityX");
        message.setText("Dear User,\n\nYour OTP for password reset is: " + otp + "\n\nThis OTP is valid for 10 minutes.\n\nRegards,\nCharityX Team");
        
        Transport.send(message);
        response.sendRedirect("verifyOtp.jsp?msg=otp_sent");
        
    } catch (Exception e) {
        out.println("Error sending email: " + e);
    }
%>