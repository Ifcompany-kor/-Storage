<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<%
String Name = (String)session.getAttribute("name");
String Sel = "'"+Name+"'";
if(Name == null)
{
   RequestDispatcher rd = request.getRequestDispatcher("/");
   rd.include(request, response);
   return;
}
%>

<meta charset="UTF-8">
	<nav class="sb-topnav navbar navbar-expand navbar-dark bg-secondary">
            <a class="navbar-brand" href="${contextPath}/main">Xeonic</a>
            <button class="btn btn-link btn-sm order-1 order-lg-0" id="sidebarToggle" href="#"><i class="fas fa-bars"></i></button>
        	<!-- Navbar Search-->
            <form class="d-none d-md-inline-block form-inline ml-auto mr-0 mr-md-3 my-2 my-md-0">
                <input class="form-control" type="text" placeholder="<%=Name%>" disabled="disabled" style="width: 100px;"/>
            </form>
            <!-- Navbar-->
            <ul class="navbar-nav ml-auto ml-md-0">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="userDropdown" href="#" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
                        <a class="dropdown-item" onclick="javascript:window.open('${contextPath}/pwchange', 'logout', 'width=500,height=650,top=250,left=1000');">비밀번호 변경</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" onclick="javascript:flag = confirm('로그아웃을 진행하시겠습니까?'); if(flag) location.href='${contextPath}/logout'">로그아웃</a>
                    </div>
                </li>
            </ul>
        </nav>
        
        