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
			+ "            and CHILD_TBL_TYPE = '사용자 관리'\r\n"
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

    var element = null;    

       function CheckEnter(frm, objName)
       {
           var keycode = event.keyCode;        
           var i = 0;
           var USER_CODE = document.getElementById("USER_CODE");
           console.log(keycode);
           console.log(frm);
           if( keycode == 13 ){
             document.getElementById("USER_NAME").focus();
           }
       }
       // 변수 초기값
       var resultFlag = "None";
       // reset
       function resetBtn() {
          location.reload();
       }
       // new
       // 공백으로 만들어서 입력할 수 있게한다.
       function newBtn() {
             resultFlag ="New";
            document.getElementById("USER_CODE").removeAttribute('disabled');
            document.getElementById("USER_CODE").value = "";
            document.getElementById("USER_NAME").value = "";
            document.getElementById("USER_CODE").focus();
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
              url: "${contextPath}/UserRest/delete2.do?USER_CODE="+document.getElementById("USER_CODE").value,
              success: function (data,testStatus) {
                console.log(data);
                
                	if(data=="Fail")
                	{
                		alert("다른 페이지에서 쓰고 있어서 데이터가 삭제되지 않습니다.");
                		return;
                	}
                
                	alert("삭제 성공 하였습니다.");
                    resetBtn();
                }
           });
       
       }
       // 추가, 삭제, 수정을 처리하는 로직
       function saveBtn() {
          // 추가 로직 + 유효성 검사
          //  var USER_USE_STATUS = ""; -> true냐 false냐 받아오기 위한 로직
    	   if(resultFlag == "None"){
				alert("행을 선택한 후에 저장 버튼을 눌러주십시오.");
	             return;
			}else if(resultFlag=="New")
         {
            conf =  confirm("저장 하시겠습니까?");
            if(!conf)
               return;
            var check_count = document.getElementsByName("USER_USE_STATUS").length;
                  var USER_USE_STATUS = "";
                   
                    for (var i=0; i<check_count; i++) {
                        if (document.getElementsByName("USER_USE_STATUS")[i].checked == true) {
                           USER_USE_STATUS = document.getElementsByName("USER_USE_STATUS")[i].value;
                        }
                    }
                  
                  if(document.getElementById("USER_CODE").value=="")
                  {
                     alert("사용자 코드는 반드시 입력하셔야 합니다.");
                     return;
                  }
                  if(document.getElementById("USER_CODE").value.length > 10)
                  {
                     alert("사용자 코드는 10글자 이하로 입력해주세요.");
                     return;
                  }
                  
                  data = {
                         USER_CODE : document.getElementById("USER_CODE").value,
                         USER_NAME : document.getElementById("USER_NAME").value,
                         COMPANY : $("#COMPANY option:selected").val(),
                         USER_TYPE : $("#USER_TYPE option:selected").val(),
                         USER_MODIFIER : <%=Sel%>,
                         USER_USE_STATUS : USER_USE_STATUS,
                         DEPT_CODE : $("#DEPT_CODE option:selected").val()
                      }
                  
                  // alert(JSON.stringify(data));
                  //   success: function (data,testStatus) {
                   //         console.log(data);
                   //      }restController에서 받아온 값
                   // if(data == "Overlap") 코드중복체크
                  $.ajax({
                     method: "POST",
                      data : null,
                      url: "${contextPath}/UserRest/insert2.do?data="+encodeURI(JSON.stringify(data))+"",
                      success: function (data,testStatus) {
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
      //  수정로직
            
      else if(resultFlag=="Changed")  {
         conf =  confirm("수정 하시겠습니까?");
         if(!conf)
            return;
         var check_count = document.getElementsByName("USER_USE_STATUS").length;
               var USER_USE_STATUS = "";
                
                 for (var i=0; i<check_count; i++) {
                     if (document.getElementsByName("USER_USE_STATUS")[i].checked == true) {
                        USER_USE_STATUS = document.getElementsByName("USER_USE_STATUS")[i].value;
                     }
                 }
                 
                 data = {
                         USER_CODE : document.getElementById("USER_CODE").value,
                         USER_NAME : document.getElementById("USER_NAME").value,
                         COMPANY : $("#COMPANY option:selected").val(),
                         USER_TYPE : $("#USER_TYPE option:selected").val(),
                         USER_MODIFIER : <%=Sel%>,
                         USER_USE_STATUS : USER_USE_STATUS,
                         DEPT_CODE : $("#DEPT_CODE option:selected").val()
                      }
                  
                  // alert(JSON.stringify(data));
                  //   success: function (data,testStatus) {
                   //         console.log(data);
                   //      }restController에서 받아온 값
                   // if(data == "Overlap") 코드중복체크
                  $.ajax({
                     method: "POST",
                      data : null,
                      url: "${contextPath}/UserRest/update2.do?data="+encodeURI(JSON.stringify(data))+"",
                      success: function (data,testStatus) {
                         console.log(data);
                        alert("수정 성공 하였습니다.");
                         resetBtn();
                      }
                  });
      }
       }
          // 비번 초기화
          function pwReset() {
             if (resultFlag!="Changed")
              {
                 alert("행을 선택 후에 초기화 버튼을 눌러주십시오.");
                 return;
              }
              conf =  confirm("초기화 하시겠습니까?");
             if(!conf)
                return;
                     
               $.ajax({
                  method: "POST",
                  data : null,
                  url: "${contextPath}/UserRest/pwReset2.do?USER_CODE="+document.getElementById("USER_CODE").value,
                  success: function (data,testStatus) {
                    console.log(data);
                    alert("초기화 성공 하였습니다.");
                        resetBtn();
                    }
               });             
          
       }
    
    </script>
    <body class="sb-nav-fixed">
        <!- sb topnave -->
        <jsp:include page="../sb-topnav.jsp"></jsp:include>
        <form id="defectFrm" name="f"></form>
        <div id="layoutSidenav">
           <!-- layoutSidenav_nav -->
            <jsp:include page="../layoutSidenav_nav.jsp"></jsp:include>
            <div id="layoutSidenav_content">
                <div style="overflow:hidden; width:100%; height: 100%; padding-left: 10px; padding-right: 10px;">
                         <div style="width:100%;">
                            <table style="width:100%; margin-top: 5px; border-collapse: separate; border-spacing: 0 2px; table-layout: fixed; border: solid 0.5px; background: #F2F2F2;">
                               <tr>
                                  <td colspan="20" >
                                     <font style="margin-left: 5px;" size="5px;" face="Noto Sans KR">사용자 관리</font>
                                  </td>
                               </tr> 
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right"  style=" line-height : 100%;color:red;" >
                                     사용자코드&nbsp;
                                  </td>
                                  <td colspan="2" align="left"  style="word-wrap:break-word;">
                                     <input id="USER_CODE" type="text"  OnKeyDown="CheckEnter(this.form,this)" style="width: 100%; resize: none;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     사용자명&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="USER_NAME" type="text"  OnKeyDown="CheckEnter(this.form,this)" style="width: 100%;" autocomplete="off">
                                  </td>
                                  <td colspan="2" align="right">
                                     사업장&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="COMPANY" style="width: 100%; height: 27px;">
                                        <c:forEach var="data" items="${companyList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right">
                                     사용유무&nbsp;
                                  </td>
                                  <td colspan="3" align="left">
                                     <input type="radio" name="USER_USE_STATUS" value="true" checked="checked">사용
                                 <input type="radio" name="USER_USE_STATUS" value="false">미사용
                                  </td>
                               </tr>
                               <tr>
                                  <td colspan="3">
                                     
                                  </td>
                                  <td colspan="2" align="right" >
                                     비밀번호&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input type="button" style="width: 100%" value="초기화" onclick="pwReset()"/>
                                  </td>
                                  <td colspan="2" align="right">
                                     사용자 타입&nbsp;
                                  </td>
                                  <td colspan="2" align="right">
                                     <select id="USER_TYPE" style="width: 100%; height: 27px;">
                                        <c:forEach var="data" items="${userTypeList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
                                  </td>
                                  <td colspan="2" align="right">
                                     부서&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <select id="DEPT_CODE" style="width: 100%; height: 27px;">
                                        <c:forEach var="data" items="${deptList}">
                                           <option value="${data.CHILD_TBL_NUM}">${data.CHILD_TBL_TYPE}</option>
                                        </c:forEach>
                                     </select>
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
                                	   //if(rs.getString("MENU_DEL_USE_STATUS").equals("true"))
                                	   if(false)	   
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
                         
                         <div id="example-table" style="overflow: auto; "></div>
                </div>
            </div>
        </div>
        <script>
        window.onload = function(){
           var arr = new Array();
           i = 1;
           <c:forEach var="data" items="${userlist}">
              arr.push(
                 {
                     NUM : i,
                     USER_CODE : "${data.USER_CODE}" ,
                       USER_PASSWORD : "${data.USER_PASSWORD}",
                       USER_NAME : "${data.USER_NAME}",
                       USER_TYPE : "${data.USER_TYPE}",
                       COMPANY : "${data.COMPANY}",
                       DEPT_CODE : "${data.DEPT_CODE}",
                       USER_MODIFIER : "${data.USER_MODIFIER}",
                       USER_MODIFY_D : "${data.USER_MODIFY_D}",
                       USER_USE_STATUS : "${data.USER_USE_STATUS}",
                       COMPANY_NAME : "${data.COMPANY_NAME}",
                       USER_TYPE_NAME : "${data.USER_TYPE_NAME}",
                       DEPT_NAME : "${data.DEPT_NAME}"
                 }
              );
              i++;
           </c:forEach>
           // rowDblClick: function(e, row) 더블클릭하면 선택 행을 가져옴
            var table = new Tabulator("#example-table", {
            	//페이징
    			layout:"fitColumns",
            	pagination:"local",
            	responsiveLayout:"hide",
            	paginationSize:20,
   	    		   	        
                 data : arr,
                 height:"80%",
                 rowDblClick: function(e, row){
     	     		//행에 색변경
     	     		if(element != null){
     	     			element.style.background = "white";
     	     		}
                 		row.getElement().style.background = "#78EAFF";
                 		element = row.getElement();
                   
                /*    COMPANY: "3"
                   COMPANY_NAME: "2공장"
                   DEPT_CODE: "1"
                   DEPT_NAME: "경영관리"
                   NUM: 2
                   USER_CODE: "dkf"
                   USER_MODIFIER: "null"
                   USER_MODIFY_D: "2020/12/03"
                   USER_NAME: "sfdfw"
                   USER_PASSWORD: "D7B5033B56AB1F4709397607B112BDD0"
                   USER_TYPE: "2"
                   USER_TYPE_NAME: "현장입력자"
                   USER_USE_STATUS: "true" */
                   
                   
                   document.getElementById("USER_NAME").focus();
                   resultFlag ="Changed";
                    document.getElementById("USER_CODE").value = row.getData().USER_CODE;
                    document.getElementById("USER_CODE").setAttribute("disabled","");
                      document.getElementById("USER_NAME").value = row.getData().USER_NAME;
                      document.getElementById("COMPANY").options[Number(row.getData().COMPANY)-1].selected = true;
                      document.getElementById("USER_TYPE").options[Number(row.getData().USER_TYPE)-1].selected = true;
                   if(row.getData().USER_USE_STATUS ==  "true")
                      document.getElementsByName("USER_USE_STATUS")[0].checked = true;
                   else
                      document.getElementsByName("USER_USE_STATUS")[1].checked = true;
             
                      document.getElementById("DEPT_CODE").options[Number(row.getData().DEPT_CODE)].selected = true;
                   //   
                 },
                 columns : [ 
                 
                 {   title : "번호",
                    field : "NUM",
                    hozAlign:"center",
                    headerHozAlign:"center",
                    width : 80
                 }, 
                 {
                    title : "사용자 코드",
                    field : "USER_CODE",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 120
                 }, {
                    title : "사용자 명",
                    field : "USER_NAME",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 100
                 }, {
                    title : "사용자 타입",
                    field : "USER_TYPE_NAME",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 }, {
                    title : "사업장",
                    field : "COMPANY_NAME",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 }, {
                    title : "부서",
                    field : "DEPT_NAME",
                    headerHozAlign:"center",
                    headerFilter:"input",
                    width : 150
                 },{
                       title : "사용유무",
                       field : "USER_USE_STATUS",
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
                    field : "USER_MODIFY_D",
                    headerHozAlign:"center",
                    hozAlign :"right",
                    headerFilter:"input",
                    width : 150
                }, {
                    title : "수정자",
                    field : "USER_MODIFIER",
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