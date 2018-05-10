<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>企业OKR考核管理系统</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style/normalize.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/fonts/css/font-awesome.min.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style/demo.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style/component.css"/>
</head>
<body>

<div style="height:85px; background-color: #00BFFF; text-align:center;">
    <img src="${pageContext.request.contextPath}/images/logo.png" alt="企业OKR考核管理系统">
</div>

<div class="container">
    <form id="loginForm" action="${pageContext.request.contextPath}/user/login" method="post">
        <section class="content">

            <span class="input input--hideo">
                <input class="input__field input__field--hideo" type="text" name="id" id="id"/>
                <label class="input__label input__label--hideo" for="id">
                    <i class="fa fa-fw fa-user icon icon--hideo"></i>
                    <span class="input__label-content input__label-content--hideo">Username</span>
                </label>
             </span>
            <br>
            <span class="input input--hideo">
                <input class="input__field input__field--hideo" type="password" name="password" id="password"/>
                <label class="input__label input__label--hideo" for="password">
                    <i class="fa fa-fw fa-lock icon icon--hideo"></i>
                    <span class="input__label-content input__label-content--hideo">Password</span>
                </label>
            </span>

            <div>
                <input onclick="" type="submit" value=""
                       style="width:309px; height:36px; background:url(${pageContext.request.contextPath}/images/login_btn.jpg) left top no-repeat;">
            </div>

        </section>
        <div>
            <p class="l_tit">使用合作方账号登陆网站</p>
            <a href="#">QQ</a>
            <span>|</span>
            <a href="#">网易</a>
            <span>|</span>
            <a href="#">新浪微博</a>
            <span>|</span>
            <a href="#">腾讯微薄</a>
            <span>|</span>
            <a href="#">新浪微博</a>
            <span>|</span>
            <a href="#">腾讯微薄</a>
        </div>
    </form>
</div>
</body>
<footer>
    <div align="center">
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