<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>설비코드 팝업</title>
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
         url : "${contextPath}/EquipmentRest/popup?EQUIPMENT_INFO_CODE="
               + document.getElementById("EQUIPMENT_INFO_CODE").value
               + "&EQUIPMENT_INFO_NAME="
               + document.getElementById("EQUIPMENT_INFO_NAME").value,
         success : function(data) {
            // ProductRestController가 응답한 json list데이터를 가져옴
            datas = data;
            console.log(data);
            table = new Tabulator("#example-table", { 
                    rowSelectionChanged:function(data, rows){
                        //dataList.data = data;
                    },
                    rowClick:function(e, row){
                       console.log(row.getData().production_EQUIPMENT_CODE);
                       document.getElementById("EQUIPMENT_INFO_CODE").value = row.getData().equipment_INFO_CODE;
                       //row.getData()
                       //transfer();
                    },
                    rowDblClick:function(e, row){
                        //e - the click event object
                        //row - row component
                        //window.opener.document.getElementById("MANUFACTURER").focus();
                       window.opener.document.getElementById("EQUIPMENT_INFO_CODE").value = row.getData().equipment_INFO_CODE;
                       window.opener.document.getElementById("EQUIPMENT_INFO_NAME").value = row.getData().equipment_INFO_NAME;
                       window.close();
                    },
                   height:"100%",
                    data:datas, 
                    columns:[ 
                    {title:"", field:"id", hozAlign:"center"},
                   {title:"설비코드", field:"equipment_INFO_CODE", width:100,headerHozAlign:"center"},
                   {title:"설비명", field:"equipment_INFO_NAME", width:200,headerHozAlign:"center"}
                    ],
                });
         }
      });
   }
</script>
</head>

<body>
   <script>
      window.onload = function() {
         // 받을 때
         document.getElementById("EQUIPMENT_INFO_NAME").value = window.parent.localStorage
               .getItem('EQUIPMENT_INFO_NAME');
         // 팝업이 뜨자마자 바로 검색
         search();
      }
   </script>
   <div style="float: left; width: 100%;">
      <table border="0" style="width: 100%;">
         
         <tr>
            <td align="right">코드</td>
            <td colspan="2"><input type="text" id="EQUIPMENT_INFO_CODE"
               style="width: 95%;" /></td>
            <td align="right">이름</td>
            <td colspan="2"><input type="text" id="EQUIPMENT_INFO_NAME"
               style="width: 95%;" /></td>
         </tr>
         <tr>
            <td colspan="6" align="right"><input onclick="search()"
               type="button" value="찾기" /> <input onclick="exitfrn()"
               type="button" value="종료" /></td>
         </tr>
         
      </table>
   </div>

   <div style="float: left; width: 100%;" id="example-table"></div>
</body>

</html>