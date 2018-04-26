<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style/component.css"/>
</head>
<body align="center">

<h3>部门编辑</h3>
<!-- action对应一个action标签，id对应提交时的对应关系 -->
<form id="saveForm" action="${pageContext.request.contextPath}/department/updateDepartment" method="post">
    <input id="departmentId" value="${department.departmentId}" name="departmentId" type="hidden"/>
    <span class="input input--isao">
            <input class="input__field input__field--isao" id="departmentName" value="${department.departmentName}"
                   name="departmentName"
                   type="text"/>
            <label class="input__label input__label--isao" for="departmentName" data-content="部门名">
                <span class="input__label-content input__label-content--isao">部门名</span>
                ${ERROR_departmentName}
            </label>
        </span>
    <br>
    <input type="submit" value="更 新"/> &nbsp;&nbsp;<a href="javascript:history.go(-1)">退回 </a>
</form>
</body>
</html>
