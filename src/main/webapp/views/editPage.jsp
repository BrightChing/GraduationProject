<%@ page language="java"  contentType="text/html; charset=UTF-8"%>
<html>
<body align="center">

	<h3>员工编辑</h3>
	<!-- action对应一个action标签，id对应提交时的对应关系 -->
	<form id="saveForm" action="${pageContext.request.contextPath}/person/updatePerson" method="post">
		<input type="hidden" name="id" value="${person.id }" />
		<table style="font-size:16px">
			<tr>
				<td>
					<label for="name">姓名：</label>
					<input id="name" type="text" value="${person.name }" name="name"/>
					${ERROR_name}
				</td>
			</tr>
			<tr>
				<td>
					<label for="idCard">身份证号码：</label>
					<input id="idCard" type="text" value="${person.idCard }" name="idCard"/>
					${ERROR_idCard}
				</td>
			</tr>
			<tr>
			<tr>
				<td><label for="phone">手机号：</label>
					<input id="phone" type="text" value="${person.phone }" name="phone"/>
					${ERROR_phone}
				</td>
			</tr>
			<tr>
				<td><label for="address">地址：</label>
					<input id="address" type="text" value="${person.address }" name="address"/>
					${ERROR_address}
				</td>
			</tr>
			<tr>
				<td align="right">
					<input type="submit" value="更新"/> &nbsp;&nbsp;
					<a href="javascript:history.go(-1)">退回 </a>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
