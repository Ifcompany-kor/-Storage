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
			+ "            and CHILD_TBL_TYPE = '공통코드 관리'\r\n"
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
    
    </head>
    <script>
    	var resultFlag = "None";
    	var new_TBL_CODE = 0;
    	var child_TBL_NUM = -1;
    	
    	function newBtn() {
    		if(new_TBL_CODE == 0)
    		{
    			alert("공통코드 행을 선택한 후에 NEW 버튼을 눌러주시길 바랍니다.");
    			return;
    		}
    		
    		resultFlag = "New";
    		document.getElementById("CHILD_TBL_TYPE").focus();
    		document.getElementById("CHILD_TBL_TYPE").value = "";
    		document.getElementById("CHILD_TBL_RMARK").value = "";
		}
    	
    	function saveBtn() {
    		if(resultFlag=="New")
    		{
    			conf = confirm("저장 하시겠습니까?");
    			if(!conf)
    				return;
    			
    			if(document.getElementById("CHILD_TBL_TYPE").value=="")
    			{
    				alert("코드명은 반드시 입력하셔야 합니다.");
    				return;
    			}
    			
    			var check_count1 = document.getElementsByName("CHILD_TBL_USE_STATUS").length;
				var CHILD_TBL_USE_STATUS_VALUE= "";
				
				for(var i=0; i<check_count1; i++) {
					if(document.getElementsByName("CHILD_TBL_USE_STATUS")[i].checked == true) {
						CHILD_TBL_USE_STATUS_VALUE = document.getElementsByName("CHILD_TBL_USE_STATUS")[i].value;
					}
				}
    			
    			$.ajax({
    		        method: "POST",
    		        data : {
    		        	NEW_TBL_CODE : new_TBL_CODE,
    		        	CHILD_TBL_TYPE : document.getElementById("CHILD_TBL_TYPE").value,
    		        	CHILD_TBL_RMARK : document.getElementById("CHILD_TBL_RMARK").value,
    		        	CHILD_TBL_USE_STATUS : CHILD_TBL_USE_STATUS_VALUE
    		        },
    		        url: "${contextPath}/CodeRest/insert.do",
    		        success: function (data) {
    		        	if(data=="Success")
    		        	{
    		        		alert("저장 완료 하였습니다.");
    						
    						location.reload();
    		        	}
    		        }
    		    }); 
    		}
    		else if(resultFlag=="Changed"){
    			conf =  confirm("수정 하시겠습니까?");
		         if(!conf)
		            return;
		         
		        if(new_TBL_CODE=="13")
		    	{
		    		alert("프로그램명은 수정 불가능합니다.");
		    		return;
		    	}
		         
		         var check_count1 = document.getElementsByName("CHILD_TBL_USE_STATUS").length;
					var CHILD_TBL_USE_STATUS_VALUE= "";
					
					for(var i=0; i<check_count1; i++) {
						if(document.getElementsByName("CHILD_TBL_USE_STATUS")[i].checked == true) {
							CHILD_TBL_USE_STATUS_VALUE = document.getElementsByName("CHILD_TBL_USE_STATUS")[i].value;
						}
				}
		         
		         $.ajax({
	    		        method: "POST",
	    		        data : {
	    		        	NEW_TBL_CODE : new_TBL_CODE,
	    		        	CHILD_TBL_NUM : child_TBL_NUM,
	    		        	CHILD_TBL_TYPE : document.getElementById("CHILD_TBL_TYPE").value,
	    		        	CHILD_TBL_RMARK : document.getElementById("CHILD_TBL_RMARK").value,
	    		        	CHILD_TBL_USE_STATUS : CHILD_TBL_USE_STATUS_VALUE
	    		        },
	    		        url: "${contextPath}/CodeRest/update.do",
	    		        success: function (data) {
	    		        	if(data=="Success")
	    		        	{
	    		        		alert("수정 완료 하였습니다.");
	    						
	    						location.reload();
	    		        	}
	    		        }
	    		    });
    		}
		}
    </script>
    <body class="sb-nav-fixed">
        <!- sb topnave -->
        <jsp:include page="../sb-topnav.jsp"></jsp:include>
        <form id="menuFrm" name="f"></form>
        <div id="layoutSidenav">
           <!-- layoutSidenav_nav -->
            <jsp:include page="../layoutSidenav_nav.jsp"></jsp:include>
            <div id="layoutSidenav_content">
                <div style="overflow:hidden; width:100%; height: 100%; padding-left: 10px; padding-right: 10px;">
                      <div style="width:100%; float: none; margin-bottom: 10px;">
                         <div style="width:100%;">
                            <table style="width:100%; margin-top: 5px; border-collapse: separate; border-spacing: 0 2px; table-layout: fixed; border: solid 0.5px; background: #F2F2F2;">
                               <tr>
                                  <td colspan="20" >
                                     <font style="margin-left: 5px;" size="5px;" face="Noto Sans KR">공통코드 관리</font>
                                  </td>
                               </tr> 
                               <tr>
                                  <td colspan="4">
                                     
                                  </td>
                                  <td colspan="2" align="right">
                                     타입명&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="CHILD_TBL_TYPE" type="text" style="width: 100%;" autocomplete="off"
                                     onkeypress="javascript:if(event.keyCode==13) {document.getElementById('CHILD_TBL_RMARK').focus()}">
                                  </td>
                                  <td colspan="2" align="right">
                                     비고&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="CHILD_TBL_RMARK" type="text" style="width: 100%;" autocomplete="off"
                                     onkeypress="javascript:if(event.keyCode==13) {document.getElementById('CHILD_TBL_NUM').focus()}">
                                  </td>
                               </tr>
                               <tr>
                               	  <td colspan="4">
                                     
                                  </td>
                               	  <td colspan="2" align="right">
                                     사용유무&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input type="radio" name="CHILD_TBL_USE_STATUS" value="true" checked="checked">사용
                                     <input type="radio" name="CHILD_TBL_USE_STATUS" value="false">미사용
                                  </td>
                               </tr>
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
	                                   <span class="glyphicon glyphicon-paste" aria-hidden="true"></span> SAVE
	                                 </button>
                                  	 <%
                                  		}
                                  	 }
                                  	 %>
                                 </td>
                               </tr>
                            </table>
                         </div>
                      </div>
                      <div id="example-table1" style="overflow: auto; width:30%; float:left; margin-right: 10px;">
                      </div>
                      <div id="example-table2" style="overflow: auto; width:40%; float:left;"></div>
                </div>
            </div>
        </div>
        
        <script>
        element = null;
        
        function GridSetting1(orgindata){
        	table = new Tabulator("#example-table1", { 
		        rowSelectionChanged:function(data, rows){
		        },
		        rowClick:function(e, row){
		            //e - the click event object
		            //row - row component
		            //console.log(row.getIndex());
		            //console.log(row.getData().id);
		            new_TBL_CODE = row.getData().new_TBL_CODE;
		            
		            if(element == null)
		            {
		            	element = row.getElement();
		            	row.getElement().style.background = "#78EAFF";
		            }
		            else
		            {
		            	element.style.background = "white";
	            		row.getElement().style.background = "#78EAFF";
	            		element = row.getElement();
		            }
		            
		            GridSetting2(row.getData().new_TBL_CODE);
		        },
		        rowUpdated:function(row){
		            alert("수정");
		        },
		        height:"80%",
		     	data:orgindata, 
		     	columns:[ 
		     		{title:"공통코드", field:"new_TBL_CODE",headerHozAlign:"center",hozAlign:"right"},
		     		{title:"공통코드 명", field:"new_TBL_NAME",headerHozAlign:"center"},
		     		{title:"비고", field:"new_TBL_INDEX",headerHozAlign:"center",width : 100}
		     	],
		    });
        } 
        
        element2 = null;
        
        function GridSetting2(NEW_TBL_CODE)
       	{
        	$.ajax({
                method: "GET",
                url: "${contextPath}/CodeRest/view2.do?NEW_TBL_CODE="+NEW_TBL_CODE,
                success: function (data) {
                	datas = data;
                	
        		    table = new Tabulator("#example-table2", { 
        		        rowDblClick:function(e, row){
        		            //e - the click event object
        		            //row - row component
        		            console.log(row.getData());
        		            //console.log(row.getData().id);
        		            
        		            if(element2 == null)
				            {
				            	element2 = row.getElement();
				            	row.getElement().style.background = "#78EAFF";
				            }
				            else
				            {
				            	element2.style.background = "white";
			            		row.getElement().style.background = "#78EAFF";
			            		element2 = row.getElement();
				            }
        		            
        		            //child_TBL_USE_STATUS
        		            if(row.getData().child_TBL_USE_STATUS=="true")
			                	document.getElementsByName("CHILD_TBL_USE_STATUS")[0].checked = true;
			                else
			                	document.getElementsByName("CHILD_TBL_USE_STATUS")[1].checked = true;
        		            
        		        	resultFlag = "Changed";
        		        	new_TBL_CODE = row.getData().new_TBL_CODE;
        		        	child_TBL_NUM = row.getData().child_TBL_NUM;
        		        	document.getElementById("CHILD_TBL_TYPE").value = row.getData().child_TBL_TYPE;
        		        	document.getElementById("CHILD_TBL_RMARK").value = row.getData().child_TBL_RMARK;
        		        },
        		        rowUpdated:function(row){
        		            alert("수정");
        		        },
        		        height:"80%",
        		     	data:datas, 
        		     	columns:[ 
        		     	{title:"순번", field:"child_TBL_NUM",headerHozAlign:"center",hozAlign:"right"},
        		     	{title:"타입명", field:"child_TBL_TYPE",headerHozAlign:"center"},
        		     	{title:"비고", field:"child_TBL_RMARK",headerHozAlign:"center",width:100},
        		     	{
    	                    title : "사용유무",
    	                    field : "child_TBL_USE_STATUS",
    	                    headerHozAlign:"center",
 	                        width : 110,
 	                        headerHozAlign:"center",
 	                        hozAlign:"center",
 	                        formatter:"tickCross",
 	                        editor:"select",
 	                        editorParams:{values:{"true":"사용", "false":"미사용"}}
    	                }
        		     	],
        		    });
                }
        	});
       	}
        //child_TBL_USE_STATUS
        window.onload = function(){
        	$.ajax({
                method: "GET",
                url: "${contextPath}/CodeRest/view.do",
                success: function (data) {
                	GridSetting1(data);
                	//new_TBL_CODE = data[0].new_TBL_CODE;
                	//GridSetting2(data[0].new_TBL_CODE);
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