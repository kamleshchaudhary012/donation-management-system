<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db_config.jsp" %>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Monthly Giving" />
    <jsp:param name="cssFile" value="monthly.css" />
    <jsp:param name="jsFile" value="monthly.js" />
</jsp:include>

        <div class="banner">
            <div class="banner-content">
                <h2>Become a <span>Monthly Hero</span></h2>
                <p>By giving monthly, you provide a stable and reliable source of support to our NGO partners. Join our community of monthly donors today.</p>
            </div>
            <div class="banner-image">
                <i class="fas fa-calendar-alt"></i>
            </div>
        </div>

        <div class="all-charities-header" style="margin: 30px 0 20px; text-align: center;">
            <h1 style="font-size: 2.2rem; font-weight: 800; color: #1e293b;">Support a Cause Monthly</h1>
            <p style="color: #64748b; margin-top: 10px; font-size: 1.1rem;">Choose a charity below to start your monthly giving.</p>
        </div>
        <div class="charity-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 28px; margin-bottom: 60px;">
            <%
                PreparedStatement pstmtMonthly = null;
                ResultSet rsMonthly = null;
                try {
                    if (conn != null) {
                        String query = "SELECT * FROM charities";
                        pstmtMonthly = conn.prepareStatement(query);
                        rsMonthly = pstmtMonthly.executeQuery();

                        boolean anyCharity = false;
                        while (rsMonthly.next()) {
                            anyCharity = true;

                            int charityId = rsMonthly.getInt("id");
                            String charityName = rsMonthly.getString("name");
                            String charityDesc = rsMonthly.getString("description");
                            String charityImg  = rsMonthly.getString("image_url");

                            if (charityDesc == null) charityDesc = "";

                            double goal = rsMonthly.getDouble("goal_amount");
                            double raised = rsMonthly.getDouble("raised_amount");
                            double pct = (goal > 0) ? Math.min((raised / goal) * 100.0, 100.0) : 0;
                            // Force dot decimal separator (e.g., 53.2) so CSS width stays valid on all locales.
                            String pctFormatted = String.format(java.util.Locale.US, "%.1f", pct);
                            String shortDesc = (charityDesc.length() > 120) ? charityDesc.substring(0, 120) + "..." : charityDesc;
            %>
            <div class="charity-card" style="background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.07); border: 1px solid #eef2f6; display: flex; flex-direction: column;">
                <div style="background: url('<%= charityImg %>') center/cover no-repeat; height: 200px;"></div>
                <div style="padding: 20px; flex: 1; display: flex; flex-direction: column;">
                    <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 8px; color: #1e293b;"><%= charityName %></h3>
                    <p style="font-size: 0.88rem; color: #64748b; line-height: 1.6; flex: 1;"><%= shortDesc %></p>

                    <div style="margin-top: 14px; background: #e2e8f0; border-radius: 20px; height: 8px; overflow: hidden;">
                        <div class="pbar-<%= charityId %>"
                             style="background: linear-gradient(90deg, #f97316, #ea580c); height: 100%; width: 0%; border-radius: 20px; transition: width 0.3s ease-in-out;"
                             data-progress-width="<%= pctFormatted %>"></div>
                    </div>

                    <div style="display: flex; justify-content: space-between; font-size: 0.82rem; color: #64748b; margin-top: 6px;">
                        <span>₹<%= String.format("%,.0f", raised) %> raised</span>
                        <span><%= String.format("%.0f", pct) %>% of ₹<%= String.format("%,.0f", goal) %></span>
                    </div>

                    <a href="charity.jsp?id=<%= charityId %>&type=Monthly" style="display: block; margin-top: 16px; background: linear-gradient(135deg, #f97316, #ea580c); color: white; text-align: center; padding: 12px; border-radius: 40px; text-decoration: none; font-weight: 600; font-size: 0.9rem; transition: opacity 0.2s;" onmouseover="this.style.opacity='0.85'" onmouseout="this.style.opacity='1'">
                        Give Monthly to this cause →
                    </a>
                </div>
            </div>
            <%
                        }

                        if (!anyCharity) {
                            out.println("<p style='text-align:center;color:#64748b;'>No charities found.</p>");
                        }
                    } else {
                        out.println("<p>Database connection unavailable.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p>Error fetching charities: " + e.getMessage() + "</p>");
                } finally {
                    if (rsMonthly != null) try { rsMonthly.close(); } catch (SQLException e) {}
                    if (pstmtMonthly != null) try { pstmtMonthly.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            %>
        </div>
        <script>
            document.querySelectorAll('[data-progress-width]').forEach(function(el) {
                var w = el.getAttribute('data-progress-width');
                if (w !== null && w !== '') {
                    el.style.width = w + '%';
                }
            });
        </script>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
