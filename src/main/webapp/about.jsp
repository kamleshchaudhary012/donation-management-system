<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<jsp:include page="footer.jsp" />--%>



<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="SupportX - About Us" />
    <jsp:param name="cssFile" value="about.css" />
    <jsp:param name="jsFile" value="about.js" />
</jsp:include>

<div class="about-container">
    <h2>About SupportX</h2>
    
    <div class="about-content">

        <p>
        SupportX is an academic web-based project developed using 
        JSP and Servlet technology. This platform demonstrates 
        how an online support and contribution system works.
        </p>

        <p>
        The purpose of this website is educational. It helps students 
        understand how payment gateway integration, user login, 
        and contribution management systems function in real-world applications.
        </p>

        <h3>Project Objective</h3>

        <p>
        The main objective of this project is to provide a practical 
        demonstration of web technologies such as JSP, Servlet, 
        database connectivity, and payment integration.
        </p>

        <h3>Important Notice</h3>

        <p style="color:red; font-weight:bold;">
        This website is created for educational and demonstration purposes only.
        No real donations are collected on this platform.
        All payments are processed in test mode only.
        </p>

    </div>
</div>

</div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />