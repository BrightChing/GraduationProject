<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <script type="text/javascript">

    </script>
</head>
<body>
<h3>人员添加</h3>
<form id="saveForm" action="${pageContext.request.contextPath}/person/savePerson" method="post">
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
            <td align="center">
                <input type="submit" value="添 加"/> &nbsp;&nbsp;
                <a href="javascript:history.go(-1)">退回 </a>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
