<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
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

String sql = "select \r\n"
		+ "		t1.*,\r\n"
		+ "        t2.CHILD_TBL_TYPE MENU_PROGRAM_NAME\r\n"
		+ "from	\r\n"
		+ "		(\r\n"
		+ "			select\r\n"
		+ "					*\r\n"
		+ "			from\r\n"
		+ "					MENU_MGMT_TBL\r\n"
		+ "			where MENU_USER_CODE = '"+session.getAttribute("id")+"'\r\n"
		+ "        ) t1\r\n"
		+ "right outer join \r\n"
		+ "		(\r\n"
		+ "			select \r\n"
		+ "					* \r\n"
		+ "			from DTL_TBL where NEW_TBL_CODE='13'\r\n"
		+ "            and CHILD_TBL_TYPE = '생산 실적 관리'\r\n"
		+ "        ) t2\r\n"
		+ "on t1.MENU_PROGRAM_CODE = t2.CHILD_TBL_NUM order by MENU_PROGRAM_CODE+0\r\n";

System.out.println(sql);

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://xeonic11.cafe24.com:3306/xeonic11","xeonic11","gil45200!");
PreparedStatement pstmt = con.prepareStatement(sql);
ResultSet rs = pstmt.executeQuery(sql);

ResultSetMetaData rsmd = rs.getMetaData();
int columnCnt = rsmd.getColumnCount(); //컬럼의 수
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
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
<script type="text/javascript"
	src="https://momentjs.com/downloads/moment.js"></script>
<script>
//행색상
var element = null;
//헹번호
var rowNo = null;
//표
var table = null;
//페이지번호
var pageNo = "1";
//검색기록
var PCsearch = "";
var PNsearch = "";
var ECsearch = "";
var ENsearch = "";
//행선택여부
var rowsel = null;

// 설비연식 자동 입력
function date_change(today) {
   var date =  today.value;
   var substr = date.substring(0,4);
   document.getElementById('EQUIPMENT_MODEL_YEAR').value = substr;
}

//공백
function vac() {
	//번호
    document.getElementById("PRODUCTION_INFO_NUM").value = "";
    //시리얼번호
    document.getElementById("PRODUCTION_SERIAL_NUM").value = "";
    //제품코드
    document.getElementById("PRODUCT_ITEM_CODE").value = "";
    //제품명
    document.getElementById("PRODUCT_ITEM_NAME").value = "";
    //불량코드
    document.getElementById("DEFECT_CODE").value = "";
	//불량명
    document.getElementById("DEFECT_NAME").value = "";
    //불량수량
    document.getElementById("PRODUCTION_B_Qty").value = "";
    //설비코드
    document.getElementById("EQUIPMENT_INFO_CODE").value = "";
    //설비명
    document.getElementById("EQUIPMENT_INFO_NAME").value = "";
	//불량코드
    document.getElementById("PRODUCTION_VOLUME").value = "";
}

// 삭제
function deleteBtn() {
	if(rowsel == null){
		rowsel = null;
		alert("행을 선택한 후에 삭제 버튼을 눌러주십시오.");
		return;
	}else{
		if(confirm("정말 삭제하시겠습니까 ?") == true){
			console.log("숫자 "+$("#PRODUCTION_INFO_NUM").val());
			console.log("시리얼 "+$("#PRODUCTION_SERIAL_NUM").val());
			 data = {
					PRODUCTION_INFO_NUM : $("#PRODUCTION_INFO_NUM").val(),
	                PRODUCTION_SERIAL_NUM : $("#PRODUCTION_SERIAL_NUM").val()
		          }
			$.ajax({
			   method: "POST",
			    data : null,
			    url: "${contextPath}/PhistoryRest/delete4.do?data="+encodeURI(JSON.stringify(data)),
			    success : function(data,testStatus)  {
			    	console.log(data);
		        	alert("삭제되었습니다.");
		        	research();
			       }
			    });
			 vac();
	    }
	    else{
	        return ;
	    }
	}
}

// 수정
function updateBtn() {
	if(rowsel == null){
		rowsel = null;
		alert("행을 선택한 후에 수정 버튼을 눌러주십시오.");
		return;
	}else{
		if(confirm("정말 수정하시겠습니까 ?") == true){
			//D999로는 수정불가
			if($("#DEFECT_CODE").val() == "D999"){
				confirm("불량코드 D999로는 수정하실 수 없습니다.");
				return;
			}else{
				data = {
						PRODUCTION_INFO_NUM : $("#PRODUCTION_INFO_NUM").val(),
		                PRODUCTION_SERIAL_NUM : $("#PRODUCTION_SERIAL_NUM").val(),
		                PRODUCTION_DEFECT_CODE : $("#DEFECT_CODE").val(),
		                PRODUCTION_DEFECT_NAME : $("#DEFECT_NAME").val(),
		                PRODUCTION_B_Qty : $("#PRODUCTION_B_Qty").val()
			          }
				$.ajax({
				   method: "POST",
				    data : null,
				    url: "${contextPath}/PhistoryRest/update4.do?data="+encodeURI(JSON.stringify(data))+"",
				    success : function(data,testStatus)  {
				    	if(data=="CodeCheck")
				    	{
				    		alert("팝업창으로 불량코드를 선택해주세요.");
				    	    //불량코드
				    	    document.getElementById("DEFECT_CODE").value = "";
				    		//불량명
				    	    document.getElementById("DEFECT_NAME").value = "";
				    		return;
				    	}
				    	
				       console.log(data);
				         alert("수정 되었습니다.");
				         research();
						vac();
				       }
				    });
			}
	    }
	    else{
	        return ;
	    }
	}
}

	//검색기능
	function searchBtn() {
		if (document.getElementById('startDate').value.length < 10) {
			alert("시작일은 반드시 입력하여 주십시오.");
			return;
		}

		if (document.getElementById('endDate').value.length < 10) {
			alert("끝일은 반드시 입력하여 주십시오.");
			return;
		}
		data = {
		startDate : document.getElementById('startDate').value,
		endDate : document.getElementById('endDate').value,
		PRODUCT_ITEM_CODE : document.getElementById('PRODUCT_ITEM_CODE').value,
		PRODUCT_ITEM_NAME : document.getElementById('PRODUCT_ITEM_NAME').value,
		EQUIPMENT_INFO_CODE : document.getElementById('EQUIPMENT_INFO_CODE').value,
		EQUIPMENT_INFO_NAME : document.getElementById('EQUIPMENT_INFO_NAME').value
		}
		//검색 기록
		PCsearch = document.getElementById('PRODUCT_ITEM_CODE').value;
		PNsearch = document.getElementById('PRODUCT_ITEM_NAME').value;
		ECsearch = document.getElementById('EQUIPMENT_INFO_CODE').value;
		ENsearch = document.getElementById('EQUIPMENT_INFO_NAME').value;
		$.ajax({
			method : "GET",
			url : "${contextPath}/PhistoryRest/PhistoryEquipment?data="
					+ encodeURI(JSON.stringify(data)),
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
	
	//재검색기능
	function research() {
		if (document.getElementById('startDate').value.length < 10) {
			alert("시작일은 반드시 입력하여 주십시오.");
			return;
		}

		if (document.getElementById('endDate').value.length < 10) {
			alert("끝일은 반드시 입력하여 주십시오.");
			return;
		}
		data = {
		startDate : document.getElementById('startDate').value,
		endDate : document.getElementById('endDate').value,
		PRODUCT_ITEM_CODE : PCsearch,
		PRODUCT_ITEM_NAME : PNsearch,
		EQUIPMENT_INFO_CODE : ECsearch,
		EQUIPMENT_INFO_NAME : ENsearch
		}
		$.ajax({
			method : "GET",
			url : "${contextPath}/PhistoryRest/PhistoryEquipment?data="
					+ encodeURI(JSON.stringify(data)),
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
			       table.setPage(pageNo);
			       console.log("페이지이동");
		    	   console.log("로딩완료");
		       }
		});
	}	
	//리셋
	function resetBtn() {
		location.reload();
	}
	//제품명 팝업
	function PRODUCT_ITEM_CODE_SELECT() {
		// 웹 브라우저내에 PRODUCT_ITEM_NAME변수를 생성해서 PRODUCT_ITEM_NAME이라는 ID값의 Input태그에 담긴 값을 임시적으로 저장한다.
		localStorage.setItem('PRODUCT_ITEM_NAME', document
				.getElementById("PRODUCT_ITEM_NAME").value);
		var url = "${contextPath}/product_popup";
		var name = "PRODUCT_ITEM_CODE";
		var option = "width = 500, height = 500, top = 100, left = 200, location = no"
		openWin = window.open(url, name, option);
	}
	
	//설비명 팝업
	function EQUIPMENT_ITEM_CODE_SELECT() {
		// 웹 브라우저내에 PRODUCT_ITEM_NAME변수를 생성해서 PRODUCT_ITEM_NAME이라는 ID값의 Input태그에 담긴 값을 임시적으로 저장한다.
		localStorage.setItem('EQUIPMENT_INFO_NAME', document
				.getElementById("EQUIPMENT_INFO_NAME").value);
		var url = "${contextPath}/equipment_popup";
		var name = "EQUIPMENT_ITEM_CODE";
		var option = "width = 500, height = 500, top = 100, left = 200, location = no"
		openWin = window.open(url, name, option);
	}
	
	//불량명 팝업
	function DEFECT_CODE_SELECT() {
		localStorage.setItem('DEFECT_CODE', "");
		var url = "${contextPath}/defect_popup";
		var name = "DEFECT_ITEM_CODE";
		var option = "width = 500, height = 500, top = 100, left = 200, location = no";
		openWin = window.open(url, name, option);
	}
	
	function tableSetting(datas) {
		table = new Tabulator("#example-table", {
			//페이징
			layout:"fitColumns",
        	pagination:"local",
        	responsiveLayout:"hide",
        	paginationSize:20,
		    //Sub Total 색상
			rowFormatter: function(row){
	    		if(row.getData().production_INFO_NUM == "Sub Total"){
	                row.getElement().style.backgroundColor = "#D8D8D8";
	                }
	    		//페이지이동후 색 변경
	    		if(row.getIndex() == rowNo){
	                row.getElement().style.backgroundColor = "#78EAFF";
	                element = row.getElement();
	                }
	        },
	    	height:"80%",
	     	//height:730, // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
	     	data:datas, //assign data to table
	     	//선택
	     	rowDblClick: function(e, row){
	     		table.getPage();
	     		console.log(table.getPage());
	     		pageNo = table.getPage();
	     		//행에 색변경
	     		if(element != null){
	     			element.style.background = "white";
	     		}
            		row.getElement().style.background = "#78EAFF";
            		element = row.getElement();
              		rowNo = row.getIndex();
              		rowsel = 1;
           // 더블클릭 이벤트 -> 열의 값을 가져옴

            //document.getElementById("input id 명칭").value = row.getData().컬럼 field 명칭;
            //번호
            document.getElementById("PRODUCTION_INFO_NUM").value = row.getData().production_INFO_NUM;
            //시리얼번호
            document.getElementById("PRODUCTION_SERIAL_NUM").value = row.getData().production_SERIAL_NUM;
            //제품코드
            document.getElementById("PRODUCT_ITEM_CODE").value = row.getData().production_PRODUCT_CODE;
            //제품명
            document.getElementById("PRODUCT_ITEM_NAME").value = row.getData().product_ITEM_NAME;
            //불량코드
            document.getElementById("DEFECT_CODE").value = row.getData().production_DEFECT_CODE;
            //불량명
            document.getElementById("DEFECT_NAME").value = row.getData().production_DEFECT_NAME;
            //불량수량
            document.getElementById("PRODUCTION_B_Qty").value = row.getData().production_B_Qty;
            //설비코드
            document.getElementById("EQUIPMENT_INFO_CODE").value = row.getData().production_EQUIPMENT_CODE;
            //설비명
            document.getElementById("EQUIPMENT_INFO_NAME").value = row.getData().production_EQUIPMENT_INFO_NAME;
            //생산수량
            document.getElementById("PRODUCTION_VOLUME").value = row.getData().production_P_Qty;
            
			//불량코드가 D999일경우
    		if(row.getData().production_DEFECT_CODE == "D999"){
    			//불량코드
    	        document.getElementById("DEFECT_CODE").value = "";
    	      	//불량명
    	        document.getElementById("DEFECT_NAME").value = "";
    	        //불량수량
    	        document.getElementById("PRODUCTION_B_Qty").value = "0";
    	      	//생산수량
    	        document.getElementById("PRODUCTION_VOLUME").value = row.getData().production_B_Qty;
    		}
             
	     	},
	     	columns:[ //Define Table Columns
	     	{title:"번호", field:"production_INFO_NUM", headerHozAlign:"center",hozAlign:"center", width:70},
	     	{title:"시리얼번호", field:"production_SERIAL_NUM", headerHozAlign:"center",hozAlign:"center", width:140},
	     	{title:"제품 코드", field:"production_PRODUCT_CODE", headerHozAlign:"center"},
	     	{title:"제품명", field:"product_ITEM_NAME", headerHozAlign:"center", width:150},
	     	{title:"생산 수량", field:"production_P_Qty", headerHozAlign:"center",hozAlign:"right"},
	     	{title:"설비 코드", field:"production_EQUIPMENT_CODE", headerHozAlign:"center",hozAlign:"left"},
	     	{title:"설비 명", field:"production_EQUIPMENT_INFO_NAME", headerHozAlign:"center",hozAlign:"left"},
	     	{title:"불량 수량", field:"production_B_Qty", headerHozAlign:"center",hozAlign:"right"},
	     	{title:"불량 코드", field:"production_DEFECT_CODE", headerHozAlign:"center",hozAlign:"right"},
	     	{title:"불량 명", field:"production_DEFECT_NAME", headerHozAlign:"center",hozAlign:"left"},
	     	{title:"금형No", field:"production_MOLD_INFO_CODE", headerHozAlign:"center",hozAlign:"left"},
		    {title:"금형 명", field:"production_MOLD_INFO_NAME", headerHozAlign:"center",hozAlign:"left"},
	     	{title:"시간", field:"production_MODIFY_D", headerHozAlign:"center",hozAlign:"right", width:155},
	     	{title:"사용자ID", field:"production_USER_CODE", headerHozAlign:"center",hozAlign:"left"},
	     	{title:"사용자명", field:"production_USER_NAME", headerHozAlign:"center",hozAlign:"left"},
	     	{title:"구분", field:"production_CC", headerHozAlign:"center",hozAlign:"left", width:70}
	     	]
	    });
	}
</script>
</head>
<body class="sb-nav-fixed">
	<!- sb topnave -->
	<jsp:include page="../sb-topnav.jsp"></jsp:include>

	<form id="moldFrm"></form>
	<div id="layoutSidenav">
		<!-- layoutSidenav_nav -->
		<jsp:include page="../layoutSidenav_nav.jsp"></jsp:include>
		<div id="layoutSidenav_content">
			<div
				style="overflow: hidden; width: 100%; height: 100%; padding-left: 10px; padding-right: 10px;">
				<div
					style="width: 100%; float: none; margin-top: 5px; padding-bottom: 5px;">
					<div
						style="width: 100%; background: #F2F2F2; border-collapse: separate; border-spacing: 0 2px; border: solid 0.5px;">
						<table
							style="width: 100%; table-layout: fixed; border-collapse: separate; border-spacing: 0 2px;">
							<tr>
								<td colspan="20"><font style="margin-left: 5px;"
									size="5px;" face="Noto Sans KR">생산 실적 관리</font></td>
							</tr>
							<tr>
								<td colspan="3"></td>
								<td colspan="1" align="right">일자별&nbsp;</td>
								<td colspan="2" align="left"><input id="startDate"
									type="date" style="width: 90%; height: 27px;"
									autocomplete="off"
									onkeypress="javascript:if(event.keyCode==13) {document.getElementById('defectName').focus()}">
								</td>
								<td colspan="1" align="center">~</td>
								<td colspan="2" align="left"><input id="endDate"
									type="date" style="width: 90%; height: 27px;"
									autocomplete="off"
									onkeypress="javascript:if(event.keyCode==13) {document.getElementById('DEFECT_RMRKS').focus()}">
								</td>
								<td colspan="1" align="right" style="color: red;">번호&nbsp;</td>
								<td colspan="2" align="left"><input id="PRODUCTION_INFO_NUM" type="text"
									style="width: 90%;" autocomplete="off" disabled="disabled">
								</td>
								<td colspan="1" align="right" style="color: red;">시리얼번호&nbsp;</td>
								<td colspan="2" align="left"><input id="PRODUCTION_SERIAL_NUM" type="text"
									style="width: 90%;" autocomplete="off" disabled="disabled">
								</td>
								<td colspan="1"></td>
							</tr>
							<tr>
								<td colspan="3"></td>
								<td colspan="1" align="right" style="color: red;">제품코드&nbsp;</td>
								<td colspan="2" align="left"><input id="PRODUCT_ITEM_CODE" type="text"
									style="width: 90%;" autocomplete="off" disabled="disabled">
								</td>
								<td colspan="1" align="right" style="color: red;">제품명&nbsp;</td>
								<td colspan="2" align="left"><input id="PRODUCT_ITEM_NAME" type="text"
									style="width: 90%;" autocomplete="off"
									onkeypress="javascript:if(event.keyCode==13) {PRODUCT_ITEM_CODE_SELECT()}">
								</td>
								<td colspan="1" align="right">불량코드&nbsp;</td>
								<td colspan="2" align="left"><input id="DEFECT_CODE" type="text"
									style="width: 90%;" autocomplete="off"
									onkeypress="javascript:if(event.keyCode==13) {DEFECT_CODE_SELECT()}"></td>
								<td colspan="1" align="right">불량명&nbsp;</td>
								<td colspan="2" align="left"><input id="DEFECT_NAME" type="text"
									style="width: 90%;" autocomplete="off" disabled="disabled"></td>
								<td colspan="1"></td>
								
							</tr>
							<tr>
								<td colspan="3"></td>
								<td colspan="1" align="right">설비코드&nbsp;</td>
								<td colspan="2" align="left"><input id="EQUIPMENT_INFO_CODE" type="text"
									style="width: 90%;" autocomplete="off" disabled="disabled">
								</td>
								<td colspan="1" align="right">설비명&nbsp;</td>
								<td colspan="2" align="left"><input id="EQUIPMENT_INFO_NAME" type="text"
									style="width: 90%;" autocomplete="off"
									onkeypress="javascript:if(event.keyCode==13) {EQUIPMENT_ITEM_CODE_SELECT()}">
								</td>
								<td colspan="1" align="right">불량수량&nbsp;</td>
								<td colspan="2" align="left"><input id="PRODUCTION_B_Qty" type="text"
									style="width: 90%;" autocomplete="off"></td>
								<td colspan="1" align="right">생산수량&nbsp;</td>
								<td colspan="2" align="left"><input id="PRODUCTION_VOLUME" type="text"
									style="width: 90%;" autocomplete="off" disabled="disabled"></td>
								<td colspan="1"></td>
								<td colspan="1"></td>
							</tr>
						</table>

						<table
							style="width: 100%; table-layout: fixed; margin-bottom: 5px; margin-top: 5px;">
							<tr>
								<td colspan="20" style="margin-left: 5px;">&nbsp;
									<%
									while(rs.next())
									{
										if(rs.getString("MENU_WRITE_USE_STATUS").equals("true"))
										{
									%>
									<button onclick="updateBtn()" type="button"
										style="font-size: 13px; width: 80px; font-family: 'Noto Sans KR', sans-serif;"
										class="btn btn-default btn-sm">
										<span class="glyphicon glyphicon-floppy-disk"
											ar-ia-hidden="true"></span> UPDATE
									</button>
									<%		
										}
										if(rs.getString("MENU_DEL_USE_STATUS").equals("true"))
										{
									%>
									<button onclick="deleteBtn()" type="button"
										style="font-size: 13px; width: 80px; font-family: 'Noto Sans KR', sans-serif;"
										class="btn btn-default btn-sm">
										<span class="glyphicon glyphicon-paste" aria-hidden="true"></span>
										DELETE
									</button>	
									<%
										}
										if(rs.getString("MENU_READ_USE_STATUS").equals("true"))
										{
									%>
									<button onclick="searchBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
										<span class="glyphicon glyphicon-search" aria-hidden="true"></span> SEARCH
									</button>
									<%
										}
									}
									%>
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
</body>
</html>
