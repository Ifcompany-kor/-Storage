<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>비지언스 MES</title>
        <link href="${contextPath}/resources/css/styles.css" rel="stylesheet" />
        <link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/js/all.min.js" crossorigin="anonymous"></script>
    	<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
    	
        <link href="https://unpkg.com/tabulator-tables@4.8.4/dist/css/tabulator.min.css" rel="stylesheet">
  		<script type="text/javascript" src="https://unpkg.com/tabulator-tables@4.8.4/dist/js/tabulator.min.js"></script>
  		<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script>
  		
  		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.5/jspdf.min.js"></script>
		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.0.5/jspdf.plugin.autotable.js"></script>
  		
	</head>
    <body class="sb-nav-fixed">
        <!-- sb topnave -->
        <jsp:include page="../sb-topnav.jsp"></jsp:include>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <jsp:include page="../layoutSidenav_nav.jsp"></jsp:include>
            </div>
            <div id="layoutSidenav_content">
                <main style="padding: 10px;">
                   	<table style="width:100%; border: solid 0.5px;">
                   		<tr>
                   			<td colspan="20" align="center">
		                		<font style="margin-left: 5px;" size="7px;" face="Noto Sans KR">발주서</font>
		                	</td>
                   		</tr>
                   		<tr height="50" style="">
                   			<td colspan="20" align="right" >
                   				<div style="width: 20%; height: 70px; margin-right: 10px;" align="right">
	                   					<table border="1" style="width: 100%; height: 100%;">
	                   						<tr align="center">
	                   							<td rowspan="2" width="10%;">
	                   								결제란
	                   							</td>
	                   							<td width="20%;" height="20%;" style="padding: 10px;">
	                   								
	                   							</td>
	                   							<td width="20%;" height="20%;" style="padding: 10px;">
	                   								
	                   							</td>
	                   							<td width="20%;" height="20%;" style="padding: 10px;">
	                   								
	                   							</td>
	                   							<td width="20%;" height="20%;" style="padding: 10px;">
	                   								
	                   							</td>
	                   						</tr>
	                   						<tr>
	                   							<td>
	                   								
	                   							</td>
	                   							<td>
	                   								
	                   							</td>
	                   							<td>
	                   								
	                   							</td>
	                   							<td>
	                   								
	                   							</td>
	                   						</tr>
	                   					</table>
                   				</div>
                   			</td>
                   		</tr>
                   		<tr>
                   			<td colspan="20" align="left">
                   				<font style="margin-left: 5px;" size="3px;" face="Noto Sans KR">▶ No.208978-20210122-01</font>
                   			</td>
                   		</tr>
                   		<tr height="50">
                   			<td colspan="10" style="border: solid 0.5px; width: 100%;">
                   				<div style="float: left; width: 50%;">
                   					<table border="1" style="width: 100%;">
	                   					<tr height="263">
	                   						<td style="padding: 20px; width: 95%;">
	                   							<font size="5px;" face="Noto Sans KR"><u>디이에프 주식 회사 귀중</u></font>
	                   							<br/><br/><br/>
	                   							<font size="2px;">참   조 : 홍길동 부장님</font>
	                   							<br/>
	                   							<font size="2px;">전화번호 : 02-123-4567</font>
	                   							<br/>
	                   							<font size="2px;">팩스번호 : 02-123-4568</font>
	                   							<br/>
	                   							<font size="2px;">견적일자 : 2012년 6월 16일(토)</font>
	                   							<br/><br/><br/>
	                   							<font size="5px;" face="Noto Sans KR">아래와 같이 발주합니다.</font>
	                   						</td>
	                   						<td style="padding: 10px;">
	                   							공<br/>
	                   							급<br/>
	                   							받<br/>
	                   							는<br/>
	                   							자
	                   						</td>
	                   					</tr>
                   					</table>
                   				</div>
                   				<div style="float: left;width: 50%;">
                   					<table border="1" style="width: 100%;">
	                   					<tr align="center" height="60">
	                   						<td colspan="1">
	                   						 	상호<br/>
	                   						 	(법인명)
	                   						</td>
	                   						<td colspan="3">
	                   							<input type="text" style="width: 100%; text-align: center; padding: 18px; font-size: 25px;" height="150">
	                   						</td>
	                   					</tr>
	                   					<tr align="center">
	                   						<td>
	                   						 	등록번호
	                   						</td>
	                   						<td>
	                   						 	<input type="text" style="width: 100%; text-align: center;">
	                   						</td>
	                   						<td>
	                   						 	성 명
	                   						</td>
	                   						<td>
	                   						 	<input type="text" style="width: 100%; text-align: center;">
	                   						</td>
	                   					</tr>
	                   					<tr align="center" height="80">
	                   						<td colspan="1">
	                   						 	사업장<br/>
	                   						 	주소
	                   						</td>
	                   						<td colspan="3">
	                   							<input type="text" style="width: 100%; text-align: center; padding: 18px; font-size: 25px;" height="150">
	                   						</td>
	                   					</tr>
	                   					<tr align="center">
	                   						<td>
	                   						 	업 태
	                   						</td>
	                   						<td>
	                   						 	<input type="text" style="width: 100%; text-align: center;">
	                   						</td>
	                   						<td>
	                   						 	종 목
	                   						</td>
	                   						<td>
	                   						 	<input type="text" style="width: 100%; text-align: center;">
	                   						</td>
	                   					</tr>
	                   					<tr align="center">
	                   						<td>
	                   						 	담당자
	                   						</td>
	                   						<td>
	                   						 	<input type="text" style="width: 100%; text-align: center;">
	                   						</td>
	                   						<td rowspan="2">
	                   						 	이메일
	                   						</td>
	                   						<td rowspan="2">
	                   						 	<input type="text" style="width: 100%; padding: 15px; text-align: center;">
	                   						</td>
	                   					</tr>
	                   					<tr align="center">
	                   						<td>
	                   						 	연락처
	                   						</td>
	                   						<td>
	                   						 	<input type="text" style="width: 100%; text-align: center;">
	                   						</td>
	                   					</tr>
                   					</table>
                   				</div>
                   			</td>
                   		</tr>
                   		<tr height="10">
                   			<td colspan="10" style="border: solid 0.5px; width: 100%;">
                   				<table border="1" style="width: 100%;">
	                   					<tr align="center">
	                   						<td style="width: 15%;">
	                   							<font size="4px;" face="Noto Sans KR">발주금액</font><br/>
	                   							(공급가액 + 세액)
	                   						</td>
	                   						<td style="width: 95%;">
	                   							<font size="4px;" face="Noto Sans KR">일금 육십육만원 정(￦660,000)</font>
	                   						</td>
	                   					</tr>
                   				</table>
                   			</td>
                   		</tr>
                   		<tr>
                   			<td>
	                   			<button onclick="addBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
	                                   	<span class="glyphicon glyphicon-floppy-save" aria-hidden="true"></span> SAVE
	                            </button>
	                            <button onclick="excelBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
	                                   	<span class="glyphicon glyphicon-print" aria-hidden="true"></span> PRINT
	                            </button>
                   			</td>
                   		</tr>
                   	</table>
                   	
                   	<div id="example-table"></div>
                   	
                   	<table style="width:100%; border: solid 0.5px;">
                   		<tr height="10">
                   			<td colspan="10" style="border: solid 0.5px; width: 100%;">
                   				<table border="1" style="width: 100%;">
	                   					<tr align="center">
	                   						<td style="width: 40%;">
	                   							<font size="4px;" face="Noto Sans KR">계</font>
	                   						</td>
	                   						<td style="width: 10%;">
	                   							<font size="4px;" face="Noto Sans KR">2</font>
	                   						</td>
	                   						<td style="width: 10%;">
	                   							<font size="4px;" face="Noto Sans KR"></font>
	                   						</td>
	                   						<td style="width: 20%;">
	                   							<font size="4px;" face="Noto Sans KR">￦600,000</font>
	                   						</td>
	                   						<td style="width: 20%;">
	                   							<font size="4px;" face="Noto Sans KR">￦660,000</font>
	                   						</td>
	                   					</tr>
                   				</table>
                   			</td>
                   		</tr>
                   		<tr height="10">
                   			<td colspan="10" style="border: solid 0.5px; width: 100%;">
                   				<table border="1" style="width: 100%;">
	                   					<tr>
	                   						<td style="width: 3%; text-align: center;">
	                   							<font size="4px;" face="Noto Sans KR">
	                   							참<br/>
	                   							고<br/>
	                   							사<br/>
	                   							항
	                   							</font>
	                   						</td>
	                   						<td style="width: 95%; padding-right: 5px;">
	                   							&nbsp;&nbsp;&nbsp;
	                   							<font size="3px;" face="Noto Sans KR">- 납  기  일  자 : </font>
	                   							<font size="3px;" face="Noto Sans KR" style="font-weight: bold;">2014년 6월 20일(수)</font><br/>
	                   							&nbsp;&nbsp;&nbsp;
	                   							<font size="3px;" face="Noto Sans KR">- 납  품  장 소 : </font>
	                   							<font size="3px;" face="Noto Sans KR" style="font-weight: bold;">(주)에이비씨 자재과</font><br/>
	                   							&nbsp;&nbsp;&nbsp;
	                   							<font size="3px;" face="Noto Sans KR">- 특 기 사 항 : </font>
	                   						</td>
	                   					</tr>
                   				</table>
                   			</td>
                   		</tr>
                   	</table>
                   	
                   	<script>
                   		var table = null; 
	                   	window.onload = function(){
	                   		/*
	                		var tabledata = [
	                			{id:'test1', name:"Oli Bob", email:"test55@naver.com", hobby:"test1", sex:"man",num:"010-1123-5971"}
	                		 ];
	                		
	                		for (var i = 0; i < 10000; i++) {
	                			tabledata.push({id:'test1', name:"Oli Bob", email:"test55@naver.com", hobby:"test1", sex:"man",num:"010-1123-5971"});
	        				}
	                		*/
	                		
	                   		var tabledata = [
	                			{id:'', name:"", email:"", hobby:"", sex:"",num:""}
	                		];
		                   	
	                		//create Tabulator on DOM element with id "example-table"
	                		table = new Tabulator("#example-table", {
	                			height:500, // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
	                		 	data:tabledata, //assign data to table
	                		 	layout:"fitColumns", //fit columns to width of table (optional)
	                		 	columns:[ //Define Table Columns
	                			 	{title:"순번", field:"id", width:80,editor:"input", 
	                			 		cellEdited:function(cell){
		                			        //e - the click event object
		                			        //cell - cell component
	                			        	//console.log(cell);
		                			    },
		                			},
	                			 	{title:"시리얼넘버", field:"name", width:120,editor:"input"},
	                			 	{title:"제품코드", field:"email", width:90,editor:"input"},
	                			 	{title:"수량", field:"hobby", width:80,editor:"input"},
	                			 	{title:"입고 거래처 코드", field:"sex", width:140,editor:"input"},
	                			 	{title:"입고일", field:"num", width:80,editor:"input"},
	                			 	{title:"데이터 삽입 시간", field:"num", width:140,editor:"input"},
	                			 	{title:"작업자명", field:"num", width:100,editor:"input"}
	                		 	]
	                		});
	                	}
	                   	
	                   	function addBtn(){
	                   		//table.download("xlsx", "data.xlsx", {sheetName:"MyData"}); //download a xlsx file that has a sheet name of "MyData"
	                   	}
	                   	
	                   	function excelBtn(){
	                   		window.print();
	                   		
	                   		//table.download("xlsx", "data.xlsx", {sheetName:"MyData"}); //download a xlsx file that has a sheet name of "MyData"
	                   		/*
	                   		table.download("pdf", "data.pdf", {
	                   	        orientation:"portrait", //set page orientation to portrait
	                   	        title:"Example Report", //add title to report
	                   	    });
	                   		*/
	                   		
	                   		/*
	                   		var tab_text = 'Hello <br/> OK';
	                   		
	                   		var blob = new Blob([tab_text], {
	                   			type: "application/csv;charset=utf-8;"
	                   		});

	                   		var elem = window.document.createElement('a');
	                   		elem.href = window.URL.createObjectURL(blob);
	                   		elem.download = "file1.xls";
							
	                   		elem.click();
	                   		*/
	                   	}
					</script>
                </main>
            </div>
        </div>
        <!-- This is the localization file of the grid controlling messages, labels, etc.
       	<!-- A link to a jQuery UI ThemeRoller theme, more than 22 built-in and many more custom -->
      	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"> 
        
        <link rel="preconnect" href="https://fonts.gstatic.com">
      	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400&display=swap" rel="stylesheet">        
         
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="${contextPath}/resources/js/scripts.js"></script>
    </body>
</html>
