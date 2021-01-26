<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
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
			+ "            and CHILD_TBL_TYPE = '금형 정보 관리'\r\n"
			+ "        ) t2\r\n"
			+ "on t1.MENU_PROGRAM_CODE = t2.CHILD_TBL_NUM order by MENU_PROGRAM_CODE+0\r\n";
  
  //System.out.println(sql);
	
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
    	<script type="text/javascript" src="https://momentjs.com/downloads/moment.js"></script>
    
    	<script type="text/javascript">
    		var datas = "";
    		PRODUCT_ITEM_NAME_Index = 0;
    		PRODUCT_ITEM_NAME_Value = "";
    		
    		var resultFlag = "None";  
    	
    		function saveBtn() {
    			if(resultFlag == "None"){
    				alert("행을 선택한 후에 저장 버튼을 눌러주십시오.");
   	             return;
    			}else if(resultFlag=="New")
    			{
    				conf = confirm("저장 하시겠습니까?");
        			if(!conf)
        				return;
    				
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
        			json.MOLD_CUBIT = document.getElementById("MOLD_CUBIT").value;
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
        		        url: "${contextPath}/moldRest/insert.do?data="+encodeURI(JSON.stringify(json)),
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
    			else if(resultFlag=="Changed")  {
    		         conf =  confirm("수정 하시겠습니까?");
    		         if(!conf)
    		            return;
    		         
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
         			json.MOLD_CUBIT = document.getElementById("MOLD_CUBIT").value;
         			json.MOLD_ITEM_CODE = MOLD_ITEM_CODE;
         			json.MANUFACTURER = document.getElementById("MANUFACTURER").value;
         			json.BUSINESS_PERSON = document.getElementById("BUSINESS_PERSON").value;
         			json.USER_MODIFIER = <%=Sel%>;
    		         
    		        $.ajax({
    		                     method: "POST",
    		                     data : null,
    		                     url: "${contextPath}/mold/update2?dataList="+encodeURI(JSON.stringify(json))+"",
    		                     success: function (data,testStatus) {
    		                     console.log(data);
    		                     alert("수정 성공 하였습니다.");
    		                     resetBtn();
    		            }
    		       });
    		    }
			}
    		
    		function resetBtn() {
				location.reload();
			}
    		
    		function newBtn() {
    			resultFlag = "New";
    			document.getElementById("MOLD_INFO_NO").removeAttribute('disabled');
    			document.getElementById("MOLD_INFO_NO").value = "";
    			document.getElementById("MOLD_CUBIT").value = "";
    			document.getElementById("MOLD_RECEIVED_D").value = "";
    			document.getElementById("MOLD_INFO_NAME").value = "";
    			document.getElementById("MOLD_INFO_STND").value = "";
    			document.getElementById("PRODUCT_ITEM_CODE").value = "";
    			document.getElementById("PRODUCT_ITEM_NAME").value = "";
    			document.getElementById("MANUFACTURER").value = "";
    			document.getElementById("BUSINESS_PERSON").value = "";
    			document.getElementById("MOLD_INFO_NO").focus();
    			document.getElementById("BUSINESS_PLACE_CODE").children[0].setAttribute('selected', '');
    			document.getElementById("MOLD_INFO_RANK").children[0].setAttribute('selected', '');
    			document.getElementsByName("MOLD_USE_STATUS")[0].checked = true;
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
    			if (resultFlag!="Changed")
	  	          {
	  	             alert("행을 선택한 후에 삭제 버튼을 눌러주십시오.");
	  	             return;
	  	          }
	  	          conf =  confirm("삭제 하시겠습니까?");
  	         	if(!conf)
  	            	return;
  	                 
  	           $.ajax({
  	              method: "POST",
  	              data : null,
  	              url: "${contextPath}/moldRest/delete2.do?MOLD_INFO_NO='"+document.getElementById("MOLD_INFO_NO").value+"'",
  	              success: function (data,testStatus) {
  	            	console.log(data);
  					if(data == "error"){
  					    alert("사용하고 있는 데이터는 삭제할 수 없습니다.");
  					}else{
  					 alert("삭제 성공 하였습니다.");
  					}
  					   resetBtn();
  	                }
  	           });
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
                	<div style="overflow:hidden; width:100%; height: 100%; padding-left: 10px; padding-right: 10px;">
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
			                			<td colspan="4">
			                					
			                			</td>
			                			<td colspan="2" align="right" style="color: red;">
			                				사업장&nbsp;
			                			</td>
			                			<td colspan="2" align="left">
			                				<select id="BUSINESS_PLACE_CODE" style="width: 100%;height: 27px;">
			                					<c:forEach var="data" items="${BUSINESS_PLACE_CODE_LIST}">
			                						<option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
			                					</c:forEach>
			                				</select>
			                			</td>
			                			<td colspan="1" align="right">
		                					사용유무&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input type="radio" name="MOLD_USE_STATUS" value="true" checked="checked">사용
											<input type="radio" name="MOLD_USE_STATUS" value="false">미사용
		                				</td>
		                				<td colspan="1" align="right">
		                					케비트&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="MOLD_CUBIT" type="number" style="width: 100%;" autocomplete="off" min="1">
		                				</td>
		                				<td colspan="1" align="right" >
		                					입고일&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="MOLD_RECEIVED_D" type="date" style="width: 100%; height: 27px;" autocomplete="off">
		                				</td>
		                			</tr>
		                			<tr>
		                				<td colspan="4">
		                					
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
		                					<select id="MOLD_INFO_RANK" style="width: 100%;height: 27px;">
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
		                				<td colspan="4">
		                					
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
		                					담당자&nbsp;
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
		                					<button onclick="newBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
		                                   		<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span> NEW
		                                    </button>
		                					<%
			                                   while(rs.next())
			                                   {
			                                	   if(rs.getString("MENU_WRITE_USE_STATUS").trim().equals("true"))
			                                	   {
			                                   %>
			                                   <button onclick="saveBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
			                                   	<span class="glyphicon glyphicon-floppy-disk" ar-ia-hidden="true"></span> SAVE
			                                   </button>
			                                   <%
			                                	   }
			                                	   //MENU_DEL_USE_STATUS
			                                	   if(rs.getString("MENU_DEL_USE_STATUS").equals("true"))
			                                	   {
			                                   %>
			                                   <button onclick="deleteBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
			                                   	<span class="glyphicon glyphicon-paste" aria-hidden="true"></span> DELETE
			                                   </button>
			                                   <%
			                                	   }
			                                   }
	                                   		%>
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
        	var element = null;
        	
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
		    	
		    	/*
                 * 날짜포맷 yyyy-MM-dd 변환
                 */
                function getFormatDate(dates){
		    		
                	var date = parse(dates);
		    		
                	alert(date);
                	
                    var year = date.getFullYear();
                    var month = (1 + date.getMonth());
                    month = month >= 10 ? month : '0' + month;
                    var day = date.getDate();
                    day = day >= 10 ? day : '0' + day;
                    
                    alert(year + '-' + month + '-' + day);
                    
                    return year + '-' + month + '-' + day;
                }
		    	
                function parse(str) {
                    var y = str.substr(0, 4);
                    var m = str.substr(4, 2);
                    var d = str.substr(6, 2);
                    return new Date(y,m-1,d);
                }
		    	
			     $.ajax({
		                method: "GET",
		                url: "${contextPath}/moldRest/view.do",
		                success: function (data) {
		                	datas = data;
		                	
		        		    table = new Tabulator("#example-table", { 
		        		    	//페이징
		            			layout:"fitColumns",
		                    	pagination:"local",
		                    	paginationSize:20,
		        		        rowDblClick:function(e, row){
		        		        	//행에 색변경
		              	     		if(element != null){
		              	     			element.style.background = "white";
		              	     		}
		                          		row.getElement().style.background = "#78EAFF";
		                          		element = row.getElement();
		        		        	
		        		        	//e - the click event object
		        		            //row - row component
		        		            console.log(row.getData());
		        		            //console.log(row.getData().id);
		        		            /*
		        		            business_PERSON: ""
									business_PLACE: "1"
									business_PLACE_CODE: "1:본사"
									id: 6
									manufacturer: ""
									mold_INFO_NAME: "xe030 cap"
									mold_INFO_NO: "M01020"
									mold_INFO_RANK: "3:차수3"
									mold_INFO_RANK_CODE: "차수3"
									mold_INFO_STND: "ssdsds"
									mold_ITEM_CODE: "A01026"
									mold_ITEM_NAME: "제오닉 밀폐 XE042"
									mold_RECEIVED_D: ""
									mold_USE_STATUS: "true"
									user_MODIFIER: "관리자"
									user_MODIFY_D: "2020/12/04"
		        		            */
		        		            
		        		            resultFlag="Changed"
		        	    			document.getElementById("MOLD_INFO_NO").setAttribute("disabled","");
		        	    			document.getElementById("MOLD_INFO_NO").value = row.getData().mold_INFO_NO;
		        	    			document.getElementById("MOLD_CUBIT").value = row.getData().mold_CUBIT;
		        	    			//document.getElementById("MOLD_RECEIVED_D").value = getFormatDate(row.getData().mold_RECEIVED_D);
		        	    			document.getElementById("MOLD_INFO_NAME").value = row.getData().mold_INFO_NAME;
		        	    			document.getElementById("MOLD_INFO_STND").value = row.getData().mold_INFO_STND;
		        	    			document.getElementById("PRODUCT_ITEM_CODE").value = row.getData().mold_ITEM_CODE;
		        	    			document.getElementById("PRODUCT_ITEM_NAME").value = row.getData().mold_ITEM_NAME;
		        	    			document.getElementById("MANUFACTURER").value = row.getData().manufacturer;
		        	    			document.getElementById("BUSINESS_PERSON").value = row.getData().business_PERSON;
		        	    			document.getElementById("MOLD_INFO_NO").focus();
		        	    			
		        	    			//document.getElementById("BUSINESS_PLACE_CODE").children[0].setAttribute('selected', '');
		        	    			//document.getElementById("MOLD_INFO_RANK").children[0].setAttribute('selected', '');
		        	    			
		        	    			console.log(document.getElementById("BUSINESS_PLACE_CODE").children.length);
		        	    			for(i=0;i<document.getElementById("BUSINESS_PLACE_CODE").children.length;i++)
		        	    			{
		        	    				var value = row.getData().business_PLACE_CODE.split(":");
		        	    				if(document.getElementById("BUSINESS_PLACE_CODE").options[i].text == value[1])
		        	    				{
		        	    					document.getElementById("BUSINESS_PLACE_CODE").children[i].setAttribute('selected', '');
		        	    				}
		        	    			}
		        	    			
		        	    			for(i=0;i<document.getElementById("MOLD_INFO_RANK").children.length;i++)
		        	    			{
		        	    				var value = row.getData().mold_INFO_RANK_CODE.split(":");
		        	    				
		        	    				if(document.getElementById("MOLD_INFO_RANK").options[i].text == row.getData().mold_INFO_RANK_CODE)
		        	    				{
			        	    				document.getElementById("MOLD_INFO_RANK").options[i].selected = true;
		        	    					//document.getElementById("MOLD_INFO_RANK").children[i].setAttribute('selected', '');
		        	    				}
		        	    			}
		        	    			
		        	    			if(row.getData().mold_USE_STATUS=="true")
				                  		  document.getElementsByName("MOLD_USE_STATUS")[0].checked = true;
				                  	  	else
				                  		  document.getElementsByName("MOLD_USE_STATUS")[1].checked = true;
		        		        },
		        		    	height:"75%",
		        		     	data:datas, 
		        		     	columns:[ 
		        		     	{title:"번호", field:"id", hozAlign:"center",headerHozAlign:"center",width : 80},
		        		     	{title:"사업장", field:"business_PLACE_CODE",headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"금형관리No", field:"mold_INFO_NO", width:120,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"금형명", field:"mold_INFO_NAME", width:200,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"차수", field:"mold_INFO_RANK",width:100,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"규격", field:"mold_INFO_STND", width:100,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"품목코드", field:"mold_ITEM_CODE", width:100,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"품목명", field:"mold_ITEM_NAME", width:200,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"제작업체", field:"manufacturer", width:100,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"업체담당자", field:"business_PERSON", width:120,headerHozAlign:"center", headerFilter:"input"},
		        		     	{title:"케비트", field:"mold_CUBIT", headerHozAlign:"center",width:80, headerFilter:"input",hozAlign:"right"},
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
