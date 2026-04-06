<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    String userName = "";
    String userEmail = "";
    int userId = 0;

    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            userId = Integer.parseInt(idParam.trim());
            PreparedStatement pstmt = conn.prepareStatement("SELECT id, name, email FROM users WHERE id = ? AND role = 'user'");
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                userName = rs.getString("name");
                userEmail = rs.getString("email");
            }
            rs.close();
            pstmt.close();
        } catch (Exception e) {
            // ignore
        } finally {
            if (conn != null) conn.close();
        }
    }
%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - Edit User" />
    <jsp:param name="cssFile" value="add_charity.css" />
    <jsp:param name="jsFile" value="add_charity.js" />
</jsp:include>

        <div class="form-container" style="max-width: 520px; margin: 60px auto; background: white; border-radius: 24px; padding: 40px; box-shadow: 0 4px 30px rgba(0,0,0,0.08); border: 1px solid #eef2f6;">
            <h2 style="color: #0f172a; margin-bottom: 8px;">Edit User</h2>
            <p style="color: #64748b; margin-bottom: 28px; font-size: 0.9rem;">Update user information below.</p>
            <form action="update_user.jsp" method="post">
                <input type="hidden" name="id" value="<%= userId %>">
                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="name" style="display: block; font-weight: 600; margin-bottom: 6px; color: #334155;">Full Name</label>
                    <input type="text" id="name" name="name" value="<%= userName %>" required
                           style="width: 100%; padding: 12px 16px; border: 1.5px solid #e2e8f0; border-radius: 12px; font-size: 0.95rem; font-family: 'Inter', sans-serif; outline: none; transition: border-color 0.2s;"
                           onfocus="this.style.borderColor='#f97316'" onblur="this.style.borderColor='#e2e8f0'">
                </div>
                <div class="form-group" style="margin-bottom: 28px;">
                    <label for="email" style="display: block; font-weight: 600; margin-bottom: 6px; color: #334155;">Email Address</label>
                    <input type="email" id="email" name="email" value="<%= userEmail %>" required
                           style="width: 100%; padding: 12px 16px; border: 1.5px solid #e2e8f0; border-radius: 12px; font-size: 0.95rem; font-family: 'Inter', sans-serif; outline: none; transition: border-color 0.2s;"
                           onfocus="this.style.borderColor='#f97316'" onblur="this.style.borderColor='#e2e8f0'">
                </div>
                <div style="display: flex; gap: 12px;">
                    <button type="submit"
                            style="flex: 1; background: linear-gradient(135deg, #f97316, #ea580c); color: white; border: none; padding: 14px; border-radius: 40px; font-weight: 700; font-size: 1rem; cursor: pointer; transition: opacity 0.2s;"
                            onmouseover="this.style.opacity='0.85'" onmouseout="this.style.opacity='1'">
                        Save Changes
                    </button>
                    <a href="admin_dashboard.jsp"
                       style="flex: 1; border: 1.5px solid #e2e8f0; color: #334155; padding: 14px; border-radius: 40px; font-weight: 600; font-size: 1rem; text-align: center; text-decoration: none; transition: border-color 0.2s;"
                       onmouseover="this.style.borderColor='#f97316';this.style.color='#f97316'" onmouseout="this.style.borderColor='#e2e8f0';this.style.color='#334155'">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div> <!-- Close container from header.jsp -->

<jsp:include page="footer.jsp" />
