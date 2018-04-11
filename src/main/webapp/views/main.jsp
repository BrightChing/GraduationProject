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
            width: 900px;
        }

        thead {
            background-color: lightblue;
        }

    </style>
</head>
<body>
<table border="0" width="900px">
    <tr>
        <td align="center" style="font-size:24px; color:#666"> 人员管理</td>
    </tr>
    <tr>
        <td align="right"><a href="${pageContext.request.contextPath}/person/addPerson">添加</a></td>
    </tr>
</table>
<br/>
<table cellspacing="0" border="1" class="table1">
    <thead>
        <th width="300">姓名</th>
        <th width="400">身份证号</th>
        <th width="300">电话</th>
        <th width="300">地址</th>
        <th width="200">编辑</th>
        <th width="200">删除</th>
    </thead>
    <tbody>

    <c:forEach var="person" items="${requestScope.personList }">
        <tr>
            <td align="center">${person.name }</td>
            <td align="center">${person.idCard }</td>
            <td align="center">${person.phone }</td>
            <td align="center">${person.address }</td>
            <td align="center">
                <a href="${pageContext.request.contextPath}/person/doUpdate?id=${person.id}">
                    <img src="<%=basePath %>images/edit.png">
                </a>
            </td>
            <td align="center">
                <a href="${pageContext.request.contextPath}/person/deletePersonById?id=${person.id}"
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