<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect to home page
    response.sendRedirect("home.jsp");
%>
            <ul>
                <li><a href="medicines?action=list">Quản lý Thuốc (CRUD)</a></li>
                <li><a href="suppliers?action=list">Quản lý Nhà cung cấp (CRUD)</a></li>
                <li><a href="orders?action=list">Quản lý Đơn hàng (CRUD)</a></li>
                <li><a href="login?action=logout">Đăng xuất</a></li>
            </ul>
        </c:when>
        
        <%-- TRƯỜNG HỢP 3: KHÔNG AI ĐĂNG NHẬP (Redirect về trang login) --%>
        <c:otherwise>
            <c:redirect url="login"/>
        </c:otherwise>
    </c:choose>
</body>
</html>