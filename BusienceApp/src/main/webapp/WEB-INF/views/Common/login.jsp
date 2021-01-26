<%@page import="java.net.SocketException"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>Xeonic Login</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<%-- <!--===============================================================================================-->
   <link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
<!--===============================================================================================-->
   <link rel="stylesheet" type="text/css" href="${contextPath}/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<!--===============================================================================================-->
   <link rel="stylesheet" type="text/css" href="vendor/animate/animate.css">
<!--===============================================================================================-->   
   <link rel="stylesheet" type="text/css" href="vendor/css-hamburgers/hamburgers.min.css">
<!--===============================================================================================-->
   <link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css">
<!--===============================================================================================--> --%>
<link rel="stylesheet" type="text/css"
	href="${contextPath}/resources/css/util.css">
<link rel="stylesheet" type="text/css"
	href="${contextPath}/resources/css/main.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/js/all.min.js"
	crossorigin="anonymous"></script>

<!--===============================================================================================-->
</head>
<body>
	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100">
				<div class="login100-pic js-tilt" data-tilt text>
					<img src="${contextPath}/resources/images/2.png" alt="PNG">
				</div>

				<form id="loginFrm">
					<span class="login100-form-title"> Member Login </span>

					<div class="wrap-input100 validate-input">
						<input class="input100" type="text" id="inputId" placeholder="id"
							onkeypress="javascript:if(event.keyCode==13) {document.getElementById('inputPass').focus()}">
						<span class="focus-input100"></span> <span class="symbol-input100">
							<i class="fas fa-id-badge" aria-hidden="true"></i>
						</span>
					</div>

					<div class="wrap-input100 validate-input">
						<input class="input100" type="password" id="inputPass"
							placeholder="Password"
							onkeypress="javascript:if(event.keyCode==13) {loginBtn()}">
						<span class="focus-input100"></span> <span class="symbol-input100">
							<i class="fa fa-lock" aria-hidden="true"></i>
						</span>
					</div>

					<div class="container-login100-form-btn">
						<button type="button" class="login100-form-btn"
							onclick="loginBtn()">Login</button>
					</div>

					<div class="text-center p-t-12"></div>
				</form>
				<div class="text-center p-t-136">
					<a class="txt2"
						style="float: left; margin-left: 300%; height: 5px;"> <img
						src="${contextPath}/resources/images/1.jpg" alt="JPG">
					</a>
				</div>
			</div>
		</div>
	</div>

	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script type="text/javascript" src="http://jsgetip.appspot.com"></script>
	<script type="text/javascript">
	
	
	function loginBtn() {
		usetData = {
				inputId : document.getElementById("inputId").value,
				inputPass : document.getElementById("inputPass").value
				
		}
		
		$.ajax({
            method: "POST",
            data : null,
            url: "${contextPath}/login?usetData="+encodeURI(JSON.stringify(usetData))+"",
            success: function (data,textStatus) {
            	//alert(data);
            	if(data=="inputIdNone")
            	{
            		alert("아이디가 비어있습니다.");
            		document.getElementById("inputId").focus();
            		return;
            	}
            	else if(data=="inputPassNone")
            	{
            		alert("비밀번호가 비어있습니다.");
            		document.getElementById("inputPass").focus();
            		return;
            	}
            	if(data=="IdNot")
            	{
            		alert("아이디가 존재하지 않습니다.");
            		document.getElementById("inputId").focus();
            		return;
            	}
            	if(data=="IdNot2")
            	{
            		alert("해당 아이디는 사용되지 않습니다.");
            		document.getElementById("inputId").focus();
            		return;
            	}
            	else if(data=="loginFail")
            	{
            		alert("비밀번호가 틀렸습니다.");
            		document.getElementById("inputId").focus();
            		return;
            	}
            	
            	location.href = "${contextPath}/main";
            } 
        });
	}
</script>
	
	<!--===============================================================================================-->
	<script src="https://code.jquery.com/jquery-3.2.1.js"
		integrity="sha256-DZAnKJ/6XZ9si04Hgrsxu/8s717jcIzLy3oi35EouyE="
		crossorigin="anonymous"></script>
	<!-- <!--===============================================================================================-->
	<!--    <script src="vendor/bootstrap/js/popper.js"></script>
   <script src="vendor/bootstrap/js/bootstrap.min.js"></script>
   <script src="vendor/select2/select2.min.js"></script>
   <script src="vendor/tilt/tilt.jquery.min.js"></script>
   <script>
      $('.js-tilt').tilt({
         scale: 1.1
      })
   </script> -->
	<!--===============================================================================================-->
	<script src="${contextPath}/resources/js/main.js"></script>
</body>
</html>