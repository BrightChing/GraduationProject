<%@ page language="java"  contentType="text/html; charset=UTF-8"%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style/component.css"/>
</head>
<body align="center">

	<h3>员工编辑</h3>
	<!-- action对应一个action标签，id对应提交时的对应关系 -->
	<form id="saveForm" action="${pageContext.request.contextPath}/person/updatePerson" method="post">
		<span class="input input--isao">
            <input class="input__field input__field--isao" id="personId" value="${person.personId}" name="personId"
				   type="text"/>
            <label class="input__label input__label--isao" for="personId" data-content="用户名">
                <span class="input__label-content input__label-content--isao">用户名</span>
                ${ERROR_personId}
            </label>
        </span>
		<span class="input input--isao">
            <input class="input__field input__field--isao" id="password" name="password" value="${person.password}"
				   type="password"/>
            <label class="input__label input__label--isao" for="password" data-content="密码">
                <span class="input__label-content input__label-content--isao">密码</span>
            </label>
        </span>
		<span class="input input--isao">
            <input class="input__field input__field--isao" type="password"/>
            <label class="input__label input__label--isao" data-content="确认密码">
                <span class="input__label-content input__label-content--isao">确认密码</span>
            </label>
        </span>
		<span class="input input--isao">
            <input class="input__field input__field--isao" id="personName" name="personName" value="${person.personName}"
				   type="text"/>
            <label class="input__label input__label--isao" for="personName" data-content="姓名">
                <span class="input__label-content input__label-content--isao">姓名</span>
                ${ERROR_personName}
            </label>
        </span>

		<span class="input input--isao">
            <input class="input__field input__field--isao" id="email" name="email" value="${person.email}" type="text"/>
            <label class="input__label input__label--isao" for="email" data-content="Email">
                <span class="input__label-content input__label-content--isao">Email</span>
                ${ERROR_email}
            </label>
        </span>
		<span class="input input--isao">
            <input class="input__field input__field--isao" id="phone" name="phone" value="${person.phone}" type="text"/>
            <label class="input__label input__label--isao" for="phone" data-content="电话">
                <span class="input__label-content input__label-content--isao">电话</span>
                ${ERROR_phone}
            </label>
        </span>
		<span class="input input--isao">
            <input class="input__field input__field--isao" id="address" name="address" value="${person.address}"
				   type="text"/>
            <label class="input__label input__label--isao" for="address" data-content="地址">
                <span class="input__label-content input__label-content--isao">地址</span>
                ${ERROR_address}
            </label>
        </span>
		<span class="input input--isao">
            <input class="input__field input__field--isao" id="company" value="${person.company}" name="company"
				   type="text"/>
            <label class="input__label input__label--isao" for="company" data-content="公司">
                <span class="input__label-content input__label-content--isao">公司</span>
                ${ERROR_company}
            </label>
        </span>
		<span class="input input--isao">
            <input class="input__field input__field--isao" id="department" name="department"
				   value="${person.department}" type="text"/>
            <label class="input__label input__label--isao" for="department" data-content="部门">
                <span class="input__label-content input__label-content--isao">部门</span>
                ${ERROR_department}
            </label>
        </span>
		<span class="input input--isao">
            <input class="input__field input__field--isao" id="position" name="position" value="${person.position}"
				   type="text"/>
            <label class="input__label input__label--isao" for="position" data-content="职位">
                <span class="input__label-content input__label-content--isao">职位</span>
                ${ERROR_position}
            </label>
        </span>
		<br>
		<input type="submit" value="更 新"/> &nbsp;&nbsp;<a href="javascript:history.go(-1)">退回 </a>
	</form>
</body>
</html>
