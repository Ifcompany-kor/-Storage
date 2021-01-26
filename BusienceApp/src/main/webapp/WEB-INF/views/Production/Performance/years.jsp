<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%
	String Name = (String) session.getAttribute("name");
String Sel = "'" + Name + "'";
/*    if(Name == null || Name.equals(""))
      response.sendRedirect(request.getContextPath());  */

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
	//검색
	function searchBtn() {
		if (document.getElementById('startDate').value.length < 1) {
			alert("시작일은 반드시 입력하여 주십시오.");
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
			PRODUCT_ITEM_CODE : document.getElementById('PRODUCT_ITEM_CODE').value,
			PRODUCT_ITEM_NAME : document.getElementById('PRODUCT_ITEM_NAME').value
		}

		$.ajax({
			method : "GET",
			url : "${contextPath}/PerformanceRest/YearsProduct?data="+ encodeURI(JSON.stringify(data)) + "",
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
	//리셋
	function resetBtn() {
        location.reload();
     }
	//팝업
	function PRODUCT_ITEM_CODE_SELECT() {
		// 웹 브라우저내에 PRODUCT_ITEM_NAME변수를 생성해서 PRODUCT_ITEM_NAME이라는 ID값의 Input태그에 담긴 값을 임시적으로 저장한다.
		localStorage.setItem('PRODUCT_ITEM_NAME', document.getElementById("PRODUCT_ITEM_NAME").value);
		var url = "${contextPath}/product_popup";
		var name = "PRODUCT_ITEM_CODE";
		var option = "width = 500, height = 500, top = 100, left = 200, location = no"
		openWin = window.open(url, name, option);
	}
	
	//테이블 생성
	
	function tableSetting(datas) {
		table = new Tabulator("#example-table", { 
			//페이징
			layout:"fitData",
        	//responsiveLayout:"hide",
        	//pagination:"local",
        	paginationSize:20,
        	//Grand Total 색상
			rowFormatter: function(row){
	    		if(row.getData().product_ITEM_NAME == "Grand Total"){
	                row.getElement().style.backgroundColor = "#D8D8D8";
	                }
	        },
        	virtualDomHoz:true,
        	width: "80%",
	    	height:"75%",
	     	//height:730, // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
	     	data:datas, //assign data to table
	     	columnHeaderVertAlign:"bottom",
		        columns:[
		        	//{rowHandle:true, formatter:"handle", headerSort:false, frozen:true, width:30, minWidth:30},
		        	{title:"품목 코드", field:"production_PRODUCT_CODE", headerHozAlign:"center",hozAlign:"center"},
	     			{title:"품목명", field:"product_ITEM_NAME", headerHozAlign:"center"},
	     			{
	     				title: "1월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_1", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_1", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_1", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_1", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			}, {
	     				title: "2월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_2", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_2", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_2", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_2", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			},
	     			{
	     				title: "3월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_3", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_3", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_3", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_3", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			}, {
	     				title: "4월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_4", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_4", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_4", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_4", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			},
	     			{
	     				title: "5월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_5", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_5", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_5", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_5", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			}, {
	     				title: "6월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_6", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_6", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_6", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_6", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			},
	     			{
	     				title: "7월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_7", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_7", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_7", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_7", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			}, {
	     				title: "8월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_8", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_8", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_8", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_8", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			},
	     			{
	     				title: "9월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_9", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_9", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_9", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_9", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			}, {
	     				title: "10월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_10", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_10", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_10", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_10", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			},
	     			{
	     				title: "11월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_11", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_11", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_11", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_11", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			}, {
	     				title: "12월",
	     				columns: [
	     					{title:"생산 수량", field:"production_P_Qty_12", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 수량", field:"production_B_Qty_12", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 수량", field:"production_PRODUCTS_VOLUME_12", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"production_DEFECT_RATE_12", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			}, {
	     				title: "연간",
	     				columns: [
	     					{title:"생산 합계", field:"sum_PRODUCTION_P_Qty", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량 합계", field:"sum_PRODUCTION_B_Qty", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"양품 합계", field:"sum_PRODUCTION_PRODUCTS_VOLUME", headerHozAlign:"center",hozAlign:"right"},
	    			     	{title:"불량율", field:"sum_PRODUCTION_PRODUCTION_DEFECT_RATE", headerHozAlign:"center",hozAlign:"right"},
	     				],
	     			},
		        ],
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
									size="5px;" face="Noto Sans KR">생산 실적 관리 (연별)</font></td>
							</tr>
							<tr>
								<td colspan="6"></td>
								<td colspan="14"><font size="5px;" face="Noto Sans KR"></font>
								</td>
							</tr>
							<tr>
								<td colspan="3"></td>
								<td colspan="2" align="right">연도&nbsp;</td>
								<td colspan="3" align="left"><input id="startDate"
									type="number" style="width: 90%; height: 27px;"
									autocomplete="off"
									onkeypress="javascript:if(event.keyCode==13) {document.getElementById('defectName').focus()}">
								</td>
								<td colspan="7" align="left" style="color: red;"></td>
							</tr>
							<tr>
								<td colspan="3"></td>
								<td colspan="2" align="right">제품코드&nbsp;</td>
								<td colspan="3" align="left"><input id="PRODUCT_ITEM_CODE"
									type="text" style="width: 90%;" autocomplete="off"
									disabled="disabled"></td>
								<td colspan="1" align="right">제품명&nbsp;</td>
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

				<div id="example-table" style="overflow: auto;"></div>
			</div>
		</div>
	</div>

	<script>
	window.onload = function() {
        //startDate
        var date = new Date();
        var year = date.getFullYear();
        var year1 = date.getFullYear()+1;
        var month = new String(date.getMonth() + 1);
        var day = new String(date.getDate());
        var day1 = new String(date.getDate() +1);

       	
        document.getElementById('startDate').value = year;
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