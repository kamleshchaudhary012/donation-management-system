<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - About Us" />
    <jsp:param name="cssFile" value="about.css" />
    <jsp:param name="jsFile" value="about.js" />
</jsp:include>

        <div class="about-container">
            <h2>About CharityX</h2>
            <div class="about-content">
                <p>At CharityX, we believe in the power of giving and its ability to transform lives. Founded in 2026, we've built a platform that connects passionate donors with verified NGOs to create a meaningful impact on society.</p>
                <p>Our mission is to make philanthropy accessible, transparent, and impactful. We carefully vet every organization on our platform to ensure your contributions reach those who need them most.</p>
                
                <h3>Our Vision</h3>
                <p>A world where every individual has the opportunity to thrive, regardless of their circumstances. We aim to bridge the gap between resources and requirements through technology and community participation.</p>
                
                <h3>Our Impact</h3>
                <div class="impact-grid">
                    <div class="impact-card">
                        <i class="fas fa-hand-holding-heart"></i>
                        <h4>10K+</h4>
                        <p>Total Donors</p>
                    </div>
                    <div class="impact-card">
                        <i class="fas fa-building"></i>
                        <h4>50+</h4>
                        <p>Verified NGO Partners</p>
                    </div>
                    <div class="impact-card">
                        <i class="fas fa-smile"></i>
                        <h4>1M+</h4>
                        <p>Lives Impacted</p>
                    </div>
                </div>
            </div>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
