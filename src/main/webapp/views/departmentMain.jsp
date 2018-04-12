<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <style type="text/css">
        .table1 {
            border: 1px solid #ddd;
            width: 100%;
        }

        thead {
            background-color: lightblue;
        }

    </style>
</head>
<body>
<table border="0" width="300px">
    <tr>
        <td align="center" style="font-size:24px; color:#666"> 公司管理</td>
    </tr>
    <tr>
        <td align="right"><a href="${pageContext.request.contextPath}/company/addCompany">添加</a></td>
    </tr>
</table>
<br/>
<table cellspacing="0" border="1" class="table1">
    <thead>
    <th width="100%">公司名</th>
    </thead>
    <tbody>

    <c:forEach var="department" items="${requestScope.departmentList }">
        <tr>

            <td align="center">${department.departmentName }</td>
            <td align="center">
                <a href="${pageContext.request.contextPath}/department/doUpdate?id=${department.departmentId}">
                    <img src="<%=basePath %>images/edit.png">
                </a>
            </td>
            <td align="center">
                <a href="${pageContext.request.contextPath}/department/deleteDepartmentById?id=${department.departmentId}"
                   onclick='return confirm("确认要删除吗?")'>
                    <img src="<%=basePath%>images/trash.gif">
                </a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<br/>
</body>
</html>