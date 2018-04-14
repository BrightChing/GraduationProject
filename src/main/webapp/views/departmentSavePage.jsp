<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style/component.css"/>
</head>
<body>
<h2 style="text-align: center">添加部门</h2>
<form id="saveForm" action="${pageContext.request.contextPath}/department/saveDepartment" method="post">
    <div align="center">
        <span class="input input--isao">
            <input class="input__field input__field--isao" id="departmentName" value="${department.departmentId}"
                   name="departmentName" type="text"/>
            <label class="input__label input__label--isao" for="departmentName" data-content="部门名">
                <span class="input__label-content input__label-content--isao">部门名</span>
                ${ERROR_departmentName}
            </label>
        </span>
        <br>
        <input type="submit" value="添 加"/> &nbsp;&nbsp;<a href="javascript:history.go(-1)">退回 </a>
    </div>
</form>
</body>
</html>
