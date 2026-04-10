/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author chaudharykamlesh
 */
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author chaudharykamlesh
 */

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtility {

    // Gmail SMTP settings
    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587";

    // Your Gmail credentials
    private static final String FROM_EMAIL =
            "chaudharykamlesh185@gmail.com";

    private static final String APP_PASSWORD =
            "obep lcse gwryxomf";

    public static void sendOTP(
            String toEmail,
            String otp
    ) throws Exception {

        // SMTP Properties
        Properties props = new Properties();

        props.put(
                "mail.smtp.host",
                HOST
        );

        props.put(
                "mail.smtp.port",
                PORT
        );

        props.put(
                "mail.smtp.auth",
                "true"
        );

        props.put(
                "mail.smtp.starttls.enable",
                "true"
        );

        // Create Session
        Session session =
                Session.getInstance(
                        props,
                        new Authenticator() {

                            protected PasswordAuthentication
                            getPasswordAuthentication() {

                                return new PasswordAuthentication(
                                        FROM_EMAIL,
                                        APP_PASSWORD
                                );

                            }

                        }
                );

        // Create Email Message
        Message message =
                new MimeMessage(session);

        message.setFrom(
                new InternetAddress(FROM_EMAIL)
        );

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(toEmail)
        );

        message.setSubject(
                "Password Reset OTP - Donation System"
        );

        message.setText(
                "Your OTP for password reset is: "
                        + otp
                        + "\n\nDo not share this OTP."
        );

        // Send Email
        Transport.send(message);

        System.out.println(
                "OTP Email Sent Successfully!"
        );
    }
}