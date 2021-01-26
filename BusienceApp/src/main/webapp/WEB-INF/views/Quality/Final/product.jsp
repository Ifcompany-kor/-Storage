<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%
String Name = (String)session.getAttribute("name");
String Sel = "'"+Name+"'";
if(Name == null)
{
   RequestDispatcher rd = request.getRequestDispatcher("/");
   rd.forward(request, response);
}

Calendar cal = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
String datestr = sdf.format(cal.getTime());
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport"
   content="width=device-width, initial-scale=0.8, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<link href="${contextPath}/resources/css/styles.css" rel="stylesheet" />
<link
   href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css"
   rel="stylesheet" crossorigin="anonymous" />
<script
   src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/js/all.min.js"
   crossorigin="anonymous"></script>
<title>Xeonic - Mes App</title>
<script type="text/javascript"
   src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
<link
   href="https://unpkg.com/tabulator-tables@4.8.4/dist/css/tabulator.min.css"
   rel="stylesheet">
<script type="text/javascript"
   src="https://unpkg.com/tabulator-tables@4.8.4/dist/js/tabulator.min.js"></script>

</head>
<script>
   function searchBtn() {
      if (document.getElementById('startDate').value.length < 10) {
         alert("시작일은 반드시 입력하여 주십시오.");
         return;
      }

      if (document.getElementById('endDate').value.length < 10) {
         alert("끝일은 반드시 입력하여 주십시오.");
         return;
      }
      // 검색 초기화
      var PRODUCT_ITEM_CODE = "";
      if (document.getElementById('PRODUCT_ITEM_NAME').value == "") {
    	  if(document.getElementById('PRODUCT_ITEM_CODE').value != "")
    	  document.getElementById('PRODUCT_ITEM_CODE').value = PRODUCT_ITEM_CODE
      }

      data = {
         startDate : document.getElementById('startDate').value,
         endDate : document.getElementById('endDate').value,
         PRODUCT_ITEM_CODE : document.getElementById('PRODUCT_ITEM_CODE').value,
         PRODUCT_ITEM_NAME : document.getElementById('PRODUCT_ITEM_NAME').value
      //PRODUCTION_DEFECT_CODE : document.getElementById('PRODUCTION_DEFECT_CODE').value
      }

      $.ajax({
         method : "GET",
         url : "${contextPath}/FinalRest/FinalProduct?data="
               + encodeURI(JSON.stringify(data)) + "",
         success : function(data) {
            datas = data;
            console.log(datas);
            tableSetting(datas);
         },
       //로딩중
	       beforeSend: function () {
	              var width = 0;
	              var height = 0;
	              var left = 0;
	              var top = 0;

	              width = 50;
	              height = 50;

	              top = ( $(window).height() - height ) / 2 + $(window).scrollTop();
	              left = ( $(window).width() - width ) / 2 + $(window).scrollLeft();		 

	              if($("#div_ajax_load_image").length != 0) {
	                     $("#div_ajax_load_image").css({
	                            "top": top+"px",
	                            "left": left+"px"
	                     });
	                     $("#div_ajax_load_image").show();
	              }
	              else {
	                     $('body').append('<div id="div_ajax_load_image" style="position:absolute; top:'
	                     + top + 'px; left:' + left + 'px; width:' + width + 'px; height:'
	                     + height + 'px; z-index:9999; filter:alpha(opacity=50); opacity:alpha*0.5; margin:auto; padding:0; ">'
	                     + '<img src="${contextPath}/resources/images/loading.gif" style="width:50px; height:50px;"></div>');
	              }
	       },
	       //로딩완료
	       complete: function () {
	                     $("#div_ajax_load_image").hide();
	       }
      });
   }
   function resetBtn() {
      location.reload();
   }
   function PRODUCT_ITEM_CODE_SELECT() {
      // 웹 브라우저내에 PRODUCT_ITEM_NAME변수를 생성해서 PRODUCT_ITEM_NAME이라는 ID값의 Input태그에 담긴 값을 임시적으로 저장한다.
      localStorage.setItem('PRODUCT_ITEM_NAME', document
            .getElementById("PRODUCT_ITEM_NAME").value);
      var url = "${contextPath}/ProductQuality_ItemCode";
      var name = "PRODUCT_ITEM_CODE";
      var option = "width = 500, height = 500, top = 100, left = 200, location = no"
      openWin = window.open(url, name, option);
   }

   function PRODUCTION_DEFECT_CODE_SELECT() {
      // 웹 브라우저내에 PRODUCT_ITEM_NAME변수를 생성해서 PRODUCT_ITEM_NAME이라는 ID값의 Input태그에 담긴 값을 임시적으로 저장한다.
      localStorage.setItem('PRODUCTION_DEFECT_NAME', document
            .getElementById("PRODUCTION_DEFECT_NAME").value);
      var url = "${contextPath}/DefectQuality_ItemCode";
      var name = "PRODUCTION_DEFECT_CODE";
      var option = "width = 500, height = 500, top = 100, left = 200, location = no"
      openWin = window.open(url, name, option);
   }

   function tableSetting(datas) {
        table = new Tabulator("#example-table", {
    	//페이징
  		layout:"fitData",
        pagination:"local",
        responsiveLayout:"hide",
        paginationSize:20,
        //Sub Total 색상 
         rowFormatter : function(row) {
            if (row.getData().production_SERIAL_NUM == "소 합계") {
               row.getElement().style.backgroundColor = "#D8D8D8";
            }
         },
         height:"75%",
         //height:730, // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
         data : datas, //assign data to table
         columns : [ //Define Table Columns
         {title : "시리얼 넘버", field : "production_SERIAL_NUM", headerHozAlign : "center", hozAlign : "left"}, 
         {title : "품목 코드", field : "production_PRODUCT_CODE", headerHozAlign : "center", hozAlign : "left"}, 
         {title : "품목명", field : "product_ITEM_NAME", headerHozAlign : "center", hozAlign : "left"}, 
         {title : "생산 수량", field : "production_P_Qty", headerHozAlign : "center", hozAlign : "right"}, 
         {title : "불량 수량", field : "production_B_Qty", headerHozAlign : "center", hozAlign : "right"}, 
         {title : "불량 율", field : "production_DEFECT_RATE", headerHozAlign : "center", hozAlign : "right"}, 
         {title : "설비 코드", field : "production_EQUIPMENT_CODE", headerHozAlign : "center", hozAlign : "left"}, 
         {title : "설비 명", field : "production_EQUIPMENT_INFO_NAME", headerHozAlign : "center", hozAlign : "left"}, 
         {title : "금형No", field : "production_MOLD_INFO_CODE", headerHozAlign : "center", hozAlign : "left"}, 
         {title : "금형 명", field : "production_MOLD_INFO_NAME", headerHozAlign : "center", hozAlign : "left"}, 
         {title : "시간", field : "production_MODIFY_D", headerHozAlign : "center", hozAlign : "right"} 
         ]

      });
   }
</script>
<body class="sb-nav-fixed">
   <!- sb topnave -->
   <jsp:include page="../../sb-topnav.jsp"></jsp:include>
   <form id="defectFrm" name="f"></form>
   <div id="layoutSidenav">
      <!-- layoutSidenav_nav -->
      <jsp:include page="../../layoutSidenav_nav.jsp"></jsp:include>
      <div id="layoutSidenav_content">
         <div
            style="overflow: hidden; width: 100%; height: 100%; padding-left: 10px; padding-right: 10px;">
            <div
               style="width: 100%; float: none; margin-top: 5px; padding-bottom: 5px;">
               <div
                  style="width: 100%; background: #F2F2F2; border-collapse: separate; border: solid 0.5px;">
                  <table
                     style="width: 100%; table-layout: fixed; border-collapse: separate; border-spacing: 0 5px;">
                     <tr>
                        <td colspan="25"><font style="margin-left: 5px;"
                           size="5px;" face="Noto Sans KR">최종 검사 (제품별)</font></td>
                     </tr>
                     <tr>
                        <td colspan="6"></td>
                        <td colspan="14"><font size="5px;" face="Noto Sans KR"></font>
                        </td>
                     </tr>
                     <tr>
                        <td colspan="3"></td>
                        <td colspan="2" align="right">일자별&nbsp;</td>
                        <td colspan="3" align="left"><input id="startDate"
                           type="date" style="width: 90%; height: 27px;"
                           autocomplete="off"
                           onkeypress="javascript:if(event.keyCode==13) {document.getElementById('defectName').focus()}">
                        </td>
                        <td colspan="1" align="center">~</td>
                        <td colspan="3" align="left"><input id="endDate"
                           type="date" style="width: 90%; height: 27px;"
                           autocomplete="off"
                           onkeypress="javascript:if(event.keyCode==13) {document.getElementById('DEFECT_RMRKS').focus()}">
                        </td>
                        <td colspan="7" align="left" style="color: red;">(기준) 시작일 : 08:30:00 ~ 종료일 : 08:29:59
                        </td>
                     </tr>
                     <tr>
                        <td colspan="3"></td>
                        <td colspan="2" align="right">품목코드&nbsp;</td>
                        <td colspan="3" align="left"><input id="PRODUCT_ITEM_CODE"
                           type="text" style="width: 90%;" autocomplete="off"
                           disabled="disabled"></td>
                        <td colspan="1" align="right">품목명&nbsp;</td>
                        <td colspan="3" align="left"><input id="PRODUCT_ITEM_NAME"
                           type="text" style="width: 90%;" autocomplete="off"
                           onkeypress="javascript:if(event.keyCode==13) {PRODUCT_ITEM_CODE_SELECT()}">
                        </td>
                     </tr>
                  </table>

                  <table
                     style="width: 100%; table-layout: fixed; margin-bottom: 5px; margin-top: 5px;">
                     <tr>
                        <td colspan="20" style="margin-left: 5px;">&nbsp;
                           <button onclick="searchBtn()" type="button"
                              style="font-size: 13px; width: 80px; font-family: 'Noto Sans KR', sans-serif;"
                              class="btn btn-default btn-sm">
                              <span class="glyphicon glyphicon-search" aria-hidden="true"></span>
                              SEARCH
                           </button>
                           <button onclick="resetBtn()" type="button"
                              style="font-size: 13px; width: 80px; font-family: 'Noto Sans KR', sans-serif;"
                              class="btn btn-default btn-sm">
                              <span class="glyphicon glyphicon-refresh" aria-hidden="true"></span>
                              RESET
                           </button>
                        </td>
                     </tr>
                  </table>
               </div>
            </div>

            <div id="example-table"></div>
         </div>
      </div>
   </div>

   <script>
	window.onload = function() {
		//startDate
		var date = new Date();
		var year = date.getFullYear();
		var month = new String(date.getMonth() + 1);
		var day = new String(date.getDate());
		var day1 = new String(date.getDate() +1);

		// 한자리수일 경우 0을 채워준다. 
		if (month.length == 1) {
			month = "0" + month;
		}
		if (day.length == 1) {
			day = "0" + day;
		}
		if (day1.length == 1) {
			day1 = "0" + day1;
		}

		document.getElementById('startDate').value = year + "-" + month
				+ "-" + day;
		document.getElementById('endDate').value = year + "-" + month + "-"
				+ day1;
		
	}
   </script>

   <!-- This is the localization file of the grid controlling messages, labels, etc.
       <!-- A link to a jQuery UI ThemeRoller theme, more than 22 built-in and many more custom -->
   <link rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">

   <link rel="preconnect" href="https://fonts.gstatic.com">
   <link
      href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400&display=swap"
      rel="stylesheet">

   <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
      crossorigin="anonymous"></script>
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