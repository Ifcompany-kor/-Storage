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
   if(Name == null || Name.equals(""))
      response.sendRedirect(request.getContextPath());
   
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
         + "            and CHILD_TBL_TYPE = '메뉴 관리'\r\n"
         + "        ) t2\r\n"
         + "on t1.MENU_PROGRAM_CODE = t2.CHILD_TBL_NUM order by MENU_PROGRAM_CODE+0\r\n";
   
   //System.out.println(sql);
   
   Class.forName("com.mysql.jdbc.Driver");
   Connection con = DriverManager.getConnection("jdbc:mysql://xeonic11.cafe24.com:3306/xeonic11","xeonic11","gil45200!");
   PreparedStatement pstmt = con.prepareStatement(sql);
   ResultSet rs = pstmt.executeQuery(sql);
   
   ResultSetMetaData rsmd = rs.getMetaData();
   int columnCnt = rsmd.getColumnCount(); //컬럼의 수
   
   /*
   while(rs.next())
   {
      for(int i=1 ; i<=columnCnt ; i++){
                 // 컬럼명                                   //데이터
      System.out.println(rsmd.getColumnName(i)+","+rs.getString(rsmd.getColumnName(i)));  
      }
   }
   */
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
       var dataList = {
         "data": []
      }

       function updateBtn() {
          if(!DataCheck("행을 체크 후에 수정을 진행하여 주십시오.","수정 하시겠습니까?"))
            return;
         
         alert("수정 완료 하였습니다.!");
         
         hiddenInput("menuFrm","modifier",<%=Sel%>);
         hiddenInput("menuFrm","dataList",JSON.stringify(dataList));
         frmSubmit("menuFrm","post","menu/update");
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
       
       function DataCheck(message1,message2) {
         if(dataList.data.length == 0)
         {
            alert(message1);
            return false;
         }
         
         conf = confirm(message2);
         return conf;
      }
       
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
       
       function searchBtn() {
          //console.log(document.getElementById("USER_CODE").value);
          console.log(document.getElementById("USER_NAME").value);
          
          $.ajax({
               method: "GET",
               data : null,
               url: "${contextPath}/UserRest/view.do?USER_NAME="+document.getElementById("USER_NAME").value,
               success: function (data,testStatus) {
                  GridSetting1(data);
               }
           });
      }
       
       function resetBtn() {
           location.reload();
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
                                     <font style="margin-left: 5px;" size="5px;" face="Noto Sans KR">메뉴 관리</font>
                                  </td>
                               </tr> 
                               <tr>
                                  <td colspan="4">
                                     
                                  </td>
                                  <td colspan="2" align="right">
                                     사용자명&nbsp;
                                  </td>
                                  <td colspan="2" align="left">
                                     <input id="USER_NAME" type="text"  OnKeyDown="CheckEnter(this.form,this)" style="width: 100%;" autocomplete="off">
                                  </td>
                               </tr>
                               <tr> 
                                  <td colspan="20" style="margin-left: 5px;">&nbsp;
                                   <%
                                   while(rs.next())
                                   {
                                      if(rs.getString("MENU_WRITE_USE_STATUS").equals("true"))
                                      {
                                   %>
                                   <button onclick="updateBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
                                      <span class="glyphicon glyphicon-paste" aria-hidden="true"></span> UPDATE
                                    </button>
                                   <%      
                                      }
                                   }
                                   
                                   rs.close();
                                   pstmt.close();
                                   con.close();
                                   %>
                                    <button onclick="resetBtn()" type="button" style="font-size:13px; width:80px; font-family: 'Noto Sans KR', sans-serif;" class="btn btn-default btn-sm">
                                         <span class="glyphicon glyphicon-refresh" aria-hidden="true"></span> RESET
                                     </button>
                                 </td>
                               </tr>
                            </table>
                         </div>
                      </div>
                      <div id="example-table1" style="overflow: auto; width:50%; float:left; margin-right: 10px;">
                      </div>
                      <div id="example-table2" style="overflow: auto; width:46%; float:left;"></div>
                </div>
            </div>
        </div>
        
        <script>
        element = null;
        initFlag = true;
        
        function GridSetting1(orgindata){
           table = new Tabulator("#example-table1", { 
              rowSelectionChanged:function(data, rows){
                 if(initFlag)
                 {
                    //element = rows.getElement();
                    //rows.getElement().style.background = "#78EAFF";
                    console.log(rows);
                 }
              },
              dataLoading:function(data){
                 //console.log(data);
              },
              rowClick:function(e, row){
                  //e - the click event object
                  //row - row component
                  //console.log(row.getIndex());
                  //console.log(row.getData().id);
                  console.log(row.getData().user_CODE);
                  GridSetting2(row.getData().user_CODE);
                  
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
              rowUpdated:function(row){
                  alert("수정");
              },
             height:"80%",
              data:orgindata, 
              columns:[ 
                 {
                       title : "사용자 코드",
                       field : "user_CODE",
                       headerHozAlign:"center",
                       width : 120
                   },
                   {
                       title : "사용자 명",
                       field : "user_NAME",
                       headerHozAlign:"center",
                       width : 100
                   },
                   {
                       title : "부서",
                       field : "dept_NAME",
                       headerHozAlign:"center",
                       width : 100
                   },
                   {
                       title : "타입",
                       field : "user_TYPE_NAME",
                       hozAlign:"right",
                       headerHozAlign:"center",
                       width : 100
                   },{
                          title : "사용유무",
                          field : "user_USE_STATUS",
                          headerHozAlign:"center",
                          width : 110,
                          headerHozAlign:"center",
                          hozAlign:"center",
                          formatter:"tickCross",
                          editor:"select",
                          editorParams:{values:{}}
                   }, {
                       title : "수정일자",
                       field : "user_MODIFY_D",
                       headerHozAlign:"center",
                       hozAlign :"right",
                       width : 150
                   }, {
                       title : "수정자",
                       field : "user_MODIFIER",
                       headerHozAlign:"center",
                       width : 155
                   }
              ],
          });
        } 
        
        function GridSetting2(userCode)
          {
           $.ajax({
                method: "GET",
                url: "${contextPath}/MenuRest/view.do?MENU_USER_CODE="+userCode,
                success: function (data) {
                   datas = data;
                   
                  table = new Tabulator("#example-table2", { 
                     rowSelectionChanged:function(data, rows){
                          dataList.data = data;
                          console.log(dataList.data);
                      },
                      rowDblClick:function(e, row){
                          //e - the click event object
                          //row - row component
                          //console.log(row.getIndex());
                          //console.log(row.getData().id);
                      },
                      rowUpdated:function(row){
                          alert("수정");
                      },
                     height:"80%",
                      data:datas, 
                      columns:[ 
                      {formatter:"rowSelection", titleFormatter:"rowSelection"},
                      {title:"코드", field:"menu_PROGRAM_CODE",hozAlign:"right",width : 65},
                      {title:"프로그램 명", field:"menu_PROGRAM_NAME",hozAlign:"left",headerHozAlign:"center"}
                      , {
                           title : "읽기",
                           field : "menu_READ_USE_STATUS",
                           headerHozAlign:"center",
                            width : 70,
                            headerHozAlign:"center",
                            hozAlign:"center",
                            formatter:"tickCross",
                            editor:"select",
                            editorParams:{values:{"true":"사용", "false":"미사용"}}
                       }
                      , {
                           title : "쓰기",
                           field : "menu_WRITE_USE_STATUS",
                           headerHozAlign:"center",
                           width : 70,
                            headerHozAlign:"center",
                            hozAlign:"center",
                            formatter:"tickCross",
                            editor:"select",
                            editorParams:{values:{"true":"사용", "false":"미사용"}}
                       }
                      , {
                           title : "삭제",
                           field : "menu_DEL_USE_STATUS",
                           headerHozAlign:"center",
                           width : 70,
                            headerHozAlign:"center",
                            hozAlign:"center",
                            formatter:"tickCross",
                            editor:"select",
                            editorParams:{values:{"true":"사용", "false":"미사용"}}
                       }
                      , {
                           title : "사용유무",
                           field : "menu_MGMT_USE_STATU",
                           headerHozAlign:"center",
                           width : 100,
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
        
        window.onload = function(){
           $.ajax({
                method: "GET",
                url: "${contextPath}/UserRest/view.do",
                success: function (data) {
                   GridSetting1(data);
                   console.log(data);
                   //GridSetting2(data[0].user_CODE);
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