<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>企业OKR考核管理系统</title>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/style/reset.css">
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/style/main.css">
    <script type="text/javascript">

    </script>
</head>

<body>
<div class="headerBar">
    <div class="logoBar login_logo">
        <div class="comWidth">
            <div class="logo fl">
                <a href="#"><img src="${pageContext.request.contextPath}/images/logo.png" alt="企业OKR考核管理系统"></a>
            </div>
            <h3 class="welcome_title">欢迎登陆</h3>
        </div>
    </div>
</div>

<form action="/user/login" method="post">
    <div class="loginBox">
        <div class="login_cont">
            <ul class="login">
                <li class="mb_10">
                    <input type="text" name="id" placeholder="用户名" class="login_input user_icon">
                </li>
                <li class="mb_10">
                    <input type="password" name="password" placeholder="密码" class="login_input user_icon">
                </li>
                <li>
                    <input type="checkbox" id="checkbox"> 记住密码
                    <input onclick="() " type="submit" value="" class="login_btn">
                </li>
            </ul>
            <div class="login_partners">
                <p class="l_tit">使用合作方账号登陆网站</p>
                <ul class="login_list clearfix">
                    <li><a href="#">QQ</a></li>
                    <li><span>|</span></li>
                    <li><a href="#">网易</a></li>
                    <li><span>|</span></li>
                    <li><a href="#">新浪微博</a></li>
                    <li><span>|</span></li>
                    <li><a href="#">腾讯微薄</a></li>
                    <li><span>|</span></li>
                    <li><a href="#">新浪微博</a></li>
                    <li><span>|</span></li>
                    <li><a href="#">腾讯微薄</a></li>
                </ul>
            </div>
        </div>
    </div>
</form>
</body>
<footer>
    <div class="hr_25"></div>
    <div class="footer">
        <p>
            <a href="#">企业OKR考核管理系统简介</a>
            <i>|</i>
            <a href="#">企业OKR考核管理系统公告</a>
            <i>|</i>
            <a href="#">招纳贤士</a>
            <i>|</i>
            <a href="#">联系我们</a>
            <i>|</i>客服热线：400-675-1234
        </p>
        <p>Copyright &copy; 2007 - 2018 BrightQin版权所有&nbsp;&nbsp;&nbsp;京ICP备09037834号&nbsp;&nbsp;&nbsp;京ICP证B1034-8373号&nbsp;&nbsp;&nbsp;杭州市公安局XX分局备案编号：123456789123</p>
    </div>
</footer>
</html>
