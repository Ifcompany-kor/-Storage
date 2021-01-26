<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>금형코드 팝업</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
<link href="https://unpkg.com/tabulator-tables@4.8.4/dist/css/tabulator.min.css" rel="stylesheet">
<script type="text/javascript" src="https://unpkg.com/tabulator-tables@4.8.4/dist/js/tabulator.min.js"></script>

	<script>
		$(window).on("blur", function () {
		    //self.close();
		});
	
		function search()
		{
			$.ajax({
                method: "GET",
                url: "${contextPath}/moldRest/popup?MOLD_INFO_NO="+document.getElementById("MOLD_INFO_NO").value+"&MOLD_INFO_NAME="+document.getElementById("MOLD_INFO_NAME").value,
                success: function (data) {
                	datas = data;
                	
                	console.log(datas);
                	
                	
        		    table = new Tabulator("#example-table", { 
        		        rowSelectionChanged:function(data, rows){
        		            //dataList.data = data;
        		        },
        		        rowClick:function(e, row){
        		        	console.log(row.getData().product_ITEM_CODE);
        		        	document.getElementById("MOLD_INFO_NO").value = row.getData().mold_INFO_NO;
        		        	//row.getData()
        		        	//transfer();
        		        },
        		        rowDblClick:function(e, row){
        		            //e - the click event object
        		            //row - row component
        		            //window.opener.document.getElementById("MANUFACTURER").focus();
        		        	window.opener.document.getElementById("MOLD_INFO_NO").value = row.getData().mold_INFO_NO;
        		    		
        		        	//window.opener.PRODUCT_ITEM_ROW_SELECT(row.getData().product_ITEM_CODE,row.getData().product_ITEM_NAME);
        		        	window.close();
        		        },
        		    	height:"100%",
        		     	data:datas, 
        		     	columns:[ 
        		     	{title:"", field:"id", hozAlign:"center"},
        		    	{title:"금형코드", field:"mold_INFO_NO", width:100,headerHozAlign:"center"},
        		    	{title:"금형이름", field:"mold_INFO_NAME", width:200,headerHozAlign:"center"}
        		     	],
        		    });
                	
                }
        });
		}
		
		function exitfrn() {
			window.close();
		}
	</script>
</head>
<body>
	<script type="text/javascript">
		window.onload = function() {
			// 받을때
			document.getElementById("MOLD_INFO_NAME").value = window.parent.localStorage.getItem('MOLD_INFO_NAME');
			
			search();
		}
	</script>

	<div style="float: left; width: 100%;">
		<table border="0" style="width: 100%;">
			<tr>
				<td align="right">
					코드
				</td>
				<td colspan="2">
					<input type="text" id="MOLD_INFO_NO" style="width: 95%;"/>
				</td>
				<td align="right">
					이름
				</td>
				<td colspan="2">
					<input type="text" id="MOLD_INFO_NAME" style="width: 95%;"/>
				</td>
			</tr>
			<tr>
				<td colspan="6" align="right">
					<input onclick="search()" type="button" value="찾기"/>
					<input onclick="exitfrn()" type="button" value="종료"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div style="float: left; width: 100%;" id="example-table"></div>
</body>
</html>