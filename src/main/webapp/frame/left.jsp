<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <link href="${pageContext.request.contextPath}/frame/dtree.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/frame/dtree.js"></script>
</head>

<body>
<table width="90%" border="0" cellspacing="1" cellpadding="2" align="center">
    <div class="dtree">
        <script type="text/javascript">
            d = new dTree('d');
            d.add('01', '-1', 'OKR管理系统');
            d.add('0101', '01', '人员管理');
            d.add('010101', '0101', '人员列表', '${pageContext.request.contextPath}/person/main', '', 'right');
            d.add('010102', '0101', '部门列表', '${pageContext.request.contextPath}/department/main', '', 'right');
            d.add('010103', '0101', '公司列表', '${pageContext.request.contextPath}/company/main', '', 'right');
            d.add()
            document.write(d);
        </script>
    </div>
</table>
</body>
</html>
