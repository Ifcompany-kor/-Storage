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
        <meta name="viewport" content="width=device-width, initial-scale=0.8, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <link href="${contextPath}/resources/css/styles.css" rel="stylesheet" />
        <link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/js/all.min.js" crossorigin="anonymous"></script>
        <title>Xeonic - Mes App</title>
        <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
        <link href="https://unpkg.com/tabulator-tables@4.8.4/dist/css/tabulator.min.css" rel="stylesheet">
  		<script type="text/javascript" src="https://unpkg.com/tabulator-tables@4.8.4/dist/js/tabulator.min.js"></script>
    	<script type="text/javascript" src="https://momentjs.com/downloads/moment.js"></script>
    
    	<script type="text/javascript">
    		var datas = "";
    		PRODUCT_ITEM_NAME_Index = 0;
    		PRODUCT_ITEM_NAME_Value = "";
    	
    		insertFlag = false;
    		
    		var dataList = {
    			"data": []
    		}	
    		
    		function saveBtn() {
    			//BUSINESS_PLACE_CODE
    			BUSINESS_PLACE_CODE = document.getElementById("BUSINESS_PLACE_CODE");
    			BUSINESS_PLACE_CODE_INDEX = BUSINESS_PLACE_CODE.selectedIndex;
    			MOLD_USE_STATUS = null;
    			
    			//MOLD_USE_STATUS
    			var check_count = document.getElementsByName("MOLD_USE_STATUS").length;
    			for (var i=0; i<check_count; i++) {
    	            if (document.getElementsByName("MOLD_USE_STATUS")[i].checked == true) {
    	                MOLD_USE_STATUS = document.getElementsByName("MOLD_USE_STATUS")[i].value;
    	            }
    	        }
    			
    			MOLD_RECEIVED_D = document.getElementById("MOLD_RECEIVED_D").value;
    			MOLD_INFO_NO = document.getElementById("MOLD_INFO_NO").value;
    			
    			if(MOLD_INFO_NO.length <= 0)
    			{
    				alert("금형관리코드는 반드시 입력되어야 합니다.");
    				document.getElementById("MOLD_INFO_NO").focus();
    				return;
    			}
    			if(MOLD_INFO_NO.length > 10)
    			{
    				alert("금형관리코드는 10글자 이하로 입력되어야 합니다.");
    				return;
    			}
    			
    			MOLD_INFO_RANK = document.getElementById("MOLD_INFO_RANK");
    			MOLD_INFO_RANK_INDEX = MOLD_INFO_RANK.selectedIndex;
    			
    			//document.getElementById("MOLD_INFO_STND").value;
    			
    			MOLD_ITEM_CODE = document.getElementById("PRODUCT_ITEM_CODE").value;
    			if(MOLD_ITEM_CODE.length <= 0)
    			{
    				alert("품목코드는 반드시 입력되어야 합니다.\n품목명으로 검색하여 입력해주십시오.");
    				document.getElementById("PRODUCT_ITEM_NAME").focus();
    				return;
    			}
    			
    			json = {};
    			json.BUSINESS_PLACE_CODE = BUSINESS_PLACE_CODE.selectedIndex+1;
    			json.MOLD_USE_STATUS = MOLD_USE_STATUS;
    			json.MOLD_RECEIVED_D = MOLD_RECEIVED_D;
    			json.MOLD_INFO_NO = MOLD_INFO_NO;
    			json.MOLD_INFO_NAME = document.getElementById("MOLD_INFO_NAME").value;
    			json.MOLD_INFO_RANK = MOLD_INFO_RANK_INDEX+1;
    			json.MOLD_INFO_STND = document.getElementById("MOLD_INFO_STND").value;
    			json.MOLD_ITEM_CODE = MOLD_ITEM_CODE;
    			json.MANUFACTURER = document.getElementById("MANUFACTURER").value;
    			json.BUSINESS_PERSON = document.getElementById("BUSINESS_PERSON").value;
    			json.USER_MODIFIER = <%=Sel%>;
    			//alert(JSON.stringify(json));
    			
    			/* hiddenInput("moldFrm","data",JSON.stringify(json));
    			frmSubmit("moldFrm","post","insert"); */
    			
    			$.ajax({
    		        method: "POST",
    		        data : json,
    		        url: "${contextPath}/moldRest/insert.do?data="+JSON.stringify(json),
    		        success: function (data) {
    		        	if(data=="Overlap")
    		        		alert("중복코드를 입력하셨습니다. 다른 코드를 입력해주세요.");
    		        	else if(data=="Success")
    		        	{
    		        		alert("저장 완료 하였습니다.");
    						
    						location.reload();
    		        	}
    		        },
    		        complete: function (data,textStatus) {
    		        	//console.log(data);
    		        	//self.close();   //자기자신창을 닫습니다.
    		        } 
    		    }); 
			}
    		
    		function resetBtn() {
				location.reload();
			}
    		
    		function updateBtn() {
    			if(!DataCheck("행을 체크 후에 수정을 진행하여 주십시오.","수정 하시겠습니까?"))
    				return;
    			
    			alert("수정 완료 하였습니다.");
    			
    			hiddenInput("moldFrm","modifier",<%=Sel%>);
    			hiddenInput("moldFrm","dataList",JSON.stringify(dataList));
    			frmSubmit("moldFrm","post","mold/update");
			}
    		
    		function deleteBtn() {
    			if(!DataCheck("행을 체크 후에 삭제을 진행하여 주십시오.","삭제 하시겠습니까?"))
    				return;
    			
    			alert("삭제 완료 하였습니다.");
    			
    			hiddenInput("moldFrm","dataList",JSON.stringify(dataList));
    			frmSubmit("moldFrm","post","mold/delete");
			}
    		
    		function DataCheck(message1,message2) {
    			if(dataList.data.length == 0)
				{
					alert(message1);
					return false;
				}
    			
    			conf = confirm(message2);
				return conf;
			}
    		
    		function frmSubmit(frmid, method, action) {
    			frm = document.getElementById(frmid);
    			frm.method = method;
    			frm.action = action;
    			frm.submit();
    		}
    		
    		function hiddenInput(frmid, name, value) {
    			frm = document.getElementById(frmid);
    			var hidden = document.createElement("input");
    			hidden.setAttribute("type", "hidden");
    			hidden.setAttribute("name", name);
    			hidden.setAttribute("value", value);
    			frm.appendChild(hidden);
    		}
    		
    		function PRODUCT_ITEM_CODE_SELECT() {
    			localStorage.setItem('PRODUCT_ITEM_NAME', document.getElementById("PRODUCT_ITEM_NAME").value);
				var url = "${contextPath}/mold/mold_ItemCode";
	            var name = "MOLD_ITEM_CODE";
	            var option = "width = 500, height = 500, top = 100, left = 200, location = no"
	            openWin = window.open(url, name, option);
			}
    		
    		function PRODUCT_ITEM_ROW_SELECT(value1,value2) {
    			datas[PRODUCT_ITEM_NAME_Index].mold_ITEM_CODE=value1;
    			datas[PRODUCT_ITEM_NAME_Index].mold_ITEM_NAME=value2;
    			//console.log(datas[PRODUCT_ITEM_NAME_Index].mold_ITEM_NAME);
    			//datas[PRODUCT_ITEM_NAME_Index].mold_ITEM_NAME=value2;
		        table.setData(datas);
			}
    	</script>
    </head>
    <body class="sb-nav-fixed" style="overflow:hidden;">
        <!- sb topnave -->
        <jsp:include page="../sb-topnav.jsp"></jsp:include>
        
        <form id="moldFrm"></form>
        <div id="layoutSidenav">
        	<!-- layoutSidenav_nav -->
            <jsp:include page="../layoutSidenav_nav.jsp"></jsp:include>
            <div id="layoutSidenav_content">
                	<div style="overflow:hidden; width:100%; height: 100%; padding-left: 70px;">
                	  <div style="width:100%; float: none; margin-top: 5px;padding-bottom:5px;">
                			<div style="width:100%;background: #F2F2F2; border-collapse: separate; border-spacing: 0 2px; border: solid 0.5px;">
                				<table style="width:100%;table-layout: fixed;">
		                			<tr>
		                				<td colspan="20" >
		                					<font style="margin-left: 5px;" size="5px;" face="Noto Sans KR">금형 정보 관리</font>
		                				</td>
		                			</tr> 
                				</table>
                				
                				<table id="inserFrm" style="width:100%;table-layout: fixed;border-collapse: separate; border-spacing: 0 2px;" >
		                			<tr>
		                				<td colspan="6">
		                				</td>
		                				<td colspan="14">
		                					<font size="5px;" face="Noto Sans KR"></font>
		                				</td>
		                			</tr> 
		                			<tr>
			                			<td colspan="1">
			                					
			                			</td>
			                			<td colspan="2" align="right" style="color: red;">
			                				사업장&nbsp;
			                			</td>
			                			<td colspan="2" align="left">
			                				<select id="BUSINESS_PLACE_CODE" style="width: 100%;">
			                					<c:forEach var="data" items="${BUSINESS_PLACE_CODE_LIST}">
			                						<option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
			                					</c:forEach>
			                				</select>
			                			</td>
			                			<td colspan="2" align="right">
		                					사용유무&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input type="radio" name="MOLD_USE_STATUS" value="true" checked="checked">사용
											<input type="radio" name="MOLD_USE_STATUS" value="false">미사용
		                				</td>
		                				<td colspan="1">
		                					
		                				</td>
		                				<td colspan="2" align="right" >
		                					입고일&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="MOLD_RECEIVED_D" type="date" style="width: 100%;" autocomplete="off">
		                				</td>
		                			</tr>
		                			<tr>
		                				<td colspan="1">
		                					
		                				</td>
		                				<td colspan="2" align="right" style="color: red;" >
		                					금형관리코드&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="MOLD_INFO_NO" type="text" style="width: 100%;" autocomplete="off" 
		                					onkeypress="javascript:if(event.keyCode==13) {document.getElementById('MOLD_INFO_NAME').focus()}">
		                				</td>
		                				<td colspan="1" align="right" >
		                					금형명&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="MOLD_INFO_NAME" type="text" style="width: 100%;" autocomplete="off"
		                					onkeypress="javascript:if(event.keyCode==13) {document.getElementById('MOLD_INFO_STND').focus()}">
		                				</td>
		                				<td colspan="1" align="right" >
		                					차수&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<select id="MOLD_INFO_RANK" style="width: 100%;">
		                						<c:forEach var="data" items="${MOLD_INFO_RANK_LIST}">
		                							<option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
		                						</c:forEach>
		                					</select>
		                				</td>
		                				<td colspan="1" align="right" >
		                					규격&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="MOLD_INFO_STND" type="text" style="width: 100%;" autocomplete="off"
		                					onkeypress="javascript:if(event.keyCode==13) {document.getElementById('PRODUCT_ITEM_NAME').focus()}">
		                				</td>
		                			</tr>
		                			<tr>
		                				<td colspan="1">
		                					
		                				</td>
		                				<td colspan="2" align="right" style="color: red;">
		                					품목코드&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="PRODUCT_ITEM_CODE" type="text" style="width: 100%;" autocomplete="off" disabled>
		                				</td>
		                				<td colspan="1" align="right" >
		                					품목명&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="PRODUCT_ITEM_NAME" type="text" style="width: 100%;" autocomplete="off"
		                						onkeypress="javascript:if(event.keyCode==13) {PRODUCT_ITEM_CODE_SELECT()}"
		                					>
		                				</td>
		                				<td colspan="1" align="right" >
		                					제작업체&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="MANUFACTURER" type="text" style="width: 100%;" autocomplete="off"
		                					onkeypress="javascript:if(event.keyCode==13) {document.getElementById('BUSINESS_PERSON').focus()}">
		                				</td>
		                				<td colspan="1" align="right" >
		                					업체담당자&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="BUSINESS_PERSON" type="text" style="width: 100%;" autocomplete="off">
		                				</td>
		                			</tr>
		                			<tr>
		                				<td colspan="18" style="margin-left: 5px;" align="right">
		                					
		                				</td>
		                			</tr>
                				</table>
                				
                				<table style="width:100%;table-layout: fixed; margin-bottom: 5px; margin-top: 5px;">
		                			<tr> 
		                				<td colspan="20" style="margin-left: 5px;">&nbsp;
		                					<button onclick="saveBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
											  <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> SAVE
											</button>
											<button onclick="updateBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
											  <span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> UPDATE
											</button>
				                			<button onclick="deleteBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
											  <span class="glyphicon glyphicon-paste" aria-hidden="true"></span> DELETE
											</button>
											<button onclick="resetBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
											  <span class="glyphicon glyphicon-refresh" aria-hidden="true"></span> RESET
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
        	var table = null;
		    window.onload = function() {
		    	//Create Date Editor
		    	var dateEditor = function(cell, onRendered, success, cancel){
		    	    //cell - the cell component for the editable cell
		    	    //onRendered - function to call when the editor has been rendered
		    	    //success - function to call to pass the successfuly updated value to Tabulator
		    	    //cancel - function to call to abort the edit and return to a normal cell

		    	    //create and style input
		    	    var cellValue = moment(cell.getValue(), "DD/MM/YYYY").format("YYYY-MM-DD"),
		    	    input = document.createElement("input");

		    	    input.setAttribute("type", "date");

		    	    input.style.padding = "4px";
		    	    input.style.width = "100%";
		    	    input.style.boxSizing = "border-box";

		    	    input.value = cellValue;

		    	    onRendered(function(){
		    	        input.focus();
		    	        input.style.height = "100%";
		    	    });

		    	    function onChange(){
		    	        if(input.value != cellValue){
		    	            success(moment(input.value, "YYYY-MM-DD").format("YYYY/MM/DD"));
		    	        }else{
		    	            cancel();
		    	        }
		    	    }

		    	    //submit new value on blur or change
		    	    input.addEventListener("blur", onChange);

		    	    //submit new value on enter
		    	    input.addEventListener("keydown", function(e){
		    	        if(e.keyCode == 13){
		    	            onChange();
		    	        }

		    	        if(e.keyCode == 27){
		    	            cancel();
		    	        }
		    	    });

		    	    return input;
		    	};
		    	
		    	var inputCustom = function(cell, onRendered, success, cancel){
		    	    input = document.createElement("input");

		    	    input.setAttribute("type", "text");

		    	    input.style.padding = "4px";
		    	    input.style.width = "100%";
		    	    input.style.boxSizing = "border-box";

		    	    //submit new value on enter
		    	    input.addEventListener("keydown", function(e){
		    	        if(e.keyCode == 13){
		    	        	console.log(PRODUCT_ITEM_NAME_Index);
		    	        	console.log(cell);
		    	        	
		    	        	console.log(table[1]);
		    	        }
		    	    });

		    	    return input;
		    	};
		    	
		    	insertFlag = false;
		    	var initflag = true;
			     $.ajax({
		                method: "GET",
		                url: "${contextPath}/moldRest/view.do",
		                success: function (data) {
		                	datas = data;
		                	
		        		    table = new Tabulator("#example-table", { 
		        		        rowSelectionChanged:function(data, rows){
		        		            dataList.data = data;
		        		        },
		        		        rowDblClick:function(e, row){
		        		            //e - the click event object
		        		            //row - row component
		        		            //console.log(row.getIndex());
		        		            //console.log(row.getData().id);
		        		            
		        		        	PRODUCT_ITEM_NAME_Index = row.getIndex();
		        		    		PRODUCT_ITEM_NAME_Value = "";
		        		        },
		        		        rowUpdated:function(row){
		        		            alert("수정");
		        		        },
		        		    	height:"600px",
		        		     	data:datas, 
		        		     	columns:[ 
		        		     	{title:"", field:"id", hozAlign:"center"},
		        		     	{formatter:"rowSelection"},
		        		     	{title:"사업장", field:"business_PLACE_CODE",headerFilter:true, headerFilterParams:{values:{${BUSINESS_PLACE_CODE_LIST_Output}}}, editor:"select", editorParams:{values:{${BUSINESS_PLACE_CODE_LIST_Output}}}},
		        		     	{title:"금형관리No", field:"mold_INFO_NO", width:120,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"금형명", field:"mold_INFO_NAME", width:200,headerHozAlign:"center", headerFilter:"input", editor:"input"},
		        		     	{title:"차수", field:"mold_INFO_RANK",headerFilter:true,width:100, headerFilterParams:{values:{${MOLD_INFO_RANK_LIST_Output}}}, editor:"select", editorParams:{values:{${MOLD_INFO_RANK_LIST_Output}}}},
		        		     	{title:"규격", field:"mold_INFO_STND", width:100,headerHozAlign:"center", headerFilter:"input", editor:"input"},
		        		     	{title:"품목코드", field:"mold_ITEM_CODE", width:100,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"품목명", field:"mold_ITEM_NAME", width:200,headerHozAlign:"center", headerFilter:"input", editor:"input",
		        		     		cellEdited:function(cell){
		        		            //cell - cell component
		        		            //console.log(cell.getData());
		        		            //console.log(cell.getData().id);
		        		            //console.log(cell.getData().mold_ITEM_NAME);
		        		            //console.log(datas[cell.getData().id-1]);
		        		            PRODUCT_ITEM_NAME_Index = cell.getData().id-1;
		        		            //datas[cell.getData().id-1].mold_ITEM_CODE="수정중"
		        		            //table.setData(datas);
		        		            
		        		            localStorage.setItem('PRODUCT_ITEM_NAME', cell.getData().mold_ITEM_NAME);
		        					var url = "${contextPath}/mold/mold_ItemCode2";
		        		            var name = "MOLD_ITEM_CODE";
		        		            var option = "width = 500, height = 500, top = 100, left = 200, location = no"
		        		            openWin = window.open(url, name, option);
		        		        }},
		        		     	{title:"제작업체", field:"manufacturer", width:100,headerHozAlign:"center", headerFilter:"input", editor:"input"},
		        		     	{title:"업체담당자", field:"business_PERSON", width:100,headerHozAlign:"center", headerFilter:"input", editor:"input"},
		        		     	{title:"입고일", field:"mold_RECEIVED_D",editor:dateEditor,width:135,headerHozAlign:"center",hozAlign:"right",sorter:"date",  headerFilter:"input"},
		        		     	{title:"사용유무", field:"mold_USE_STATUS", width:100,headerHozAlign:"center",hozAlign:"center", formatter:"tickCross",editor:"select", editorParams:{values:{"true":"사용", "false":"미사용"}}, headerFilter:true, headerFilterParams:{values:{"true":"사용", "false":"미사용"}}},
		        		    	{title:"수정일자", field:"user_MODIFY_D", width:150,headerHozAlign:"center",hozAlign:"right",sorter:"date",  headerFilter:"input"},
		        		    	{title:"수정자", field:"user_MODIFIER", width:150,headerHozAlign:"center", headerFilter:"input"}
		        		     	],
		        		    });
		                }
		        });
			     
		    }
	  	</script>
        
	    <!-- This is the localization file of the grid controlling messages, labels, etc.
	    <!-- A link to a jQuery UI ThemeRoller theme, more than 22 built-in and many more custom -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"> 
        
        <link rel="preconnect" href="https://fonts.gstatic.com">
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400&display=swap" rel="stylesheet">        
         
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="${contextPath}/resources/js/scripts.js"></script>
    </body>
</html>
