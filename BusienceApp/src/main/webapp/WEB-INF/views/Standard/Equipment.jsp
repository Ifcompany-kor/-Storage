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
         + "      t1.*,\r\n"
         + "        t2.CHILD_TBL_TYPE MENU_PROGRAM_NAME\r\n"
         + "from   \r\n"
         + "      (\r\n"
         + "         select\r\n"
         + "               *\r\n"
         + "         from\r\n"
         + "               MENU_MGMT_TBL\r\n"
         + "         where MENU_USER_CODE = '"+session.getAttribute("id")+"'\r\n"
         + "        ) t1\r\n"
         + "right outer join \r\n"
         + "      (\r\n"
         + "         select \r\n"
         + "               * \r\n"
         + "         from DTL_TBL where NEW_TBL_CODE='13'\r\n"
         + "            and CHILD_TBL_TYPE = '설비 정보 관리'\r\n"
         + "        ) t2\r\n"
         + "on t1.MENU_PROGRAM_CODE = t2.CHILD_TBL_NUM order by MENU_PROGRAM_CODE+0\r\n";
 
 Class.forName("com.mysql.jdbc.Driver");
 Connection con = DriverManager.getConnection("jdbc:mysql://xeonic11.cafe24.com:3306/xeonic11","xeonic11","gil45200!");
 PreparedStatement pstmt = con.prepareStatement(sql);
 ResultSet rs = pstmt.executeQuery(sql);
 
 ResultSetMetaData rsmd = rs.getMetaData();
 int columnCnt = rsmd.getColumnCount(); //컬럼의 수
%>

<!DOCTYPE html>
<html lang="ko">
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
    var element = null;
    var table = null;
    
       // 변수 초기값
       var resultFlag = "None";
       // reset
       function resetBtn() {
          location.reload();
       }
       
       // new Btn
       // 공백으로 만들어서 입력할 수 있게 한다.
       const sb = document.querySelector('#BUSINESS_PLACE_CODE');
       
       function newBtn() {
          resultFlag  = "New";
          document.getElementById("EQUIPMENT_INFO_CODE").removeAttribute('disabled');
          document.getElementById("EQUIPMENT_INFO_CODE").value="";
          document.getElementById("EQUIPMENT_INFO_NAME").value="";
          document.getElementById("EQUIPMENT_RECEIVED_D").value="";
          document.getElementById("EQUIPMENT_MODEL_YEAR").value="";
          document.getElementById("EQUIPMENT_INFO_RMARK").value="";
          document.getElementById("EQUIPMENT_SERIAL_NUM").value="";
          document.getElementById("EQUIPMENT_MANUFACTURER").value="";
          
          document.getElementById("EQUIPMENT_HEIGHT").value=0;
          document.getElementById("EQUIPMENT_WIDTH").value=0;
          document.getElementById("EQUIPMENT_DEPTH").value=0;
          document.getElementById("EQUIPMENT_WEIGHT").value=0;
          
          document.getElementById("EQUIPMENT_INFO_CODE").focus();
          document.getElementById("EQUIPMENT_BUSINESS_PLACE").options[0].setAttribute('selected', '')
          document.getElementById("EQUIPMENT_INFO_ABR").options[0].setAttribute('selected', '');
          document.getElementById("EQUIPMENT_STATUS").options[0].setAttribute('selected', ''); 
          document.getElementsByName("EQUIPMENT_USE_STATUS")[0].checked = true;
       }
       // 설비연식 자동 입력
       function date_change(today) {
          var date =  today.value;
          var substr = date.substring(0,4);
          document.getElementById('EQUIPMENT_MODEL_YEAR').value = substr;
       }
       // 삭제
       function deleteBtn() {
          if(resultFlag!="Changed")
          {
             alert("행을 선택한 후에 삭제 버튼을 눌러주십시오.");
             return;
          }
          conf = confirm("삭제 하시겠습니까?");
          if(!conf)
             return;
          
          $.ajax({
               method: "POST",
               data : null,
               url: "${contextPath}/EquipmentRest/delete4.do?EQUIPMENT_INFO_CODE="+document.getElementById("EQUIPMENT_INFO_CODE").value,
               success: function (data,testStatus) {
                 console.log(data);
                 alert("삭제 성공 하였습니다.");
                     resetBtn();
                 }
            });
       }
       // 추가, 삭제, 수정 처리하는 로직
       function saveBtn() {
          // 추가 로직 + 유효성 검사
          // 사용유무 true / false 받아오기
          if(resultFlag == "None"){
            alert("행을 선택한 후에 저장 버튼을 눌러주십시오.");
                return;
         }else if(resultFlag=="New")
          {
             conf = confirm("저장 하시겠습니까?");
             if(!conf)
                return;
             var check_count = document.getElementsByName("EQUIPMENT_USE_STATUS").length;
                var EQUIPMENT_USE_STATUS ="";
             
             for(var i=0; i<check_count; i++) {
               if(document.getElementsByName("EQUIPMENT_USE_STATUS")[i].checked == true) {
                  EQUIPMENT_USE_STATUS = document.getElementsByName("EQUIPMENT_USE_STATUS")[i].value;
               }
            }
             
             // 설비코드
             if(document.getElementById("EQUIPMENT_INFO_CODE").value=="")
             {
                alert("설비 코드는 반드시 입력하셔야 합니다.");
                return;
             }
             if(document.getElementById("EQUIPMENT_INFO_CODE").value.length > 10)
             {
                alert("설비 코드는 10글자 이하로 입력해주세요.");
                return;
             }
             
             data =  {
                   EQUIPMENT_BUSINESS_PLACE : $("#EQUIPMENT_BUSINESS_PLACE option:selected").val(),
                   EQUIPMENT_INFO_CODE : document.getElementById("EQUIPMENT_INFO_CODE").value,
                   EQUIPMENT_INFO_NAME : document.getElementById("EQUIPMENT_INFO_NAME").value,
                   EQUIPMENT_INFO_ABR : $("#EQUIPMENT_INFO_ABR option:selected").val(),
                   EQUIPMENT_HEIGHT : document.getElementById("EQUIPMENT_HEIGHT").value,
                   EQUIPMENT_WIDTH : document.getElementById("EQUIPMENT_WIDTH").value,
                   EQUIPMENT_DEPTH : document.getElementById("EQUIPMENT_DEPTH").value, 
                   EQUIPMENT_SERIAL_NUM : document.getElementById("EQUIPMENT_SERIAL_NUM").value,
                   EQUIPMENT_WEIGHT : document.getElementById("EQUIPMENT_WEIGHT").value, 
                   EQUIPMENT_RECEIVED_D : document.getElementById("EQUIPMENT_RECEIVED_D").value,
                   EQUIPMENT_MODEL_YEAR : document.getElementById("EQUIPMENT_MODEL_YEAR").value,
                   EQUIPMENT_MANUFACTURER : document.getElementById("EQUIPMENT_MANUFACTURER").value,
                   EQUIPMENT_STATUS : $("#EQUIPMENT_STATUS option:selected").val(),
                   EQUIPMENT_INFO_RMARK : document.getElementById("EQUIPMENT_INFO_RMARK").value, 
                   EQUIPMENT_USE_STATUS : EQUIPMENT_USE_STATUS,
                   EQUIPMENT_MODIFIER : <%=Sel%>   
                     
             }
             console.log("data : "+data);
             var code = encodeURI(JSON.stringify(data)).length;
             console.log(code);
             
             $.ajax({
                   method: "POST",
                    url: "${contextPath}/EquipmentRest/insert4.do?data="+encodeURI(JSON.stringify(data))+"",
                    data: null,
                    success : function(data,testStatus)  {
                       //console.log("data : " + data);
                       if(data == "Overlap")
                          alert("중복 코드를 입력하셨습니다. 다시 입력해주세요.");
                       else
                       {
                         alert("입력 성공 하였습니다.");
                            resetBtn();
                       }
                    }
                });
          }
          // 수정로직
           else if(resultFlag=="Changed") {
              conf = confirm("수정 하시겠습니까?");
              if(!conf)
                 return;
             // 사용유무 true / false
             var check_count1 = document.getElementsByName("EQUIPMENT_USE_STATUS").length;
                var EQUIPMENT_USE_STATUS= "";
                
                for(var i=0; i<check_count1; i++) {
                   if(document.getElementsByName("EQUIPMENT_USE_STATUS")[i].checked == true) {
                      EQUIPMENT_USE_STATUS = document.getElementsByName("EQUIPMENT_USE_STATUS")[i].value;
                   }
                }
                data = {
                      EQUIPMENT_BUSINESS_PLACE : $("#EQUIPMENT_BUSINESS_PLACE option:selected").val(),
                       EQUIPMENT_INFO_CODE : document.getElementById("EQUIPMENT_INFO_CODE").value,
                       EQUIPMENT_INFO_NAME : document.getElementById("EQUIPMENT_INFO_NAME").value,
                       EQUIPMENT_INFO_ABR : $("#EQUIPMENT_INFO_ABR option:selected").val(),
                       EQUIPMENT_HEIGHT : document.getElementById("EQUIPMENT_HEIGHT").value,
                       EQUIPMENT_WIDTH : document.getElementById("EQUIPMENT_WIDTH").value,
                       EQUIPMENT_DEPTH : document.getElementById("EQUIPMENT_DEPTH").value, 
                       EQUIPMENT_SERIAL_NUM : document.getElementById("EQUIPMENT_SERIAL_NUM").value,
                       EQUIPMENT_WEIGHT : document.getElementById("EQUIPMENT_WEIGHT").value, 
                       EQUIPMENT_RECEIVED_D : document.getElementById("EQUIPMENT_RECEIVED_D").value,
                       EQUIPMENT_MODEL_YEAR : document.getElementById("EQUIPMENT_MODEL_YEAR").value,
                       EQUIPMENT_MANUFACTURER : document.getElementById("EQUIPMENT_MANUFACTURER").value,
                       EQUIPMENT_STATUS : $("#EQUIPMENT_STATUS option:selected").val(),
                       EQUIPMENT_INFO_RMARK : document.getElementById("EQUIPMENT_INFO_RMARK").value, 
                       EQUIPMENT_USE_STATUS : EQUIPMENT_USE_STATUS,
                       EQUIPMENT_MODIFIER : <%=Sel%>   
                 }
                // alert(JSON.stringify(data));
                      //   success: function (data,testStatus) {
                       //         console.log(data);
                       //      }restController에서 받아온 값
                       // if(data == "Overlap") 코드중복체크
                    $.ajax({
                       method: "POST",
                        data : null,
                        url: "${contextPath}/EquipmentRest/update4.do?data="+encodeURI(JSON.stringify(data))+"",
                        success : function(data,testStatus)  {
                           console.log(data);
                             alert("수정 성공 하였습니다.");
                             resetBtn();
                           }
                        }
                    );
           }
       }
    </script>
    <body class="sb-nav-fixed">
        <!- sb topnave -->
        <jsp:include page="../sb-topnav.jsp"></jsp:include>
        <form id="defectFrm"></form>
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
                                     <font style="margin-left: 5px;" size="5px;" face="Noto Sans KR">설비 정보 관리</font>
                                  </td>
                               </tr> 
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right" >
                                     사업장&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="EQUIPMENT_BUSINESS_PLACE" style="width: 100%;height: 27px;">
                                        <c:forEach var="data" items="${companyList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="4">
                                     
                                  </td>
                                  <td colspan="2" align="right">
                                      설비(깊이)&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="EQUIPMENT_DEPTH" type="number" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_SERIAL_NUM').focus()}" style="width: 105%;" autocomplete="off">
                                  </td>
                                  
                               </tr>
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right" style="color:red;">
                                     설비코드&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="EQUIPMENT_INFO_CODE" type="text" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_INFO_NAME').focus()}" style="width: 100%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     설비명&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="EQUIPMENT_INFO_NAME" type="text" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_INFO_ABR').focus()}" style="width: 105%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     설비(S/N)&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                      <input id="EQUIPMENT_SERIAL_NUM" type="text" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_MANUFACTURER').focus()}" style="width: 105%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     제작업체&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="EQUIPMENT_MANUFACTURER" type="text" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_INFO_RMARK').focus()}" style="width: 90%;" autocomplete="off">   
                                  </td>
                               </tr>
                               <tr>
                                  <td colspan="7">
                                     
                                  </td>
                                  <td colspan="2" align="right">
                                      설비호기&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="EQUIPMENT_INFO_ABR" style="width: 105%;height: 27px;">
                                        <c:forEach var="data" items="${equipmentList}">
                                           <option value="${data.EQUIPMENT_INFO_ABR}">${data.EQUIPMENT_INFO_ABR}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right">
                                     설비(무게)&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="EQUIPMENT_WEIGHT" type="number" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_RECEIVED_D').focus()}" style="width: 105%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     설비상태&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="EQUIPMENT_STATUS" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_INFO_RMARK').focus()}" style="width: 90%;height: 27px;">
                                        <c:forEach var="data" items="${equipmentStatusList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                               </tr>
                               <tr>
                                  <td colspan="7">
                                     
                                  </td>
                                  <td colspan="2" align="right" >
                                     설비(높이)&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="EQUIPMENT_HEIGHT" type="number" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_WIDTH').focus()}" style="width: 105%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     구입일자&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="EQUIPMENT_RECEIVED_D" type="date" style="width: 105%;height: 27px;" onchange='date_change(this)' onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_MODEL_YEAR').focus()}"autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     사용유무&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input type="radio" name="EQUIPMENT_USE_STATUS" value="true" checked="checked">사용
                                     <input type="radio" name="EQUIPMENT_USE_STATUS" value="false">미사용
                                  </td>
                                 
                               </tr>
                               <tr>
                                  <td colspan="7">
                                     
                                  </td>
                                  <td colspan="2" align="right" >
                                     설비(폭)&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="EQUIPMENT_WIDTH" type="number" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_DEPTH').focus()}" style="width: 105%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     설비연식&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                      <input id="EQUIPMENT_MODEL_YEAR" type="text" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('EQUIPMENT_MANUFACTURER').focus()}" style="width: 105%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     비고&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="EQUIPMENT_INFO_RMARK" type="text" style="width: 90%;" autocomplete="off">
                                  </td>
                                  
                               </tr>
                               <tr>
                                  <td colspan="13">
                                     
                                  </td>
                                
                               </tr>
                               <tr>
                                     <td colspan="3">
                                     
                                     </td>
                               </tr>
                               <tr>
                                     <td colspan="3">
                                     
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
                      
                      <div id="example-table" style="overflow: auto;"></div>
                </div>
            </div>
        </div>
        
        <script>
        element = null;
        window.onload = function(){
           var arr = new Array();
           i = 1;
           <c:forEach var="data" items="${equipmentList}">
              arr.push(
                 {
                       NUM : i,
                       EQUIPMENT_BUSINESS_PLACE : "${data.EQUIPMENT_BUSINESS_PLACE}",
                       EQUIPMENT_BUSINESS_PLACE_NAME : "${data.EQUIPMENT_BUSINESS_PLACE_NAME}",
                       EQUIPMENT_INFO_CODE : "${data.EQUIPMENT_INFO_CODE}",
                       EQUIPMENT_INFO_NAME : "${data.EQUIPMENT_INFO_NAME}",
                       EQUIPMENT_INFO_ABR : "${data.EQUIPMENT_INFO_ABR}",
                       EQUIPMENT_HEIGHT : "${data.EQUIPMENT_HEIGHT}",
                       EQUIPMENT_WIDTH : "${data.EQUIPMENT_WIDTH}",
                       EQUIPMENT_DEPTH : "${data.EQUIPMENT_DEPTH}",
                       EQUIPMENT_SERIAL_NUM : "${data.EQUIPMENT_SERIAL_NUM}",
                       EQUIPMENT_WEIGHT : "${data.EQUIPMENT_WEIGHT}",
                       EQUIPMENT_RECEIVED_D : "${data.EQUIPMENT_RECEIVED_D}",
                       EQUIPMENT_MODEL_YEAR : "${data.EQUIPMENT_MODEL_YEAR}",
                       EQUIPMENT_MANUFACTURER : "${data.EQUIPMENT_MANUFACTURER}",
                       EQUIPMENT_STATUS : "${data.EQUIPMENT_STATUS}",
                       EQUIPMENT_STATUS_NAME : "${data.EQUIPMENT_STATUS_NAME}",
                       EQUIPMENT_INFO_RMARK : "${data.EQUIPMENT_INFO_RMARK}",
                       EQUIPMENT_USE_STATUS : "${data.EQUIPMENT_USE_STATUS}",
                       EQUIPMENT_MODIFY_D : "${data.EQUIPMENT_MODIFY_D}",
                       EQUIPMENT_MODIFIER : "${data.EQUIPMENT_MODIFIER}",
                 }
              );
              i++;
           </c:forEach>
           // rowDblClick: function(e, row) 더블클릭하면 선택 행을 가져옴
            var table = new Tabulator("#example-table", {
               //페이징
             layout:"fitColumns",
               pagination:"local",
               paginationSize:20,
                 data : arr,
                 height:"70%",
                 virtualDomHoz:true,
                 layout : "fitColumns",
                 rowDblClick: function(e, row){
                   //행에 색변경
                     if(element != null){
                        element.style.background = "white";
                     }
                         row.getElement().style.background = "#78EAFF";
                         element = row.getElement();
                   console.log(row.getData()); 
                   
                   
                    // 더블클릭 이벤트 -> 열의 값을 가져옴
                    document.getElementById("EQUIPMENT_INFO_NAME").focus();
                   resultFlag = "Changed";
                   // 사업장
                   document.getElementById("EQUIPMENT_BUSINESS_PLACE").value = row.getData().EQUIPMENT_BUSINESS_PLACE;
                   // 설비코드
                   document.getElementById("EQUIPMENT_INFO_CODE").value = row.getData().EQUIPMENT_INFO_CODE;
                   document.getElementById("EQUIPMENT_INFO_CODE").setAttribute("disabled","");
                   // 설비명
                    document.getElementById("EQUIPMENT_INFO_NAME").value = row.getData().EQUIPMENT_INFO_NAME;
                    // 설비호기
                    document.getElementById("EQUIPMENT_INFO_ABR").value = row.getData().EQUIPMENT_INFO_ABR;
                    // 설비(높이)
                      document.getElementById("EQUIPMENT_HEIGHT").value = row.getData().EQUIPMENT_HEIGHT;
                    // 설비(폭)
                      document.getElementById("EQUIPMENT_WIDTH").value = row.getData().EQUIPMENT_WIDTH;
                    // 설비(깊이)
                      document.getElementById("EQUIPMENT_DEPTH").value = row.getData().EQUIPMENT_DEPTH;
                    // 설비(S/N)
                    document.getElementById("EQUIPMENT_SERIAL_NUM").value = row.getData().EQUIPMENT_SERIAL_NUM;
                    // 설비(무게)
                      document.getElementById("EQUIPMENT_WEIGHT").value = row.getData().EQUIPMENT_WEIGHT;
                    // 구입일자
                   document.getElementById("EQUIPMENT_RECEIVED_D").value = row.getData().EQUIPMENT_RECEIVED_D;
                      // 설비연식
                      document.getElementById("EQUIPMENT_MODEL_YEAR").value = row.getData().EQUIPMENT_MODEL_YEAR;
                      // 제작업체
                      document.getElementById("EQUIPMENT_MANUFACTURER").value = row.getData().EQUIPMENT_MANUFACTURER;
                    // 설비상태
                      document.getElementById("EQUIPMENT_STATUS").value = row.getData().EQUIPMENT_STATUS;
                      // 사용유무
                      if(row.getData().EQUIPMENT_USE_STATUS ==  "1" || row.getData().EQUIPMENT_USE_STATUS == "true")
                      document.getElementsByName("EQUIPMENT_USE_STATUS")[0].checked = true;
                   else
                      document.getElementsByName("EQUIPMENT_USE_STATUS")[1].checked = true;
                      // 비고
                      document.getElementById("EQUIPMENT_INFO_RMARK").value = row.getData().EQUIPMENT_INFO_RMARK;
                      // 설비사진
                      //document.getElementById("PRODUCT_MAX_VOL_ORDERS").value = row.getData().PRODUCT_MAX_VOL_ORDERS;
                 
                 },
                 columns : [ 
                 {   title : "번호",
                    field : "NUM",
                    hozAlign:"center",
                    headerHozAlign:"center",
                    width : 80
                 }, {
                    title : "사업장",
                    field : "EQUIPMENT_BUSINESS_PLACE_NAME",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 120
                 }, {
                    title : "설비코드",
                    field : "EQUIPMENT_INFO_CODE",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 120
                 }, {
                    title : "설비명",
                    field : "EQUIPMENT_INFO_NAME",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 }, {
                    title : "설비호기",
                    field : "EQUIPMENT_INFO_ABR",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 100
                 }, {
                    title : "설비(높이)",
                    field : "EQUIPMENT_HEIGHT",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 100
                 }, {
                     title : "설비(폭)",
                     field : "EQUIPMENT_WIDTH",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 100
                 }, {
                     title : "설비(깊이)",
                     field : "EQUIPMENT_DEPTH",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 100
                 }, {
                     title : "설비(S/N)",
                     field : "EQUIPMENT_SERIAL_NUM",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "설비(무게)",
                     field : "EQUIPMENT_WEIGHT",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 100
                 }, {
                     title : "구입일자",
                     field : "EQUIPMENT_RECEIVED_D",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "설비연식",
                     field : "EQUIPMENT_MODEL_YEAR",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 100
                 },  {
                     title : "제작업체",
                     field : "EQUIPMENT_MANUFACTURER",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                   }, {
                     title : "설비상태",
                     field : "EQUIPMENT_STATUS_NAME",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 120
                 }, {
                     title : "비고",
                     field : "EQUIPMENT_INFO_RMARK",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "사용유무",
                     field : "EQUIPMENT_USE_STATUS",
                     headerHozAlign:"center",
                     width : 110,
                     headerHozAlign:"center",
                     hozAlign:"center",
                     formatter:"tickCross",
                     headerFilter:true,
                     headerFilterParams:{values:{"true":"사용", "false":"미사용"}},
                     editor:"select",
                     editorParams:{values:{}}
                 }, {
                    title : "수정일자",
                    field : "EQUIPMENT_MODIFY_D",
                    headerHozAlign:"center",
                    hozAlign :"right",
                    headerFilter:"input",
                    width : 150
                 }, {
                    title : "수정자",
                    field : "EQUIPMENT_MODIFIER",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 } ],
                 validationFailed : function(cell, value, validators) {
                    //cell - cell component for the edited cell
                    //value - the value that failed validation
                    //validatiors - an array of validator objects that failed

                    //take action on validation fail
                 },
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