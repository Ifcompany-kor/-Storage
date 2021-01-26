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
			+ "            and CHILD_TBL_TYPE = '제품 정보 관리'\r\n"
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
    
       // 변수 초기값
       var resultFlag = "None";
       // reset
       function resetBtn(){
          location.reload();
       }
       // new Btn
       // 공백으로 만들어서 입력할 수 있게 한다.
       function newBtn() {
          resultFlag = "New";
          document.getElementById("PRODUCT_ITEM_CODE").removeAttribute('disabled');
          document.getElementById("PRODUCT_ITEM_CODE").value= "";
          document.getElementById("PRODUCT_ITEM_NAME").value= "";
          document.getElementById("PRODUCT_ITEM_CODE").focus();
          // 안전재고
          /* var operation = document.getElementById("PRODUCT_MTRL_CLSFC").value;
          
          document.getElementById("PRODUCT_MTRL_CLSFC").innerHTML = operation; */
          
          document.getElementById("PRODUCT_INFO_STND_1").value="";
          document.getElementById("PRODUCT_INFO_STND_2").value="";
          document.getElementById("PRODUCT_BUYER").value="";
          
          document.getElementById("PRODUCT_SFTY_STOCK").value=0;
          document.getElementById("PRODUCT_MIN_VOL_ORDERS").value=0;
          document.getElementById("PRODUCT_MAX_VOL_ORDERS").value=0;
          
          document.getElementById("PRODUCT_ITEM_CODE").focus();
          document.getElementById("PRODUCT_BUSINESS_PLACE").options[0].setAttribute('selected', '')
          document.getElementById("PRODUCT_UNIT").options[0].setAttribute('selected', '');
          document.getElementById("PRODUCT_MATERIAL").options[0].setAttribute('selected', '');
          document.getElementById("PRODUCT_MTRL_CLSFC").options[4].setAttribute('selected', '');
          document.getElementById("PRODUCT_ITEM_CLSFC_1").options[0].setAttribute('selected', ''); 
          document.getElementById("PRODUCT_ITEM_CLSFC_2").options[0].setAttribute('selected', '');
          document.getElementById("PRODUCT_ITEM_STTS").options[0].setAttribute('selected', '');
          document.getElementById("PRODUCT_BASIC_WAREHOUSE").options[0].setAttribute('selected', ''); 
          document.getElementsByName("PRODUCT_SUBSID_MATL_MGMT")[0].checked = true;
          document.getElementsByName("PRODUCT_USE_STATUS")[0].checked = true;
          document.getElementsByName("PRODUCT_WRHSN_INSPC")[0].checked = true;
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
              url: "${contextPath}/productRest/delete3.do?PRODUCT_ITEM_CODE="+document.getElementById("PRODUCT_ITEM_CODE").value,
              success: function (data,testStatus) {
            	//console.log(data);
					if(data == "error"){
					    alert("사용하고 있는 데이터는 삭제할 수 없습니다.");
					}else{
					 alert("삭제 성공 하였습니다.");
					}
					   resetBtn();
                }
           });
       
       }
       // 추가, 삭제, 수정 처리하는 로직
       function saveBtn() {
          // 추가 로직 + 유효성 검사
          //  var PRODUCT_SUBSID_MATL_MGMT = ""; -> true냐 false냐 받아오기 위한 로직
    	   if(resultFlag == "None"){
				alert("행을 선택한 후에 저장 버튼을 눌러주십시오.");
	             return;
			}else if(resultFlag=="New")
          {
             conf = confirm("저장 하시겠습니까?");
             if(!conf)
                return;
             var check_count = document.getElementsByName("PRODUCT_SUBSID_MATL_MGMT").length;
                var PRODUCT_SUBSID_MATL_MGMT ="";
                
                for(var i=0; i<check_count; i++) {
                   if(document.getElementsByName("PRODUCT_SUBSID_MATL_MGMT")[i].checked == true) {
                      PRODUCT_SUBSID_MATL_MGMT = document.getElementsByName("PRODUCT_SUBSID_MATL_MGMT")[i].value;
                   }
                }
             // 사용유무 true / false
             var check_count1 = document.getElementsByName("PRODUCT_USE_STATUS").length;
                var PRODUCT_USE_STATUS= "";
                
                for(var i=0; i<check_count1; i++) {
                   if(document.getElementsByName("PRODUCT_USE_STATUS")[i].checked == true) {
                      PRODUCT_USE_STATUS = document.getElementsByName("PRODUCT_USE_STATUS")[i].value;
                   }
                }
             // 입고검사 true / false
             var check_count2 = document.getElementsByName("PRODUCT_WRHSN_INSPC").length;
                var PRODUCT_WRHSN_INSPC= "";
                
                for(var i=0; i<check_count2; i++) {
                   if(document.getElementsByName("PRODUCT_WRHSN_INSPC")[i].checked == true) {
                      PRODUCT_WRHSN_INSPC = document.getElementsByName("PRODUCT_WRHSN_INSPC")[i].value;
                   }
                }
             
             // 품목코드
             if(document.getElementById("PRODUCT_ITEM_CODE").value=="")
             {
                alert("품목 코드는 반드시 입력하셔야 합니다.");
                return;
             }   
             if(document.getElementById("PRODUCT_ITEM_CODE").value.length > 10)
             {
                alert("품목 코드는 10글자 이하로 입력해주세요.");
                     return;
             }
             // 안전재고
             var PRODUCT_SFTY_STOCK = document.getElementById("PRODUCT_SFTY_STOCK").value
             if(document.getElementById("PRODUCT_SFTY_STOCK").value.length < 1)
             {
                PRODUCT_SFTY_STOCK = 0;
             }
             
             data = {
                   PRODUCT_ITEM_CODE : document.getElementById("PRODUCT_ITEM_CODE").value,
                   PRODUCT_ITEM_NAME : document.getElementById("PRODUCT_ITEM_NAME").value,
                       PRODUCT_BUSINESS_PLACE : $("#PRODUCT_BUSINESS_PLACE option:selected").val(),
                       PRODUCT_OLD_ITEM_CODE : document.getElementById("PRODUCT_OLD_ITEM_CODE").value,
                       PRODUCT_INFO_STND_1 : document.getElementById("PRODUCT_INFO_STND_1").value,
                       PRODUCT_INFO_STND_2 : document.getElementById("PRODUCT_INFO_STND_2").value,
                       PRODUCT_UNIT : $("#PRODUCT_UNIT option:selected").val(),
                       PRODUCT_MATERIAL : $("#PRODUCT_MATERIAL option:selected").val(),
                       PRODUCT_MTRL_CLSFC : $("#PRODUCT_MTRL_CLSFC option:selected").val(),
                       PRODUCT_ITEM_CLSFC_1 : $("#PRODUCT_ITEM_CLSFC_1 option:selected").val(),
                       PRODUCT_ITEM_CLSFC_2 : $("#PRODUCT_ITEM_CLSFC_2 option:selected").val(),
                       PRODUCT_SUBSID_MATL_MGMT : PRODUCT_SUBSID_MATL_MGMT,
                       PRODUCT_ITEM_STTS : $("#PRODUCT_ITEM_STTS option:selected").val(),
                       PRODUCT_BASIC_WAREHOUSE : $("#PRODUCT_BASIC_WAREHOUSE option:selected").val(),
                       PRODUCT_SFTY_STOCK :  document.getElementById("PRODUCT_SFTY_STOCK").value,
                       PRODUCT_MIN_VOL_ORDERS : document.getElementById("PRODUCT_MIN_VOL_ORDERS").value,
                       PRODUCT_MAX_VOL_ORDERS : document.getElementById("PRODUCT_MAX_VOL_ORDERS").value,
                       PRODUCT_BUYER : document.getElementById("PRODUCT_BUYER").value,
                       PRODUCT_WRHSN_INSPC  : PRODUCT_WRHSN_INSPC,
                       PRODUCT_USE_STATUS : PRODUCT_USE_STATUS,
                       PRODUCT_MODIFIER : <%=Sel%>
             }
             
             //console.log(data);
             
             //return;
             
                // alert(JSON.stringify(data));
                  //   success: function (data,testStatus) {
                   //         console.log(data);
                   //      }restController에서 받아온 값
                   // if(data == "Overlap") 코드중복체크
                $.ajax({
                   method: "POST",
                    data : null,
                    url: "${contextPath}/productRest/insert3.do?data="+encodeURI(JSON.stringify(data))+"",
                    success : function(data,testStatus)  {
                       console.log(data);
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
             var check_count = document.getElementsByName("PRODUCT_SUBSID_MATL_MGMT").length;
                var PRODUCT_SUBSID_MATL_MGMT ="";
                
                for(var i=0; i<check_count; i++) {
                   if(document.getElementsByName("PRODUCT_SUBSID_MATL_MGMT")[i].checked == true) {
                      PRODUCT_SUBSID_MATL_MGMT = document.getElementsByName("PRODUCT_SUBSID_MATL_MGMT")[i].value;
                   }
                }
             // 사용유무 true / false
             var check_count1 = document.getElementsByName("PRODUCT_USE_STATUS").length;
                var PRODUCT_USE_STATUS= "";
                
                for(var i=0; i<check_count1; i++) {
                   if(document.getElementsByName("PRODUCT_USE_STATUS")[i].checked == true) {
                      PRODUCT_USE_STATUS = document.getElementsByName("PRODUCT_USE_STATUS")[i].value;
                   }
                }
             // 입고검사 true / false
             var check_count2 = document.getElementsByName("PRODUCT_WRHSN_INSPC").length;
                var PRODUCT_WRHSN_INSPC= "";
                
                for(var i=0; i<check_count2; i++) {
                   if(document.getElementsByName("PRODUCT_WRHSN_INSPC")[i].checked == true) {
                      PRODUCT_WRHSN_INSPC = document.getElementsByName("PRODUCT_WRHSN_INSPC")[i].value;
                   }
                }
                data = {
                       PRODUCT_ITEM_CODE : document.getElementById("PRODUCT_ITEM_CODE").value,
                       PRODUCT_ITEM_NAME : document.getElementById("PRODUCT_ITEM_NAME").value,
                           PRODUCT_BUSINESS_PLACE : $("#PRODUCT_BUSINESS_PLACE option:selected").val(),
                           PRODUCT_OLD_ITEM_CODE : document.getElementById("PRODUCT_OLD_ITEM_CODE").value,
                           PRODUCT_INFO_STND_1 : document.getElementById("PRODUCT_INFO_STND_1").value,
                           PRODUCT_INFO_STND_2 : document.getElementById("PRODUCT_INFO_STND_2").value,
                           PRODUCT_UNIT : $("#PRODUCT_UNIT option:selected").val(),
                           PRODUCT_MATERIAL : $("#PRODUCT_MATERIAL option:selected").val(),
                           PRODUCT_MTRL_CLSFC : $("#PRODUCT_MTRL_CLSFC option:selected").val(),
                           PRODUCT_ITEM_CLSFC_1 : $("#PRODUCT_ITEM_CLSFC_1 option:selected").val(),
                           PRODUCT_ITEM_CLSFC_2 : $("#PRODUCT_ITEM_CLSFC_2 option:selected").val(),
                           PRODUCT_SUBSID_MATL_MGMT : PRODUCT_SUBSID_MATL_MGMT,
                           PRODUCT_ITEM_STTS : $("#PRODUCT_ITEM_STTS option:selected").val(),
                           PRODUCT_BASIC_WAREHOUSE : $("#PRODUCT_BASIC_WAREHOUSE option:selected").val(),
                           PRODUCT_SFTY_STOCK : document.getElementById("PRODUCT_SFTY_STOCK").value,
                           PRODUCT_MIN_VOL_ORDERS : document.getElementById("PRODUCT_MIN_VOL_ORDERS").value,
                           PRODUCT_MAX_VOL_ORDERS : document.getElementById("PRODUCT_MAX_VOL_ORDERS").value,
                           PRODUCT_BUYER : document.getElementById("PRODUCT_BUYER").value,
                           PRODUCT_WRHSN_INSPC  : PRODUCT_WRHSN_INSPC,
                           PRODUCT_USE_STATUS : PRODUCT_USE_STATUS,
                           PRODUCT_MODIFIER : <%=Sel%>
                 }
                // alert(JSON.stringify(data));
                      //   success: function (data,testStatus) {
                       //         console.log(data);
                       //      }restController에서 받아온 값
                       // if(data == "Overlap") 코드중복체크
                    $.ajax({
                       method: "POST",
                        data : null,
                        url: "${contextPath}/productRest/update3.do?data="+encodeURI(JSON.stringify(data))+"",
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
                                     <font style="margin-left: 5px;" size="5px;" face="Noto Sans KR">제품 정보 관리</font>
                                  </td>
                               </tr> 
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right" >
                                     사업장&nbsp;
                                  </td>
                                  <td colspan="2" align="right">
                                     <select id="PRODUCT_BUSINESS_PLACE" style="width: 100%;height: 27px;">
                                        <c:forEach var="data" items="${companyList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  
                               </tr>
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right" style="color: red;">
                                     품목코드&nbsp;
                                  </td>
                                  <td colspan="2" align="right">
                                     <input id="PRODUCT_ITEM_CODE" type="text" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('PRODUCT_OLD_ITEM_CODE').focus()}" style="width: 100%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     단위&nbsp;
                                  </td>
                                  <td colspan="2" align="right">
                                     <select id="PRODUCT_UNIT" style="width: 100%;height: 27px;">
                                        <c:forEach var="data" items="${unitList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right">
                                     부자재관리&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input type="radio" name="PRODUCT_SUBSID_MATL_MGMT" value="true" checked="checked">사용
                                     <input type="radio" name="PRODUCT_SUBSID_MATL_MGMT" value="false">미사용
                                  </td>
                                  <td colspan="2" align="right">
                                     사용유무&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input type="radio" name="PRODUCT_USE_STATUS" value="true" checked="checked">사용
                                     <input type="radio" name="PRODUCT_USE_STATUS" value="false">미사용
                                  </td>
                               </tr>
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right" >
                                     구품목코드&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="PRODUCT_OLD_ITEM_CODE" type="text" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('PRODUCT_ITEM_NAME').focus()}" style="width: 100%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     재질&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="PRODUCT_MATERIAL" style="width: 100%;height: 27px;">
                                        <c:forEach var="data" items="${materialList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right">
                                     품목상태&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="PRODUCT_ITEM_STTS" style="width: 100%;height: 27px;">
                                        <c:forEach var="data" items="${itemStatusList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right" >
                                     최소발주&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="PRODUCT_MIN_VOL_ORDERS" type="number" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('PRODUCT_MAX_VOL_ORDERS').focus()}" style="width: 90%;" autocomplete="off">
                                  </td>
                               </tr>
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right" >
                                     품명&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="PRODUCT_ITEM_NAME" type="text" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('PRODUCT_INFO_STND_1').focus()}" style="width: 100%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     자재분류&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="PRODUCT_MTRL_CLSFC" style="width: 100%;height: 27px;">
                                        <c:forEach var="data" items="${mtrlClsfcList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right">
                                     기본창고&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="PRODUCT_BASIC_WAREHOUSE" style="width: 100%;height: 27px;">
                                        <c:forEach var="data" items="${basicWarehouseList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right" >
                                     최대발주&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="PRODUCT_MAX_VOL_ORDERS" type="number" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('PRODUCT_BUYER').focus()}" style="width: 90%;" autocomplete="off">
                                  </td>
                               </tr>
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right" >
                                     규격1&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="PRODUCT_INFO_STND_1" type="text" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('PRODUCT_INFO_STND_2').focus()}" style="width: 100%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     품목분류1&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="PRODUCT_ITEM_CLSFC_1" style="width: 100%;height: 27px;">
                                        <c:forEach var="data" items="${itemClsfc1List}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right">
                                     안전재고&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="PRODUCT_SFTY_STOCK" type="number" onkeypress="javascript:if(event.keyCode==13) {document.getElementById('PRODUCT_MIN_VOL_ORDERS').focus()}" style="width: 100%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     구매담당&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="PRODUCT_BUYER" type="text" style="width: 90%;" autocomplete="off">
                                  </td>
                               </tr>
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right" >
                                     규격2&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="PRODUCT_INFO_STND_2" type="text"  style="width: 100%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     품목분류2&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="PRODUCT_ITEM_CLSFC_2" style="width: 100%;height: 27px;">
                                        <c:forEach var="data" items="${itemClsfc2List}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right">
                                  </td>
                                  <td colspan="2" align="left">
                                  </td>
                                   <td colspan="2" align="right">
                                     입고검사&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input type="radio" name="PRODUCT_WRHSN_INSPC" value="true" checked="checked">사용
                                     <input type="radio" name="PRODUCT_WRHSN_INSPC" value="false">미사용
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
           <c:forEach var="data" items="${productlist}">
              arr.push(
                 {
                       NUM : i,
                       PRODUCT_BUSINESS_PLACE : "${data.PRODUCT_BUSINESS_PLACE}",
                       PRODUCT_BUSINESS_PLACE_NAME : "${data.PRODUCT_BUSINESS_PLACE_NAME}",
                       PRODUCT_ITEM_CODE : "${data.PRODUCT_ITEM_CODE}",
                       PRODUCT_OLD_ITEM_CODE : "${data.PRODUCT_OLD_ITEM_CODE}",
                       PRODUCT_ITEM_NAME : "${data.PRODUCT_ITEM_NAME}",
                       PRODUCT_INFO_STND_1 : "${data.PRODUCT_INFO_STND_1}",
                       PRODUCT_INFO_STND_2 : "${data.PRODUCT_INFO_STND_2}",
                       PRODUCT_UNIT : "${data.PRODUCT_UNIT}",
                       PRODUCT_UNIT_NAME : "${data.PRODUCT_UNIT_NAME}",
                       PRODUCT_MATERIAL : "${data.PRODUCT_MATERIAL}",
                       PRODUCT_MATERIAL_NAME : "${data.PRODUCT_MATERIAL_NAME}",
                       PRODUCT_MTRL_CLSFC : "${data.PRODUCT_MTRL_CLSFC}",
                       PRODUCT_MTRL_CLSFC_NAME : "${data.PRODUCT_MTRL_CLSFC_NAME}",
                       PRODUCT_ITEM_CLSFC_1 : "${data.PRODUCT_ITEM_CLSFC_1}",
                       PRODUCT_ITEM_CLSFC_1_NAME : "${data.PRODUCT_ITEM_CLSFC_1_NAME}",
                       PRODUCT_ITEM_CLSFC_2 : "${data.PRODUCT_ITEM_CLSFC_2}",
                       PRODUCT_ITEM_CLSFC_2_NAME : "${data.PRODUCT_ITEM_CLSFC_2_NAME}",
                       PRODUCT_SUBSID_MATL_MGMT : "${data.PRODUCT_SUBSID_MATL_MGMT}",
                       PRODUCT_ITEM_STTS : "${data.PRODUCT_ITEM_STTS}",
                       PRODUCT_ITEM_STTS_NAME : "${data.PRODUCT_ITEM_STTS_NAME}",
                       PRODUCT_BASIC_WAREHOUSE : "${data.PRODUCT_BASIC_WAREHOUSE}",
                       PRODUCT_BASIC_WAREHOUSE_NAME : "${data.PRODUCT_BASIC_WAREHOUSE_NAME}",
                       PRODUCT_SFTY_STOCK : "${data.PRODUCT_SFTY_STOCK}",
                       PRODUCT_MIN_VOL_ORDERS : "${data.PRODUCT_MIN_VOL_ORDERS}",
                       PRODUCT_MAX_VOL_ORDERS : "${data.PRODUCT_MAX_VOL_ORDERS}",
                       PRODUCT_BUYER : "${data.PRODUCT_BUYER}",
                       PRODUCT_WRHSN_INSPC : "${data.PRODUCT_WRHSN_INSPC}",
                       PRODUCT_MODIFY_D : "${data.PRODUCT_MODIFY_D}",
                       PRODUCT_MODIFIER : "${data.PRODUCT_MODIFIER}",
                       PRODUCT_USE_STATUS : "${data.PRODUCT_USE_STATUS}"
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
                 height:"65%",
                 virtualDomHoz:true,
                 layout : "fitColumns",
                 rowDblClick: function(e, row){
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
                   console.log(row.getData()); 
                   
                   /* NUM : i,
                    PRODUCT_BUSINESS_PLACE : "1",
                    PRODUCT_BUSINESS_PLACE_NAME : "",
                    PRODUCT_ITEM_CODE : "A01001",
                    PRODUCT_OLD_ITEM_CODE : "",
                    PRODUCT_ITEM_NAME : "제오닉 밀폐 XE011",
                    PRODUCT_INFO_STND_1 : "160ml",
                    PRODUCT_INFO_STND_2 : "",
                    PRODUCT_UNIT : "1",
                    PRODUCT_UNIT_NAME : "",
                    PRODUCT_MATERIAL : "1",
                    PRODUCT_MATERIAL_NAME : "",
                    PRODUCT_MTRL_CLSFC : "5",
                    PRODUCT_MTRL_CLSFC_NAME : "",
                    PRODUCT_ITEM_CLSFC_1 : "1",
                    PRODUCT_ITEM_CLSFC_1_NAME : "",
                    PRODUCT_ITEM_CLSFC_2 : "1",
                    PRODUCT_ITEM_CLSFC_2_NAME : "",
                    PRODUCT_SUBSID_MATL_MGMT : "0",
                    PRODUCT_ITEM_STTS : "1",
                    PRODUCT_ITEM_STTS_NAME : "",
                    PRODUCT_BASIC_WAREHOUSE : "3",
                    PRODUCT_BASIC_WAREHOUSE_NAME : "",
                    PRODUCT_SFTY_STOCK : "0",
                    PRODUCT_MIN_VOL_ORDERS : "0",
                    PRODUCT_MAX_VOL_ORDERS : "0",
                    PRODUCT_BUYER : "",
                    PRODUCT_WRHSN_INSPC : "0",
                    PRODUCT_USE_STATUS : "1",
                    PRODUCT_MODIFY_D : "today",
                    PRODUCT_MODIFIER : "admin" */
                    // 더블클릭 이벤트 -> 열의 값을 가져옴
                    document.getElementById("PRODUCT_ITEM_NAME").focus();
                   resultFlag = "Changed";
                   // 사업장
                   document.getElementById("PRODUCT_BUSINESS_PLACE").options[Number(row.getData().PRODUCT_BUSINESS_PLACE)-1].selected = true;
                   // 품목코드
                   document.getElementById("PRODUCT_ITEM_CODE").value = row.getData().PRODUCT_ITEM_CODE;
                   document.getElementById("PRODUCT_ITEM_CODE").setAttribute("disabled","");
                   // 구품목코드
                      document.getElementById("PRODUCT_OLD_ITEM_CODE").value = row.getData().PRODUCT_OLD_ITEM_CODE;
                    //document.getElementById("PRODUCT_ITEM_NAME").value = row.getData().PRODUCT_ITEM_NAME;
                    // 단위
                    document.getElementById("PRODUCT_UNIT").options[Number(row.getData().PRODUCT_UNIT)-1].selected = true;
                    // 부자재관리 true / false
                    if(row.getData().PRODUCT_SUBSID_MATL_MGMT ==  "1" || row.getData().PRODUCT_SUBSID_MATL_MGMT == "true")
                      document.getElementsByName("PRODUCT_SUBSID_MATL_MGMT")[0].checked = true;
                   else
                      document.getElementsByName("PRODUCT_SUBSID_MATL_MGMT")[1].checked = true;
                    // 사용유무 true / false
                    if(row.getData().PRODUCT_USE_STATUS == "1" || row.getData().PRODUCT_USE_STATUS == "true")
                      document.getElementsByName("PRODUCT_USE_STATUS")[0].checked = true;
                   else
                      document.getElementsByName("PRODUCT_USE_STATUS")[1].checked = true;
                   
                      // 재질
                   document.getElementById("PRODUCT_MATERIAL").options[Number(row.getData().PRODUCT_MATERIAL)-1].selected = true;
                      // 품목상태
                      document.getElementById("PRODUCT_ITEM_STTS").options[Number(row.getData().PRODUCT_ITEM_STTS)-1].selected = true;
                      // 최소발주
                      document.getElementById("PRODUCT_MIN_VOL_ORDERS").value = row.getData().PRODUCT_MIN_VOL_ORDERS;
                      // 품명
                      document.getElementById("PRODUCT_ITEM_NAME").value = row.getData().PRODUCT_ITEM_NAME;
                      // 자재분류
                      document.getElementById("PRODUCT_MTRL_CLSFC").options[Number(row.getData().PRODUCT_MTRL_CLSFC)-1].selected = true;
                      // 기본창고
                      document.getElementById("PRODUCT_BASIC_WAREHOUSE").options[Number(row.getData().PRODUCT_BASIC_WAREHOUSE)-1].selected = true;
                      // 최대발주
                      document.getElementById("PRODUCT_MAX_VOL_ORDERS").value = row.getData().PRODUCT_MAX_VOL_ORDERS;
                      // 규격1
                      document.getElementById("PRODUCT_INFO_STND_1").value = row.getData().PRODUCT_INFO_STND_1;
                      // 품목분류1 
                      document.getElementById("PRODUCT_ITEM_CLSFC_1").options[Number(row.getData().PRODUCT_ITEM_CLSFC_1)-1].selected = true;
                      // 안전재고
                      document.getElementById("PRODUCT_SFTY_STOCK").value = row.getData().PRODUCT_SFTY_STOCK;
                      // 구매담당
                      document.getElementById("PRODUCT_BUYER").value = row.getData().PRODUCT_BUYER;
                      // 규격2
                      document.getElementById("PRODUCT_INFO_STND_2").value = row.getData().PRODUCT_INFO_STND_2;
                      // 품목분류2
                      document.getElementById("PRODUCT_ITEM_CLSFC_2").options[Number(row.getData().PRODUCT_ITEM_CLSFC_2)-1].selected = true;
                      // 입고검사
                      if(row.getData().PRODUCT_WRHSN_INSPC ==  "1" || row.getData().PRODUCT_WRHSN_INSPC == "true")
                      document.getElementsByName("PRODUCT_WRHSN_INSPC")[0].checked = true;
                   else
                      document.getElementsByName("PRODUCT_WRHSN_INSPC")[1].checked = true;
                 
                 },
                 columns : [ 
                 {   title : "번호",
                    field : "NUM",
                    hozAlign:"center",
                    headerHozAlign:"center",
                    width : 80
                 }, {
                    title : "사업장",
                    field : "PRODUCT_BUSINESS_PLACE_NAME",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 120
                 }, {
                    title : "품목코드",
                    field : "PRODUCT_ITEM_CODE",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 100
                 }, {
                    title : "구품목코드",
                    field : "PRODUCT_OLD_ITEM_CODE",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 }, {
                    title : "품명",
                    field : "PRODUCT_ITEM_NAME",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 }, {
                    title : "규격1",
                    field : "PRODUCT_INFO_STND_1",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 }, {
                     title : "규격2",
                     field : "PRODUCT_INFO_STND_2",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "단위",
                     field : "PRODUCT_UNIT_NAME",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "재질",
                     field : "PRODUCT_MATERIAL_NAME",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "자재분류",
                     field : "PRODUCT_MTRL_CLSFC_NAME",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "품목분류1",
                     field : "PRODUCT_ITEM_CLSFC_1_NAME",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "품목분류2",
                     field : "PRODUCT_ITEM_CLSFC_2_NAME",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 },  {
                     title : "부자재관리",
                     field : "PRODUCT_SUBSID_MATL_MGMT",
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
                     title : "품목상태",
                     field : "PRODUCT_ITEM_STTS_NAME",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "기본창고",
                     field : "PRODUCT_BASIC_WAREHOUSE_NAME",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                     title : "안전재고",
                     field : "PRODUCT_SFTY_STOCK",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                    title : "최소발주량",
                    field : "PRODUCT_MIN_VOL_ORDERS",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 }, {
                    title : "최대발주량",
                    field : "PRODUCT_MAX_VOL_ORDERS",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 }, {
                     title : "구매담당자",
                     field : "PRODUCT_BUYER",
                     headerHozAlign:"center",
                     headerFilter:"input",
                     width : 150
                 }, {
                       title : "입고검사",
                       field : "PRODUCT_WRHSN_INSPC",
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
                    field : "PRODUCT_MODIFY_D",
                    headerHozAlign:"center",
                    hozAlign :"right",
                    headerFilter:"input",
                    width : 150
                 }, {
                    title : "수정자",
                    field : "PRODUCT_MODIFIER",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 }, {
                     title : "사용유무",
                     field : "PRODUCT_USE_STATUS",
                     headerHozAlign:"center",
                     width : 110,
                     headerHozAlign:"center",
                     hozAlign:"center",
                     formatter:"tickCross",
                     headerFilter:true,
                     headerFilterParams:{values:{"true":"사용", "false":"미사용"}},
                     editor:"select",
                     editorParams:{values:{}}
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