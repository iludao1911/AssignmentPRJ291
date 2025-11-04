<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, dao.UserDAO, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Quản lý Người dùng");
    request.setAttribute("page", "users");
    
    UserDAO userDAO = new UserDAO();
    List<User> users = null;
    try {
        users = userDAO.getAllUsers();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<jsp:include page="includes/admin-header.jsp" />
<jsp:include page="includes/toast.jsp" />
<jsp:include page="includes/confirm-modal.jsp" />

<div class="page-header">
    <h1 class="page-title">Quản lý Người dùng</h1>
    <p class="page-subtitle">Xem và quản lý tất cả người dùng trong hệ thống</p>
</div>

<div class="content-card">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <div>
            <h3 style="font-size: 1.3rem; color: #333; margin-bottom: 5px;">Danh sách Người dùng</h3>
            <p style="color: #666; font-size: 0.9rem;">Tổng cộng: <%= users != null ? users.size() : 0 %> người dùng</p>
        </div>
        <div style="display: flex; gap: 10px;">
            <input type="text" id="searchInput" placeholder="Tìm kiếm người dùng..." style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px; width: 300px;">
            <select id="roleFilter" style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px;">
                <option value="">Tất cả vai trò</option>
                <option value="admin">Admin</option>
                <option value="customer">Khách hàng</option>
            </select>
        </div>
    </div>

    <% if (users == null || users.isEmpty()) { %>
        <div style="text-align: center; padding: 60px 20px; color: #999;">
            <i class="fas fa-users-slash" style="font-size: 4rem; margin-bottom: 20px; color: #ddd;"></i>
            <h3 style="font-size: 1.3rem; margin-bottom: 10px;">Chưa có người dùng</h3>
            <p>Người dùng mới sẽ hiển thị tại đây</p>
        </div>
    <% } else { %>
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="background: #f8f9fa; border-bottom: 2px solid #dee2e6;">
                    <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">ID</th>
                    <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Người dùng</th>
                    <th style="padding: 15px; text-align: left; font-weight: 600; color: #333;">Số điện thoại</th>
                    <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Vai trò</th>
                    <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Trạng thái</th>
                    <th style="padding: 15px; text-align: center; font-weight: 600; color: #333;">Thao tác</th>
                </tr>
            </thead>
            <tbody id="usersTableBody">
                <% for (User user : users) { 
                    String roleClass = user.isAdmin() ? "admin" : "customer";
                %>
                <tr style="border-bottom: 1px solid #dee2e6;" class="user-row" data-role="<%= roleClass %>">
                    <td style="padding: 15px; font-weight: 600; color: #0891b2;">#<%= user.getUserId() %></td>
                    <td style="padding: 15px;">
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #0891b2, #0d9488); color: white; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 1.1rem;">
                                <%= user.getName().substring(0, 1).toUpperCase() %>
                            </div>
                            <div>
                                <div style="font-weight: 600; margin-bottom: 3px;"><%= user.getName() %></div>
                                <div style="font-size: 0.85rem; color: #666;"><%= user.getEmail() %></div>
                            </div>
                        </div>
                    </td>
                    <td style="padding: 15px; color: #666;"><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                    <td style="padding: 15px; text-align: center;">
                        <span style="<%= user.isAdmin() ? "background: #e0f2fe; color: #0891b2;" : "background: #f0fdf4; color: #22c55e;" %> padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; display: inline-block;">
                            <%= user.isAdmin() ? "Admin" : "Khách hàng" %>
                        </span>
                    </td>
                    <td style="padding: 15px; text-align: center;">
                        <span style="<%= user.isVerified() ? "background: #d4edda; color: #155724;" : "background: #fff3cd; color: #856404;" %> padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; display: inline-block;">
                            <%= user.isVerified() ? "Đã xác thực" : "Chưa xác thực" %>
                        </span>
                    </td>
                    <td style="padding: 15px; text-align: center;">
                        <% if (!user.isAdmin()) { %>
                            <button onclick="sendEmail('<%= user.getEmail() %>', '<%= user.getName() %>')" class="btn btn-sm" style="padding: 6px 12px; background: #0891b2; color: white; border: none; border-radius: 6px; cursor: pointer; margin-right: 5px;" title="Gửi email">
                                <i class="fas fa-envelope"></i>
                            </button>
                            <% if (user.isVerified()) { %>
                                <button onclick="banUser(<%= user.getUserId() %>, '<%= user.getName() %>')" class="btn btn-sm" style="padding: 6px 12px; background: #ffc107; color: #333; border: none; border-radius: 6px; cursor: pointer;" title="Cấm tài khoản">
                                    <i class="fas fa-ban"></i>
                                </button>
                            <% } else { %>
                                <button onclick="unbanUser(<%= user.getUserId() %>, '<%= user.getName() %>')" class="btn btn-sm" style="padding: 6px 12px; background: #28a745; color: white; border: none; border-radius: 6px; cursor: pointer;" title="Mở khóa tài khoản">
                                    <i class="fas fa-check-circle"></i>
                                </button>
                            <% } %>
                        <% } else { %>
                            <span style="color: #999; font-size: 0.9rem; font-style: italic;">
                                <i class="fas fa-shield-alt"></i> Admin
                            </span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

</style>

<script>
    // Search and filter functionality
    document.getElementById('searchInput').addEventListener('keyup', filterUsers);
    document.getElementById('roleFilter').addEventListener('change', filterUsers);

    function filterUsers() {
        const searchValue = document.getElementById('searchInput').value.toLowerCase();
        const roleValue = document.getElementById('roleFilter').value;
        const rows = document.querySelectorAll('.user-row');

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            const role = row.getAttribute('data-role');
            const matchesSearch = text.includes(searchValue);
            const matchesRole = !roleValue || role === roleValue;

            row.style.display = matchesSearch && matchesRole ? '' : 'none';
        });
    }

    function sendEmail(email, userName) {
        const subject = encodeURIComponent('Thông báo từ Nhà Thuốc MS');
        const body = encodeURIComponent('Xin chào ' + userName + ',\n\n');
        window.location.href = 'mailto:' + email + '?subject=' + subject + '&body=' + body;
    }

    function banUser(userId, userName) {
        showConfirm(
            'Bạn có chắc chắn muốn CẤM tài khoản "' + userName + '"?\n\nNgười dùng sẽ không thể đăng nhập.',
            'Cấm tài khoản',
            function(confirmed) {
                if (!confirmed) return;
                // TODO: Call API to ban user
                fetch('<%= request.getContextPath() %>/admin/users/ban', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({userId: userId, action: 'ban'})
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Thành công', 'Đã cấm tài khoản thành công!', 'success');
                        location.reload();
                    } else {
                        showToast('Lỗi', 'Lỗi: ' + data.message, 'error');
                    }
                })
                .catch(err => {
                    showToast('Thông báo', 'Chức năng đang phát triển. API chưa sẵn sàng.', 'info');
                });
            }
        );
    }

    function unbanUser(userId, userName) {
        showConfirm(
            'Bạn có chắc chắn muốn MỞ KHÓA tài khoản "' + userName + '"?',
            'Mở khóa tài khoản',
            function(confirmed) {
                if (!confirmed) return;
                // TODO: Call API to unban user
                fetch('<%= request.getContextPath() %>/admin/users/ban', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({userId: userId, action: 'unban'})
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Thành công', 'Đã mở khóa tài khoản thành công!', 'success');
                        location.reload();
                    } else {
                        showToast('Lỗi', 'Lỗi: ' + data.message, 'error');
                    }
                })
                .catch(err => {
                    showToast('Thông báo', 'Chức năng đang phát triển. API chưa sẵn sàng.', 'info');
                });
            }
        );
    }
</script>

<jsp:include page="includes/admin-footer.jsp" />
