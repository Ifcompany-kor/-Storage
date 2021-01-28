<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<meta charset="UTF-8">
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="brand">
			<a href="index.html">
				<img src="${contextPath}/resources/assets/img/logo-dark.png" alt="Klorofil Logo" class="img-responsive logo">
			</a>
		</div>
		<div class="container-fluid">
			<div class="navbar-btn">
				<button type="button" class="btn-toggle-fullwidth"><i class="lnr lnr-arrow-left-circle"></i></button>
			</div>
			<form class="navbar-form navbar-left">
				<div class="input-group">
						<!--
						<input type="text" value="" class="form-control" placeholder="Search dashboard...">
						<span class="input-group-btn"><button type="button" class="btn btn-primary">Go</button></span>
					-->
				</div>

			</form>
			<div class="navbar-btn navbar-btn-right">
					<!--
					<a class="btn btn-success update-pro" href="https://www.themeineed.com/downloads/klorofil-pro-bootstrap-admin-dashboard-template/?utm_source=klorofil&utm_medium=template&utm_campaign=KlorofilPro" title="Upgrade to Pro" target="_blank"><i class="fa fa-rocket"></i> <span>UPGRADE TO PRO</span></a>
				-->
			</div>
			<div id="navbar-menu">
				<ul class="nav navbar-nav navbar-right">
					<!-- 
					<li class="dropdown">
						<a href="#" class="dropdown-toggle icon-menu" data-toggle="dropdown">
							<i class="lnr lnr-alarm"></i>
							<span class="badge bg-danger">5</span>
						</a>
						<ul class="dropdown-menu notifications">
							<li><a href="#" class="notification-item"><span class="dot bg-warning"></span>System space is almost full</a></li>
							<li><a href="#" class="notification-item"><span class="dot bg-danger"></span>You have 9 unfinished tasks</a></li>
							<li><a href="#" class="notification-item"><span class="dot bg-success"></span>Monthly report is available</a></li>
							<li><a href="#" class="notification-item"><span class="dot bg-warning"></span>Weekly meeting in 1 hour</a></li>
							<li><a href="#" class="notification-item"><span class="dot bg-success"></span>Your request has been approved</a></li>
							<li><a href="#" class="more">See all notifications</a></li>
						</ul>
					</li>
				-->
				<!-- 
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="lnr lnr-briefcase"></i> <span>재고</span> <i class="icon-submenu lnr lnr-chevron-down"></i></a>
					<ul class="dropdown-menu">
						<li><a href="#">기초등록</a></li>
						<li><a href="#">영업관리</a></li>
						<li><a href="#">구매관리</a></li>
						<li><a href="#">생산/외주</a></li>
						<li><a href="#">기타이동</a></li>
						<li><a href="#">쇼핑몰관리</a></li>
						<li><a href="#">출력몰</a></li>
					</ul>
				</li>
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="lnr lnr-briefcase"></i> <span>회계</span> <i class="icon-submenu lnr lnr-chevron-down"></i></a>
					<ul class="dropdown-menu">
						<li><a href="#">기초등록</a></li>
						<li><a href="#">매출매입거래</a></li>
						<li><a href="#">전자(세금)계산서</a></li>
						<li><a href="#">계좌/카드</a></li>
						<li><a href="#">현금거래</a></li>
						<li><a href="#">비현금거래</a></li>
						<li><a href="#">어음거래</a></li>
					</ul>
				</li>
				 -->
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown"><img src="${contextPath}/resources/assets/img/user.png" class="img-circle" alt="Avatar"> <span>Samuel</span> <i class="icon-submenu lnr lnr-chevron-down"></i></a>
					<ul class="dropdown-menu">
						<li><a href="#"><i class="lnr lnr-user"></i> <span>My Profile</span></a></li>
						<li><a href="#"><i class="lnr lnr-envelope"></i> <span>Message</span></a></li>
						<li><a href="#"><i class="lnr lnr-cog"></i> <span>Settings</span></a></li>
						<li><a href="#"><i class="lnr lnr-exit"></i> <span>Logout</span></a></li>
					</ul>
				</li>
						<!-- <li>
							<a class="update-pro" href="https://www.themeineed.com/downloads/klorofil-pro-bootstrap-admin-dashboard-template/?utm_source=klorofil&utm_medium=template&utm_campaign=KlorofilPro" title="Upgrade to Pro" target="_blank"><i class="fa fa-rocket"></i> <span>UPGRADE TO PRO</span></a>
						</li> -->
					</ul>
				</div>
			</div>
		</nav>