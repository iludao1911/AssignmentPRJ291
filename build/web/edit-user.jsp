<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa tài khoản User</title>
</head>
<body>
<%-- This security check should align with the AdminAuthFilter --%>
<%
    Object userObj = session.getAttribute("currentCustomer");
    String role = null;
    if (userObj instanceof model.Customer) {
        role = ((model.Customer) userObj).getRole();
    }

    if (role == null || !"Admin".equalsIgnoreCase(role)) {
        // Redirect to a proper access denied page or login page, not a relative one
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
%>
    <h2>Sửa tài khoản User</h2>
    <form action="${pageContext.request.contextPath}/admin/action/users/update" method="post">
        <input type="hidden" name="id" value="${user.customerId}" />
        <p>Tên: <input type="text" name="name" value="${user.name}" required /></p>
        <p>Email: <input type="email" name="email" value="${user.email}" required /></p>
        <p>Phone: <input type="text" name="phone" value="${user.phone}" /></p>
        <p>Password: <input type="password" name="password" value="" placeholder="Để trống nếu không muốn đổi" /></p>
        <p><button type="submit">Lưu thay đổi</button></p>
    </form>
    <p><a href="${pageContext.request.contextPath}/admin/action/users">Quay lại danh sách User</a></p>
</body>
</html>
