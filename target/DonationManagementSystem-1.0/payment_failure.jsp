<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Donation Failed" />
    <jsp:param name="cssFile" value="payment_failure.css" />
    <jsp:param name="jsFile" value="payment_failure.js" />
</jsp:include>

        <div class="status-container">
            <i class="fas fa-times-circle"></i>
            <h2>Donation Failed</h2>
            <p>We're sorry, but your transaction could not be completed at this time. Please try again or contact your bank if the issue persists.</p>
            <div class="status-actions">
                <a href="charity.jsp" class="btn-primary">Try Again</a>
                <a href="index.jsp" style="display: block; margin-top: 20px; color: #f97316; text-decoration: none; font-weight: 600;">Back to Home</a>
            </div>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
