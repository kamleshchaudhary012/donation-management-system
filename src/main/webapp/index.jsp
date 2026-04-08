<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Home" />
    <jsp:param name="cssFile" value="index.css" />
    <jsp:param name="jsFile" value="index.js" />
</jsp:include>
<%@ include file="db_config.jsp" %>

        <div class="banner">
            <div class="banner-content">
                <h2>Help provide <span>life-saving treatment</span> and support to those in need</h2>
                <p>Every contribution brings healing, dignity, and hope. Join thousands of donors changing lives today.</p>
                <div class="banner-buttons">
                    <a href="charity.jsp" class="btn-primary">Support Now</a>
                    <button class="btn-outline" id="monthlyBtn">Give Monthly</button>
                </div>
            </div>
            <div class="banner-image">
                <i class="fas fa-hand-holding-heart"></i>
            </div>
        </div>

        <div class="section-title">Our trusted NGO partners</div>
        <div class="charity-grid">
            <%
                PreparedStatement pstmtIndex = null;
                ResultSet rsIndex = null;
                try {
                    if (conn != null) {
                        String query = "SELECT * FROM charities";
                        pstmtIndex = conn.prepareStatement(query);
                        rsIndex = pstmtIndex.executeQuery();
                        while (rsIndex.next()) {
            %>
            <div class="charity-card">
                <div class="card-img" data-img="<%= rsIndex.getString("image_url") %>" style="background-size: cover; background-position: center; height: 200px;"></div>
                <div class="card-content">
                    <h3><%= rsIndex.getString("name") %></h3>
                    <p><%= rsIndex.getString("description") %></p>
                    <a data-id="<%= rsIndex.getInt("id") %>" class="card-link">Support Us to this cause →</a>
                </div>
            </div>
            <%
                        }
                    } else {
                        out.println("<p>Database connection unavailable. Please check your setup.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p>Error fetching charities: " + e.getMessage() + "</p>");
                } finally {
                    if (rsIndex != null) try { rsIndex.close(); } catch (SQLException e) {}
                    if (pstmtIndex != null) try { pstmtIndex.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            %>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
