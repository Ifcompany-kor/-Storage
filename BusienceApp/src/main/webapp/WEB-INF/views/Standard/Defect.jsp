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
			+ "            and CHILD_TBL_TYPE = '불량 정보 관리'\r\n"
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
    		var resultFlag = "None";  
    	
    		function resetBtn() {
				location.reload();
			}
    		
    		function newBtn(){
    			resultFlag = "New";
    			document.getElementById("defectCode").removeAttribute('disabled');
    			document.getElementById("defectCode").focus();
    			document.getElementById("defectCode").value = "";
    			document.getElementById("defectName").value = "";
				document.getElementById("DEFECT_RMRKS").value = "";
				document.getElementById("defectABR").value = "";
				document.getElementsByName("defectSTATUS")[0].checked = true;
    		}
    		
    		// 추가,삭제,수정을 처리하는 로직
    		function saveBtn(){
    			// 추가로직
    			if(resultFlag == "None"){
    				alert("행을 선택한 후에 저장 버튼을 눌러주십시오.");
   	             return;
    			}else if(resultFlag=="New")
    			{
    				conf = confirm("저장 하시겠습니까?");
        			if(!conf)
        				return;
        			
        			var check_count = document.getElementsByName("defectSTATUS").length;
        			var defectSTATUS = "";
        			 
        		    for (var i=0; i<check_count; i++) {
        		        if (document.getElementsByName("defectSTATUS")[i].checked == true) {
        		            defectSTATUS = document.getElementsByName("defectSTATUS")[i].value;
        		        }
        		    }
        			
        			if(document.getElementById("defectCode").value=="")
        			{
        				alert("불량코드는 반드시 입력하셔야 합니다.");
        				return;
        			}
        			if(document.getElementById("defectCode").value.length > 4)
        			{
        				alert("불량코드는 4글자 이하로 입력해주세요.");
        				return;
        			}
        			//defectSTATUS
        			$.ajax({
        		        method: "POST",
        		        data : {
        		        	defectCode : document.getElementById("defectCode").value,
        		        	defectName : document.getElementById("defectName").value,
        		        	defectABR : document.getElementById("defectABR").value,
        		        	defectSTATUS : defectSTATUS,
        		        	DEFECT_RMRKS : document.getElementById("DEFECT_RMRKS").value,
        		        	DEFECT_MODIFIER : <%=Sel%>
        		        },
        		        url: "${contextPath}/defectRest/insert.do",
        		        success: function (data) {
        		        	if(data=="Overlap")
        		        		alert("중복코드를 입력하셨습니다. 다른 코드를 입력해주세요.");
        		        	else if(data=="Success")
        		        	{
        		        		alert("저장 완료 하였습니다.");
        						
        						location.reload();
        		        	}
        		        }
        		    }); 
    			}
    			//수정로직
    			else if(resultFlag=="Changed")
    			{
    				conf = confirm("수정 하시겠습니까?");
					if(!conf)
						return;
					
					var check_count = document.getElementsByName("defectSTATUS").length;
					var defectSTATUS = "";
					 
			        for (var i=0; i<check_count; i++) {
			            if (document.getElementsByName("defectSTATUS")[i].checked == true) {
			            	defectSTATUS = document.getElementsByName("defectSTATUS")[i].value;
			            }
			        }
			        
			        data = {
    		        	defectCode : document.getElementById("defectCode").value,
    		        	defectName : document.getElementById("defectName").value,
    		        	defectABR : document.getElementById("defectABR").value,
    		        	defectSTATUS : defectSTATUS,
    		        	DEFECT_RMRKS : document.getElementById("DEFECT_RMRKS").value,
    		        	DEFECT_MODIFIER : <%=Sel%>
    		        }
						
						//alert(JSON.stringify(data));
						
					$.ajax({
			            method: "POST",
			            data : null,
			            url: "${contextPath}/defect/update.do?dataList="+encodeURI(JSON.stringify(data)),
			            success: function (data,textStatus) {
			                alert("수정 성공 하였습니다.");
			               	resetBtn();
			            } 
			        });
    			}		
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
    	              url: "${contextPath}/defect/delete.do?DEFECT_CODE="+document.getElementById("defectCode").value,
    	              success: function (data,testStatus) {
    	                console.log(data);
    	                alert("삭제 성공 하였습니다.");
    	                    resetBtn();
    	                }
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
                	<div style="overflow:hidden; width:100%; height: 100%; padding-left: 10px; padding-right: 10px;">
                	  <div style="width:100%; float: none; margin-top: 5px;padding-bottom:5px;">
                			<div style="width:100%;background: #F2F2F2; border-collapse: separate; border-spacing: 0 2px; border: solid 0.5px;">
                				<table style="width:100%;table-layout: fixed;border-collapse: separate; border-spacing: 0 2px;">
		                			<tr>
		                				<td colspan="20" >
		                					<font style="margin-left: 5px;" size="5px;" face="Noto Sans KR">불량 정보 관리</font>
		                				</td>
		                			</tr> 
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
			                			<td colspan="2" align="right" style="color: red;" >
		                					불량코드&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="defectCode" type="text" style="width: 100%;" autocomplete="off" 
		                					onkeypress="javascript:if(event.keyCode==13) {document.getElementById('defectName').focus()}">
		                				</td>
		                				<td colspan="1" align="right" >
		                					불량명&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="defectName" type="text" style="width: 100%;" autocomplete="off"
		                					onkeypress="javascript:if(event.keyCode==13) {document.getElementById('DEFECT_RMRKS').focus()}">
		                				</td>
		                				<td colspan="1" align="right">
		                					사용유무&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input type="radio" name="defectSTATUS" value="true" checked="checked">사용
											<input type="radio" name="defectSTATUS" value="false">미사용
		                				</td>
		                			</tr><tr>
			                			<td colspan="4">
			                					
			                			</td>
			                			<td colspan="2" align="right" >
		                					비고&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="DEFECT_RMRKS" type="text" style="width: 100%;" autocomplete="off" 
		                					onkeypress="javascript:if(event.keyCode==13) {document.getElementById('defectABR').focus()}">
		                				</td>
		                				<td colspan="1" align="right" >
		                					약자&nbsp;
		                				</td>
		                				<td colspan="2" align="left">
		                					<input id="defectABR" type="text" style="width: 100%;" autocomplete="off">
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
			                                	   if(rs.getString("MENU_WRITE_USE_STATUS").equals("true"))
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
        	element = null;
        
		    window.onload = function() {
		    	var datas = "";
		    	var table = null;
		    	insertFlag = false;
		    	var initflag = true;
			     $.ajax({
		                method: "GET",
		                url: "${contextPath}/defectRest/view.do",
		                success: function (data) {
		                	datas = data;
		                	
		        		    table = new Tabulator("#example-table", {
		        		    	//페이징
		            			layout:"fitColumns",
		                    	pagination:"local",
		                    	responsiveLayout:"hide",
		                    	paginationSize:20,
		                    	
		        		    	rowFormatter:function(row){
		        		    		
		        		            var data = row.getData(); //get data object for row

		        		            if(data.defect_ABR == "cd2"){
		        		                //row.getElement().style.backgroundColor = "#A6A6DF"; //apply css change to row element
		        		            }
		        		            
		        		            if(insertFlag)
		        		            {
		        		            	var row2 = row.getElement().children;
		        		            	//tabindex="0"
		        		            	
		        		            	
		        		            	for(i=0;i<row2.length;i++)
		        		            	{
		        		            		if(i==2)
		        		            		{
		        		            			row2[i].setAttribute("tabindex","0");
		        		            			console.log(row2[i]);
		        		            			console.log(row2[i]);
		        		            		}
		        		            	}
		        		            }
		        		        },
		        		        rowDblClick:function(e, row){
		        		        	//행에 색변경
		               	     		if(element != null){
		               	     			element.style.background = "white";
		               	     		}
		                           		row.getElement().style.background = "#78EAFF";
		                           		element = row.getElement();
		        		        	
		        		        	document.getElementById("defectCode").focus();
			                	    resultFlag = "Changed";
			                	    document.getElementById("defectCode").value = row.getData().defect_CODE;
			                  	  	document.getElementById("defectCode").setAttribute("disabled","");
			                  	  	document.getElementById("defectName").value = row.getData().defect_NAME;
			                  	  	
			                  	    if(row.getData().defect_USE_STATUS=="true")
			                  		  document.getElementsByName("defectSTATUS")[0].checked = true;
			                  	  	else
			                  		  document.getElementsByName("defectSTATUS")[1].checked = true;
			                 	},
			                 	height:"80%",
		        		     	//height:730, // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
		        		     	data:datas, //assign data to table
		        		     	columns:[ //Define Table Columns
		        		     	{title:"번호", field:"id", hozAlign:"center",headerHozAlign:"center",width : 80},
		        		    	{title:"불량코드", field:"defect_CODE", width:100,headerHozAlign:"center", headerFilter:"input"},
		        		    	{title:"불량명", field:"defect_NAME", width:200,headerHozAlign:"center", headerFilter:"input", editor:"input"},
		        		    	{title:"약자", field:"defect_ABR", width:100,headerHozAlign:"center", headerFilter:"input", editor:"input"},
		        		    	{title:"비고", field:"defect_RMRKS", width:200,headerHozAlign:"center", headerFilter:"input", editor:"input"},
		        		    	{title:"사용유무", field:"defect_USE_STATUS", width:100,headerHozAlign:"center",hozAlign:"center", formatter:"tickCross",editor:"select", editorParams:{values:{"true":"사용", "false":"미사용"}}, headerFilter:true, headerFilterParams:{values:{"true":"사용", "false":"미사용"}}},
		        		    	{title:"수정일자", field:"defect_MODIFY_D", width:150,headerHozAlign:"center",hozAlign:"right",sorter:"date",  headerFilter:"input"},
		        		    	{title:"수정자", field:"defect_MODIFIER", width:150,headerHozAlign:"center", headerFilter:"input"}
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
