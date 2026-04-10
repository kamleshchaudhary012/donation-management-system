<%@ page import="java.util.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>

<%

    String email = request.getParameter("email");

// Generate OTP
    Random rand = new Random();
    int otp = 100000 + rand.nextInt(900000);

// Save OTP in session
    session.setAttribute("otp", otp);
    session.setAttribute("resetEmail", email);

    final String fromEmail = "chaudharykamlesh185@gmail.com";
    final String password = "obep lcse gwryxomf";

    Properties props = new Properties();

    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.starttls.enable", "true");

    Session mailSession
            = Session.getInstance(props,
                    new javax.mail.Authenticator() {
                protected PasswordAuthentication
                        getPasswordAuthentication() {

                    return new PasswordAuthentication(
                            fromEmail,
                            password
                    );
                }
            });

    try {

        Message message
                = new MimeMessage(mailSession);

        message.setFrom(
                new InternetAddress(fromEmail));

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(email));

        message.setSubject("Password Reset OTP");

        message.setText(
                "Your OTP is: " + otp);

        Transport.send(message);

// Redirect to OTP page
        response.sendRedirect("verifyOtp.jsp");

    } catch (Exception e) {

        out.println("Error sending email: " + e);

    }

%>