<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style/component.css"/>
</head>
<body align="center">

<h3>公司编辑</h3>
<!-- action对应一个action标签，id对应提交时的对应关系 -->
<form id="saveForm" action="${pageContext.request.contextPath}/company/updateCompany" method="post">
    <input id="companyId" value="${company.companyId}" name="companyId" type="hidden"/>
    <span class="input input--isao">
            <input class="input__field input__field--isao" id="companyName" value="${company.companyName}"
                   name="companyName"
                   type="text"/>
            <label class="input__label input__label--isao" for="companyName" data-content="公司名">
                <span class="input__label-content input__label-content--isao">公司名</span>
                ${ERROR_companyName}
            </label>
        </span>
    <br>
    <input type="submit" value="更 新"/> &nbsp;&nbsp;<a href="javascript:history.go(-1)">退回 </a>
</form>
</body>
</html>
