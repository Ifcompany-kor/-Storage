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
   rd.forward(request, response);
   return;
}
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Xeonic - Mes App</title>
        <link href="${contextPath}/resources/css/styles.css" rel="stylesheet" />
        <link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/js/all.min.js" crossorigin="anonymous"></script>
        <link href="https://unpkg.com/tabulator-tables@4.8.4/dist/css/tabulator.min.css" rel="stylesheet">
  		<script type="text/javascript" src="https://unpkg.com/tabulator-tables@4.8.4/dist/js/tabulator.min.js"></script>
    	<script type="text/javascript" src="https://momentjs.com/downloads/moment.js"></script>
    	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    </head>
    <body class="sb-nav-fixed">
        <!-- sb topnave -->
        <jsp:include page="../sb-topnav.jsp"></jsp:include>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <!-- layoutSidenav_nav -->
            	<jsp:include page="../layoutSidenav_nav.jsp"></jsp:include>
            </div>
            <div id="layoutSidenav_content">
                <main>
                    <div class="container-fluid">
                        <h1 class="mt-4">생산현황 모니터링</h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item active" id="today">Today</li>
                        </ol>
                        <div class="row">
                            <div class="col-xl-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <i class="fas fa-chart-area mr-1"></i>
                                        1호기
                                    </div>
                                    <div class="card-body">
                                    	<div id="example-table1"></div>
                                    	<table style="width: 100%;">
                                    		<tr>
                                    			<td style="width: 40%;" align="right">
                                    				모델명&nbsp;&nbsp;&nbsp;
                                    			</td>
                                    			<td style="width: 60%;">
                                    				<input type="text" id="product_ITEM_NAME" readonly>
                                    			</td>
                                    		</tr>
                                    		<tr>
                                    			<td style="width: 40%;" align="right">
                                    				시작 시간&nbsp;&nbsp;&nbsp;
                                    			</td>
                                    			<td style="width: 60%;">
                                    				<input type="text" id="production_MODIFY_D" readonly>
                                    			</td>
                                    		</tr>
                                    		<tr>
                                    			<td style="width: 40%;" align="right">
                                    				생산 수량&nbsp;&nbsp;&nbsp;
                                    			</td>
                                    			<td style="width: 60%;">
                                    				<input type="text" id="production_VOLUME" readonly>
                                    			</td>
                                    		</tr>
                                    		<tr>
                                    			<td style="width: 40%;" align="right">
                                    				불량&nbsp;&nbsp;&nbsp;
                                    			</td>
                                    			<td style="width: 60%;">
                                    				<input type="text" id="production_DEFECT_CODE" readonly>
                                    			</td>
                                    		</tr>
                                    	</table>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <i class="fas fa-chart-bar mr-1"></i>
                                        2호기
                                    </div>
                                    <div class="card-body">
                                    	<div id="example-table2"></div>
                                    	<table style="width: 100%;">
                                    		<tr>
                                    			<td style="width: 40%;" align="right">
                                    				모델명&nbsp;&nbsp;&nbsp;
                                    			</td>
                                    			<td style="width: 60%;">
                                    				<input type="text" id="product_ITEM_NAME2" readonly>
                                    			</td>
                                    		</tr>
                                    		<tr>
                                    			<td style="width: 40%;" align="right">
                                    				시작 시간&nbsp;&nbsp;&nbsp;
                                    			</td>
                                    			<td style="width: 60%;">
                                    				<input type="text" id="production_MODIFY_D2" readonly>
                                    			</td>
                                    		</tr>
                                    		<tr>
                                    			<td style="width: 40%;" align="right">
                                    				생산 수량&nbsp;&nbsp;&nbsp;
                                    			</td>
                                    			<td style="width: 60%;">
                                    				<input type="text" id="production_VOLUME2" readonly>
                                    			</td>
                                    		</tr>
                                    		<tr>
                                    			<td style="width: 40%;" align="right">
                                    				불량&nbsp;&nbsp;&nbsp;
                                    			</td>
                                    			<td style="width: 60%;">
                                    				<input type="text" id="production_DEFECT_CODE2" readonly>
                                    			</td>
                                    		</tr>
                                    	</table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        
        <script>
        	function tableInit1() {
        		$.ajax({
                    method: "GET",
                    url: "${contextPath}/productionrest/unit1",
                    success: function (data) {
                    	datas = data;
                    	console.log(datas);
                    	
                    	var table = new Tabulator("#example-table1", {
        				    layout:"fitColumns",
        				    data:datas,
        				    pagination:"local",
        				    responsiveLayout:"hide",
        				    paginationSize:6,
        				    paginationSizeSelector:[3, 6, 8, 10],
        				    movableColumns:true,
        				    rowFormatter:function(row){
        				        //row - row component

        				        var data = row.getData();
        				        
        				        if(data.time != undefined)
        				        {
        				        	var timeset = data.time;
        				        	var starttime = timeset.substring(0,2);
        				        	starttime += ":";
        				        	var endtime = timeset.substring(2,4);
        				        	starttime += endtime;
        				        	
        				        	data.time = starttime;
        				        }
        				    },
        				    
        				    columns:[
        				    	{title:"시간", field:"time",headerHozAlign:"center",hozAlign:"right",minWidth:60},
        				        {title:"모델명", field:"product_ITEM_NAME",headerHozAlign:"center",minWidth:130},
        				        {title:"생산수량", field:"production_VOLUME",bottomCalc:"sum",headerHozAlign:"center",hozAlign:"right"},
        				        {title:"불량수량", field:"production_DEFECT_CODE",bottomCalc:"sum",headerHozAlign:"center",hozAlign:"right"},
        				        {title:"양품수량", field:"quantity_GOODS",bottomCalc:"sum",headerHozAlign:"center",hozAlign:"right"},
        				    ],
        				});
                    }
            	});
			}
        	
        	function out1() {
        		$.ajax({
                    method: "GET",
                    url: "${contextPath}/productionrest/out1",
                    success: function (data) {
                    	datas = data;
                    	console.log(datas);
                    	
                    	document.getElementById("product_ITEM_NAME").value = datas.product_ITEM_NAME;
                    	document.getElementById("production_MODIFY_D").value = datas.production_MODIFY_D;
                    	document.getElementById("production_VOLUME").value = datas.production_VOLUME;
                    	document.getElementById("production_DEFECT_CODE").value = datas.production_DEFECT_CODE;
                    }
            	});
			}
        	
        	function out2() {
        		$.ajax({
                    method: "GET",
                    url: "${contextPath}/productionrest/out2",
                    success: function (data) {
                    	datas = data;
                    	console.log(datas);
                    	console.log(datas.product_ITEM_NAME);
                    	document.getElementById("product_ITEM_NAME2").value = datas.product_ITEM_NAME;
                    	document.getElementById("production_MODIFY_D2").value = datas.production_MODIFY_D;
                    	document.getElementById("production_VOLUME2").value = datas.production_VOLUME;
                    	document.getElementById("production_DEFECT_CODE2").value = datas.production_DEFECT_CODE;
                    }
            	});
			}
        	
        	function tableInit2() {
        		$.ajax({
                    method: "GET",
                    url: "${contextPath}/productionrest/unit2",
                    success: function (data) {
                    	datas = data;
                    	console.log(datas);
                    	
                    	var table = new Tabulator("#example-table2", {
        				    layout:"fitColumns",
        				    data:datas,
        				    pagination:"local",
        				    paginationSize:6,
        				    paginationSizeSelector:[3, 6, 8, 10],
        				    movableColumns:true,
        				    responsiveLayout:"hide",
        				    
        				    columns:[
        				    	{title:"시간", field:"time",headerHozAlign:"center",hozAlign:"right",minWidth:60},
        				        {title:"모델명", field:"product_ITEM_NAME",minWidth : 130,headerHozAlign:"center",minWidth:130},
        				        {title:"생산수량", field:"production_VOLUME",bottomCalc:"sum",headerHozAlign:"center",hozAlign:"right"},
        				        {title:"불량수량", field:"production_DEFECT_CODE",bottomCalc:"sum",headerHozAlign:"center",hozAlign:"right"},
        				        {title:"양품수량", field:"quantity_GOODS",bottomCalc:"sum",headerHozAlign:"center",hozAlign:"right"},
        				    ],
        				});
                    }
            	});
			}
        
        	window.onload = function() {
        		//startDate
		    	var date = new Date(); 
		    	var year = date.getFullYear(); 
		    	var month = new String(date.getMonth()+1); 
		    	var day = new String(date.getDate()); 

		    	// 한자리수일 경우 0을 채워준다. 
		    	if(month.length == 1){ 
		    	  month = "0" + month; 
		    	} 
		    	if(day.length == 1){ 
		    	  day = "0" + day; 
		    	}
        		
        		document.getElementById("today").innerText = year + "-" + month + "-" + day;
			}
        	
        	tableInit1();tableInit2();out1();out2();
        	
        	setTimeout(function() {
        		location.reload();
        	}, 300000);
        </script>
        
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="${contextPath}/resources/js/scripts.js"></script>
        <script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
        <script src="${contextPath}/resources/assets/demo/datatables-demo.js"></script>
    </body>
</html>
