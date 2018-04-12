<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style/component.css"/>
</head>
<body>
<h2 style="text-align: center">添加公司</h2>
<form id="saveForm" action="${pageContext.request.contextPath}/company/saveCompany" method="post">
    <div align="center">
        <span class="input input--isao">
            <input class="input__field input__field--isao" id="companyName" value="${company.companyId}" name="companyName"
                   type="text"/>
            <label class="input__label input__label--isao" for="companyName" data-content="公司名">
                <span class="input__label-content input__label-content--isao">公司名</span>
                ${ERROR_companyName}
            </label>
        </span>
        <br>
        <input type="submit" value="添 加"/> &nbsp;&nbsp;<a href="javascript:history.go(-1)">退回 </a>
    </div>
</form>
</body>
</html>
