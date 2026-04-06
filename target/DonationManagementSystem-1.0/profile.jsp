<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_config.jsp" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    String userEmail  = (String) session.getAttribute("userEmail");
    String userName   = (String) session.getAttribute("userName");
    Integer userId    = (Integer) session.getAttribute("userId");
    Integer adminId   = (Integer) session.getAttribute("adminId");

    boolean isAdmin = (adminEmail != null);
    boolean isUser  = (userEmail != null && !isAdmin);

    if (!isAdmin && !isUser) {
        response.sendRedirect("login.jsp");
        return;
    }

    String mode = request.getParameter("mode"); // "edit" or null (view)
    boolean editMode = "edit".equals(mode);

    // Fetch admin name from DB if admin
    String adminName = "Admin";
    if (isAdmin && adminId != null) {
        try {
            PreparedStatement ps = conn.prepareStatement("SELECT name FROM users WHERE id = ? AND role = 'admin'");
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) adminName = rs.getString("name");
            rs.close(); ps.close();
        } catch (Exception e) { /* ignore */ }
    }

    String profileUpdated = request.getParameter("profileUpdated");
    String profileError   = request.getParameter("profileError");
    String pwdUpdated     = request.getParameter("pwdUpdated");
    String pwdError       = request.getParameter("pwdError");
%>
<jsp:include page="header.jsp">
    <jsp:param name="title" value="CharityX - My Profile" />
    <jsp:param name="cssFile" value="login.css" />
    <jsp:param name="jsFile" value="login.js" />
</jsp:include>

<style>
.profile-page { max-width: 520px; margin: 60px auto 80px; }
.profile-card {
    background: #fff;
    border-radius: 20px;
    box-shadow: 0 4px 24px rgba(0,0,0,0.08);
    padding: 36px 40px;
    border: 1px solid #eef2f6;
}
.profile-card h2 { font-size: 1.5rem; font-weight: 700; color: #0f172a; margin-bottom: 28px; }
.profile-field { margin-bottom: 18px; }
.profile-field label { display: block; font-size: 0.8rem; font-weight: 600; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 6px; }
.profile-field .field-value {
    font-size: 1rem; color: #1e293b; font-weight: 500;
    background: #f8fafc; border: 1px solid #e2e8f0;
    border-radius: 12px; padding: 14px 18px;
}
.profile-field .field-value.password-mask { letter-spacing: 0.2em; color: #94a3b8; }
.profile-actions { display: flex; gap: 12px; margin-top: 28px; }
.btn-edit-profile {
    flex: 1; background: linear-gradient(135deg, #f97316, #ea580c);
    color: #fff; border: none; border-radius: 40px;
    padding: 14px; font-size: 1rem; font-weight: 600; cursor: pointer;
    text-align: center; text-decoration: none; display: block;
}
.btn-edit-profile:hover { opacity: 0.88; }
.btn-cancel {
    flex: 1; background: #f1f5f9; color: #475569;
    border: none; border-radius: 40px;
    padding: 14px; font-size: 1rem; font-weight: 600; cursor: pointer;
    text-align: center; text-decoration: none; display: block;
}
.btn-cancel:hover { background: #e2e8f0; }
.profile-input {
    width: 100%; box-sizing: border-box;
    background: #f8fafc; border: 1px solid #e2e8f0;
    border-radius: 12px; padding: 14px 18px;
    font-size: 1rem; color: #1e293b; font-family: inherit;
    outline: none; transition: border 0.2s;
}
.profile-input:focus { border-color: #f97316; }
.alert-success { color: #16a34a; margin-bottom: 16px; font-weight: 500; }
.alert-error   { color: #dc2626; margin-bottom: 16px; font-weight: 500; }
</style>

<div class="profile-page">
    <div class="profile-card">

        <% if ("1".equals(profileUpdated) || "1".equals(pwdUpdated)) { %>
            <p class="alert-success"><i class="fas fa-check-circle"></i> Profile updated successfully.</p>
        <% } else if (profileError != null) { %>
            <p class="alert-error"><i class="fas fa-exclamation-circle"></i>
                <%= "email_exists".equals(profileError) ? "Email already in use." : "Could not update profile." %>
            </p>
        <% } else if (pwdError != null) { %>
            <p class="alert-error"><i class="fas fa-exclamation-circle"></i>
                <%= "wrong_current".equals(pwdError) ? "Current password is incorrect." : "Could not update password." %>
            </p>
        <% } %>

        <% if (!editMode) { %>
            <!-- ===== VIEW MODE ===== -->
            <h2><i class="fas fa-user-circle" style="color:#f97316;margin-right:10px;"></i>My Profile</h2>

            <% if (isUser) { %>
                <div class="profile-field">
                    <label>Full Name</label>
                    <div class="field-value"><%= userName != null ? userName : "" %></div>
                </div>
                <div class="profile-field">
                    <label>Email Address</label>
                    <div class="field-value"><%= userEmail %></div>
                </div>
                <div class="profile-field">
                    <label>Password</label>
                    <div class="field-value password-mask">••••••••</div>
                </div>
            <% } else { %>
                <div class="profile-field">
                    <label>Name</label>
                    <div class="field-value"><%= adminName %></div>
                </div>
                <div class="profile-field">
                    <label>Email Address</label>
                    <div class="field-value"><%= adminEmail %></div>
                </div>
                <div class="profile-field">
                    <label>Role</label>
                    <div class="field-value">Administrator</div>
                </div>
                <div class="profile-field">
                    <label>Password</label>
                    <div class="field-value password-mask">••••••••</div>
                </div>
            <% } %>

            <div class="profile-actions">
                <a href="profile.jsp?mode=edit" class="btn-edit-profile">
                    <i class="fas fa-pen"></i> Update Profile
                </a>
            </div>

        <% } else { %>
            <!-- ===== EDIT MODE ===== -->
            <h2><i class="fas fa-pen" style="color:#f97316;margin-right:10px;"></i>Edit Profile</h2>

            <% if (isUser) { %>
                <form action="update_account.jsp" method="post">
                    <input type="hidden" name="action" value="user_profile">
                    <input type="hidden" name="redirectTo" value="profile">
                    <div class="profile-field">
                        <label>Full Name</label>
                        <input type="text" class="profile-input" name="name" value="<%= userName != null ? userName : "" %>" required>
                    </div>
                    <div class="profile-field">
                        <label>Email Address</label>
                        <input type="email" class="profile-input" name="email" value="<%= userEmail %>" required>
                    </div>
                    <div class="profile-field">
                        <label>New Password <span style="color:#94a3b8;font-weight:400;">(leave blank to keep current)</span></label>
                        <input type="password" class="profile-input" name="password" placeholder="New password (optional)">
                    </div>
                    <div class="profile-actions">
                        <button type="submit" class="btn-edit-profile">Save Changes</button>
                        <a href="profile.jsp" class="btn-cancel">Cancel</a>
                    </div>
                </form>

            <% } else { %>
                <form action="update_account.jsp" method="post">
                    <input type="hidden" name="action" value="admin_password">
                    <input type="hidden" name="redirectTo" value="profile">
                    <div class="profile-field">
                        <label>Email Address</label>
                        <div class="field-value"><%= adminEmail %></div>
                    </div>
                    <div class="profile-field">
                        <label>Current Password</label>
                        <input type="password" class="profile-input" name="currentPassword" placeholder="Enter current password" required>
                    </div>
                    <div class="profile-field">
                        <label>New Password</label>
                        <input type="password" class="profile-input" name="newPassword" placeholder="Enter new password" required>
                    </div>
                    <div class="profile-actions">
                        <button type="submit" class="btn-edit-profile">Save Changes</button>
                        <a href="profile.jsp" class="btn-cancel">Cancel</a>
                    </div>
                </form>
            <% } %>

        <% } %>

    </div>
</div>

</div> <!-- Close container from header.jsp -->
<jsp:include page="footer.jsp" />
