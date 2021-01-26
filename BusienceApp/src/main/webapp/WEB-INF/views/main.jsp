<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<%
   String Name = (String)session.getAttribute("name");
   String Sel = "'"+Name+"'";
    if(Name == null || Name.equals(""))
      response.sendRedirect(request.getContextPath()); 
   
   Calendar cal = Calendar.getInstance();
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   String datestr = sdf.format(cal.getTime());
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <link href="${contextPath}/resources/css/styles.css" rel="stylesheet" />
        <link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/js/all.min.js" crossorigin="anonymous"></script>
        <title>Xeonic - Mes App</title>
        <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
        <link href="https://unpkg.com/tabulator-tables@4.8.4/dist/css/tabulator.min.css" rel="stylesheet">
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@4.8.4/dist/js/tabulator.min.js"></script>
    
    </head>
    <script>
    

       function CheckEnter(frm, objName)
       {
           var keycode = event.keyCode;        
           var i = 0;
           var USER_CODE = document.getElementById("USER_CODE");
           console.log(keycode);
           console.log(frm);
           if( keycode == 13 ){
             document.getElementById("USER_NAME").focus();
           }
       }
       // 변수 초기값
       var resultFlag = "None";
       // reset
       function resetBtn() {
          location.reload();
       }
       // new
       // 공백으로 만들어서 입력할 수 있게한다.
       function newBtn() {
             resultFlag ="New";
            document.getElementById("USER_CODE").removeAttribute('disabled');
            document.getElementById("USER_CODE").value = "";
            document.getElementById("USER_NAME").value = "";
            document.getElementById("USER_CODE").focus();
       }
       
       function deleteBtn() {
          if (resultFlag!="Changed")
          {
             alert("행을 선택 후에 삭제 버튼을 눌러주십시오.");
             return;
          }
          conf =  confirm("삭제 하시겠습니까?");
         if(!conf)
            return;
                 
           $.ajax({
              method: "POST",
              data : null,
              url: "${contextPath}/UserRest/delete2.do?USER_CODE="+document.getElementById("USER_CODE").value,
              success: function (data,testStatus) {
                console.log(data);
                alert("삭제 성공 하였습니다.");
                    resetBtn();
                }
           });
       
       }
       // 추가, 삭제, 수정을 처리하는 로직
       function saveBtn() {
          // 추가 로직 + 유효성 검사
          //  var USER_USE_STATUS = ""; -> true냐 false냐 받아오기 위한 로직
         if(resultFlag=="New")
         {
            conf =  confirm("저장 하시겠습니까?");
            if(!conf)
               return;
            var check_count = document.getElementsByName("USER_USE_STATUS").length;
                  var USER_USE_STATUS = "";
                   
                    for (var i=0; i<check_count; i++) {
                        if (document.getElementsByName("USER_USE_STATUS")[i].checked == true) {
                           USER_USE_STATUS = document.getElementsByName("USER_USE_STATUS")[i].value;
                        }
                    }
                  
                  if(document.getElementById("USER_CODE").value=="")
                  {
                     alert("사용자 코드는 반드시 입력하셔야 합니다.");
                     return;
                  }
                  if(document.getElementById("USER_CODE").value.length > 10)
                  {
                     alert("사용자 코드는 10글자 이하로 입력해주세요.");
                     return;
                  }
                  
                  data = {
                         USER_CODE : document.getElementById("USER_CODE").value,
                         USER_NAME : document.getElementById("USER_NAME").value,
                         COMPANY : $("#COMPANY option:selected").val(),
                         USER_TYPE : $("#USER_TYPE option:selected").val(),
                         USER_MODIFIER : <%=Sel%>,
                         USER_USE_STATUS : USER_USE_STATUS,
                         DEPT_CODE : $("#DEPT_CODE option:selected").val()
                      }
                  
                  // alert(JSON.stringify(data));
                  //   success: function (data,testStatus) {
                   //         console.log(data);
                   //      }restController에서 받아온 값
                   // if(data == "Overlap") 코드중복체크
                  $.ajax({
                     method: "POST",
                      data : null,
                      url: "${contextPath}/UserRest/insert2.do?data="+encodeURI(JSON.stringify(data))+"",
                      success: function (data,testStatus) {
                         console.log(data);
                        if(data == "Overlap")
                               alert("중복 코드를 입력하셨습니다. 다시 입력해주세요.");
                            else
                            {
                               alert("입력 성공 하였습니다.");
                               resetBtn();
                            }
                      }
                  });
         }
      //  수정로직
            
      else if(resultFlag="Changed")  {
         conf =  confirm("수정 하시겠습니까?");
         if(!conf)
            return;
         var check_count = document.getElementsByName("USER_USE_STATUS").length;
               var USER_USE_STATUS = "";
                
                 for (var i=0; i<check_count; i++) {
                     if (document.getElementsByName("USER_USE_STATUS")[i].checked == true) {
                        USER_USE_STATUS = document.getElementsByName("USER_USE_STATUS")[i].value;
                     }
                 }
                 
                 data = {
                         USER_CODE : document.getElementById("USER_CODE").value,
                         USER_NAME : document.getElementById("USER_NAME").value,
                         COMPANY : $("#COMPANY option:selected").val(),
                         USER_TYPE : $("#USER_TYPE option:selected").val(),
                         USER_MODIFIER : <%=Sel%>,
                         USER_USE_STATUS : USER_USE_STATUS,
                         DEPT_CODE : $("#DEPT_CODE option:selected").val()
                      }
                  
                  // alert(JSON.stringify(data));
                  //   success: function (data,testStatus) {
                   //         console.log(data);
                   //      }restController에서 받아온 값
                   // if(data == "Overlap") 코드중복체크
                  $.ajax({
                     method: "POST",
                      data : null,
                      url: "${contextPath}/UserRest/update2.do?data="+encodeURI(JSON.stringify(data))+"",
                      success: function (data,testStatus) {
                         console.log(data);
                        alert("수정 성공 하였습니다.");
                         resetBtn();
                      }
                  });
      }
       }
          // 비번 초기화
          function pwReset() {
             if (resultFlag!="Changed")
              {
                 alert("행을 선택 후에 초기화 버튼을 눌러주십시오.");
                 return;
              }
              conf =  confirm("초기화 하시겠습니까?");
             if(!conf)
                return;
                     
               $.ajax({
                  method: "POST",
                  data : null,
                  url: "${contextPath}/UserRest/pwReset2.do?USER_CODE="+document.getElementById("USER_CODE").value,
                  success: function (data,testStatus) {
                    console.log(data);
                    alert("초기화 성공 하였습니다.");
                        resetBtn();
                    }
               });             
          
       }
    
    </script>
    <body class="sb-nav-fixed" style="overflow:hidden;">
        <!-- sb topnave -->
        <jsp:include page="sb-topnav.jsp"></jsp:include>
        <form id="defectFrm" name="f"></form>
        <div id="layoutSidenav">
           <!-- layoutSidenav_nav -->
            <jsp:include page="layoutSidenav_nav.jsp"></jsp:include>
            <div id="layoutSidenav_content">
                <div style="height: 20%;">
		                	</div>
		                	<div style="height: 20%;">
		                	<center>
		                		<img src="${contextPath}/resources/images/2.png" alt="PNG">	<br/>
		                		<font size="2">본 홈페이지는 크롬 브라우저에 최적화 되어 있습니다.<br/>크롬브라우저는 아래의 링크에서 다운받으실 수 있습니다.
		                		<br/><a href="https://www.google.co.kr/chrome/?brand=JJTC&gclid=CjwKCAiAwrf-BRA9EiwAUWwKXqU1aLm5DN7vauFEvEmiL-O3XZeVIQ65zT88-WuV4QG9gIZd32Xb3BoC2nwQAvD_BwE&gclsrc=aw.ds">다운로드</a></font>
		                	</center>
		                	</div>
		                	<div style="height: 20%;">
		                	</div>
		                	<div style="height: 10%;">
		                	</div>
		                	<div style="height: 20%; text-align: right;padding-top: 120px;">
		                		<img src="${contextPath}/resources/images/1.jpg" alt="JPG">
		                	</div>
		                	<div style="height: 3%;">
		                	</div>
            </div>
        </div>
        
       <!-- This is the localization file of the grid controlling messages, labels, etc.
       <!-- A link to a jQuery UI ThemeRoller theme, more than 22 built-in and many more custom -->
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"> 
        
        <link rel="preconnect" href="https://fonts.gstatic.com">
      <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400&display=swap" rel="stylesheet">        
         
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="${contextPath}/resources/js/scripts.js"></script>
        
        <!-- 
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
        <script src="${contextPath}/resources/assets/demo/chart-area-demo.js"></script>
        <script src="${contextPath}/resources/assets/demo/chart-bar-demo.js"></script>
        <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
        <script src="${contextPath}/resources/assets/demo/datatables-demo.js"></script>
         -->
         
         <script type="text/javascript">
           //$('.tabulator-header').css('font-size', 15);
           //$('.tabulator-header').css('padding-top', '-15px');
           //$('.tabulator-header').css('height', 15);
           //$('.tabulator-header').css('font-size', 5);
           //$('.tabulator-header').css('padding-bottom', '20px');
           //$('.tabulator-header').css('text-align', 'center');
        </script>
    </body>
</html>