<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>품질 제품코드 팝업</title>
 <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
        <link href="https://unpkg.com/tabulator-tables@4.8.4/dist/css/tabulator.min.css" rel="stylesheet">
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@4.8.4/dist/js/tabulator.min.js"></script>
<script>
	// 다른 곳 눌렀을 때 팝업창이 꺼짐
	$(window).on("blur", function () {
	    //self.close();
	});
	// 팝업 종료
	function exitfrn() {
	      window.close();
	   }
	
	function search() {
		$.ajax({
			method : "GET",
			url : "${contextPath}/productDQualityPopup?PRODUCTION_DEFECT_CODE="
					+ document.getElementById("PRODUCTION_DEFECT_CODE").value
					+ "&PRODUCTION_DEFECT_NAME="
					+ document.getElementById("PRODUCTION_DEFECT_NAME").value,
			success : function(data) {
				// ProductRestController가 응답한 json list데이터를 가져옴
				datas = data;
				console.log(data);
				table = new Tabulator("#example-table", { 
                    rowSelectionChanged:function(data, rows){
                        //dataList.data = data;
                    },
                    rowClick:function(e, row){
                       console.log(row.getData().defect_CODE);
                       document.getElementById("PRODUCTION_DEFECT_CODE").value = row.getData().defect_CODE;
                       document.getElementById("PRODUCTION_DEFECT_NAME").value = row.getData().defect_NAME;
                       //row.getData()
                       //transfer();
                    },
                    rowDblClick:function(e, row){
                        //e - the click event object
                        //row - row component
                        //window.opener.document.getElementById("MANUFACTURER").focus();
                       window.opener.document.getElementById("PRODUCTION_DEFECT_CODE").value = row.getData().defect_CODE;
                       window.opener.document.getElementById("PRODUCTION_DEFECT_NAME").value = row.getData().defect_NAME;
                       window.close();
                    },
                   height:"100%",
                    data:datas, 
                    columns:[ 
                    {title:"", field:"id", hozAlign:"center"},
                   {title:"불량코드", field:"defect_CODE", width:100,headerHozAlign:"center"},
                   {title:"불량명", field:"defect_NAME", width:200,headerHozAlign:"center"},
                    ],
                });
			}
		});
	}
</script>

<style type="text/css">
header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  
  height: 75px;
  padding: 1rem;
  color: black;
  background: white;
  font-weight: bold;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

h1, p {
  margin: 0;
}

main {
  padding: 1rem;
  height: 430px;  
}

body {
  background: #EEE;
}

body, html {
  height: 200%;
}

* {
  box-sizing: border-box;
}
</style>

</head>

<body style="overflow-y: hidden;">
	<script>
		window.onload = function() {
			// 받을 때
			document.getElementById("PRODUCTION_DEFECT_NAME").value = window.parent.localStorage
					.getItem('PRODUCTION_DEFECT_NAME');
			// 팝업이 뜨자마자 바로 검색
			search();
		}
	</script>
	
	<header>
		<table style="width: 100%;">
			
			<tr>
				<td align="right">불량코드</td>
				<td colspan="2"><input type="text" id="PRODUCTION_DEFECT_CODE"
					style="width: 95%;" /></td>
				<td align="right">불량명</td>
				<td colspan="2"><input type="text" id="PRODUCTION_DEFECT_NAME"
					style="width: 95%;" /></td>
			</tr>
			<tr>
				<td colspan="6" align="right"><input onclick="search()"
					type="button" value="찾기" /> <input onclick="exitfrn()"
					type="button" value="종료" /></td>
			</tr>
		</table>
	</header>
	
	<main>
	  <div style="margin-top: 60px; margin-bottom: 10px;" id="example-table"></div>
	</main>  
</body>

</html>