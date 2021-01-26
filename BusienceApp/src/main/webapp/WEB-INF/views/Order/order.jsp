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
        <!-- sb topnave -->
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
                                     <font style="margin-left: 5px;" size="5px;" face="Noto Sans KR">발주 관리</font>
                                  </td>
                               </tr> 
                               <tr>
                               	  <td colspan="4"></td>
                               	  <td colspan="2" align="right">
                               	  	거래처코드&nbsp;
                               	  </td>
                               	  <td colspan="2" align="left">
		                				<input id="Cus_Code" type="text" style="width: 100%;" autocomplete="off" disabled="disabled">
		                		  </td>
		                		  <td colspan="1" align="right" >
		                			거래처명&nbsp;
		                		  </td>
		                		  <td colspan="2" align="left">
		                				<input id="Cus_Name" type="text" style="width: 100%;" autocomplete="off" 
		                				onkeypress="javascript:if(event.keyCode==13) {document.getElementById('defectABR').focus()}">
		                		  </td>
                               </tr>
                               <tr> 
                                  <td colspan="20" style="margin-left: 5px;">&nbsp;
                                  	<button onclick="searchBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
										<span class="glyphicon glyphicon-search" aria-hidden="true"></span> SEARCH
									 </button>
                                  	 <button onclick="saveBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
	                                   <span class="glyphicon glyphicon-paste" aria-hidden="true"></span> SAVE
	                                 </button>
	                                 <button onclick="excelBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
	                                   <span class="glyphicon glyphicon-print" aria-hidden="true"></span> PRINT
	                            	 </button>
                                 </td>
                               </tr>
                            </table>
                         </div>
                      </div>
                      <div id="example-table1" style="overflow: auto; width:60%; float:left; margin-right: 10px;">
                      </div>
                      <div id="example-table2" style="overflow: auto; width:39%; float:left;"></div>
                </div>
            </div>
        </div>
        
        <script>
        element = null;
        
        var tabledata = [
			{Order_mCus_No:"C01001_20210125_1", Order_mCode:"C01001",Order_mDate:"2021-01-12 17:49:03", 
			Order_mTotal:"100", Order_mDlvry_Date:"2021-01-12 17:49:03",Order_mRemarks:"없음",
			Order_mModifier:"admin",Order_mModify_Date:"2021-01-12 17:49:03"}
		];
        
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
	        },
	        height:"80%",
	     	data:tabledata, 
	     	columns:[ 
	     		{title:"발주No", field:"Order_mCus_No",headerHozAlign:"center",hozAlign:"right",width : 150},
	     		{title:"거래처코드", field:"Order_mCode",headerHozAlign:"center"},
	     		{title:"발주일", field:"Order_mDate",headerHozAlign:"center",hozAlign:"right"},
	     		{title:"납기일자", field:"Order_mDlvry_Date",headerHozAlign:"center",hozAlign:"right"},
	     		{title:"특기사항", field:"Order_mRemarks",headerHozAlign:"center"},
	     		{title:"수정자", field:"Order_mModifier",headerHozAlign:"center"},
	     		{title:"수정일자", field:"Order_mModify_Date",headerHozAlign:"center"},
	     		{title:"합계금액", field:"Order_mTotal",headerHozAlign:"center",hozAlign:"right"}
	     	],
	    });
        
        element2 = null;
        
        var tabledata2 = [
			{Order_INo:"1",Order_ICus_No:"C01001_20210125_1", Order_ICode:"C01001",
			Order_IQty:"30",Order_IUnit_Price:"100",Order_IPrice:"10000",  
			Order_IInfo_Remark:"없음"}
		];
        
        table2 = new Tabulator("#example-table2", { 
	        rowSelectionChanged:function(data, rows){
	        },
	        rowClick:function(e, row){
	            //e - the click event object
	            //row - row component
	            //console.log(row.getIndex());
	            //console.log(row.getData().id);
	            new_TBL_CODE = row.getData().new_TBL_CODE;
	            
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
	        },
	        height:"80%",
	     	data:tabledata2, 
	     	columns:[ 
	     		{title:"순번", field:"Order_INo",headerHozAlign:"center",hozAlign:"right"},
	     		{title:"발주No", field:"Order_ICus_No",headerHozAlign:"center",hozAlign:"right",width : 150},
	     		{title:"거래처코드", field:"Order_mCode",headerHozAlign:"center"},
	     		{title:"발주일", field:"Order_mDate",headerHozAlign:"center",hozAlign:"right"},
	     		{title:"납기일자", field:"Order_mDlvry_Date",headerHozAlign:"center",hozAlign:"right"},
	     		{title:"특기사항", field:"Order_mRemarks",headerHozAlign:"center"},
	     		{title:"수정자", field:"Order_mModifier",headerHozAlign:"center"},
	     		{title:"수정일자", field:"Order_mModify_Date",headerHozAlign:"center"},
	     		{title:"합계금액", field:"Order_mTotal",headerHozAlign:"center",hozAlign:"right"}
	     	],
	    });
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