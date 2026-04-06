<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Contact Us" />
    <jsp:param name="cssFile" value="contact.css" />
    <jsp:param name="jsFile" value="contact.js" />
</jsp:include>

        <div class="form-container">
            <h2>Contact Us</h2>
            <form action="contact_process.jsp" method="post">
                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="subject">Subject</label>
                    <input type="text" id="subject" name="subject" required>
                </div>
                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" rows="5" required></textarea>
                </div>
                <button type="submit" class="form-submit">Send Message</button>
            </form>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
