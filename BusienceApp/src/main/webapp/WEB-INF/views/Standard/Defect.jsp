<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!doctype html>
<html lang="en">

<head>
<title>비지언스 MES</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
<!-- VENDOR CSS -->
<link rel="stylesheet"
	href="${contextPath}/resources/assets/vendor/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"
	href="${contextPath}/resources/assets/vendor/font-awesome/css/font-awesome.min.css">
<link rel="stylesheet"
	href="${contextPath}/resources/assets/vendor/linearicons/style.css">
<link rel="stylesheet"
	href="${contextPath}/resources/assets/vendor/chartist/css/chartist-custom.css">
<!-- MAIN CSS -->
<link rel="stylesheet"
	href="${contextPath}/resources/assets/css/main.css">
<!-- FOR DEMO PURPOSES ONLY. You should remove this in your project -->
<link rel="stylesheet"
	href="${contextPath}/resources/assets/css/demo.css">
<!-- GOOGLE FONTS -->
<link
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700"
	rel="stylesheet">
<!-- ICONS -->
<link rel="apple-touch-icon" sizes="76x76"
	href="${contextPath}/resources/assets/img/apple-icon.png">
<link rel="icon" type="image/png" sizes="96x96"
	href="${contextPath}/resources/assets/img/favicon.png">
<link
	href="https://unpkg.com/tabulator-tables@4.8.4/dist/css/tabulator.min.css"
	rel="stylesheet">
<script type="text/javascript"
	src="https://unpkg.com/tabulator-tables@4.8.4/dist/js/tabulator.min.js"></script>
</head>

<body>

	<!-- Modal -->
	<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true" style="margin-top: 180px;">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLongTitle">확인창</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<p>해당 데이터를 삭제하시겠습니까?</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">네</button>
					<button type="button" class="btn btn-primary">아니오</button>
				</div>
			</div>
		</div>
	</div>

	<!-- WRAPPER -->
	<div id="wrapper">
		<!-- NAVBAR -->
		<jsp:include page="../navbar.jsp"></jsp:include>
		<!-- END NAVBAR -->
		<!-- LEFT SIDEBAR -->
		<jsp:include page="../sidebar.jsp"></jsp:include>
		<!-- END LEFT SIDEBAR -->
		<!-- MAIN -->
		<div class="main">
			<!-- MAIN CONTENT -->
			<div class="main-content">
				<div class="container-fluid">
					<div class="col-md-12" style="margin: 0px; padding: 0px;">
						<div class="panel" style="margin: 0px; padding: 0px;">
							<div class="panel-heading">
								<h3 class="panel-title">불량 정보 관리</h3>
								<div class="right">
									<button type="button"
										style="font-size: 13px; font-family: 'Noto Sans KR', sans-serif;"
										class="btn btn-default btn-sm">
										<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
										입력
									</button>

									<button type="button"
										style="font-size: 13px; font-family: 'Noto Sans KR', sans-serif;"
										class="btn btn-default btn-sm" onclick="updateBtn()">
										<span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> 
										수정
									</button>

									<button type="button"
										style="font-size: 13px; font-family: 'Noto Sans KR', sans-serif;"
										class="btn btn-default btn-sm" onclick="deleteBtn()">
										<span class="glyphicon glyphicon-paste" aria-hidden="true"></span>
										삭제
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="container-fluid">
					<div class="col-md-12" style="margin: 0px; padding: 0px;">
						<div class="panel" style="margin: 0px; padding: 0px;">
							<div class="panel-body">
								<div id="example-table"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- END MAIN CONTENT -->
		</div>
		<!-- END MAIN -->
		<div class="clearfix"></div>
		<footer>
			<div class="container-fluid">
				<p class="copyright">
					&copy; 2017 <a href="https://www.themeineed.com" target="_blank">Theme
						I Need</a>. All Rights Reserved.
				</p>
			</div>
		</footer>
	</div>
	<!-- END WRAPPER -->
	<!-- Javascript -->
	<script src="${contextPath}/resources/assets/vendor/jquery/jquery.min.js"></script>
	<script src="${contextPath}/resources/assets/vendor/bootstrap/js/bootstrap.min.js"></script>
	<script src="${contextPath}/resources/assets/vendor/jquery-slimscroll/jquery.slimscroll.min.js"></script>
	<script src="${contextPath}/resources/assets/scripts/klorofil-common.js"></script>

	<script type="text/javascript">
	var table = null;
	
	//커스텀 기능설정
	var inputEditor = function(cell, onRendered, success, cancel, editorParams){
	    //cell - 편집 가능한 셀의 셀 구성 요소
	    //onRendered - 에디터가 렌더링 되었을 때 호출 할 함수
	    //success - 성공적을 업데이트 된 값을 tabulator에 전달하기 위해 호출되는 함수
	    //cancel - 편집을 중단하고 일반 셀로 돌아 가기 위해 호출하는 함수
	    //editorParams - editorParams 열 정의 속성에 전달 된 params 객체

	    //create 및 style editor
	    var input = document.createElement("input");

	    input.setAttribute("type", "text");

	    //입력 생성 및 스타일 지정
	    input.style.padding = "3px";
	    input.style.width = "100%";
	    input.style.boxSizing = "border-box";

	    //편집기의 값을 셀의 현재 값으로 설정
		if(cell.getValue() == undefined){
			input.value = "";
		}else{
			input.value = cell.getValue();
		}

	    //에디터가 선택되면 선택 상자에 포커스 설정 (타임 아웃은 편집기를 DOM에 추가 할 수 있음)
	    onRendered(function(){
	        input.focus();
	        input.style.css = "100%";
	    });

	    //값이 설정되면 업데이트 할 셀 트리거
	    function onChange(){
	        success(input.value);
	    }
	    
		//바꼈을때 블러됫을때 함수 발동
	    input.addEventListener("change", onChange);
	    input.addEventListener("blur", onChange);

	    //키버튼 이벤트
	    input.addEventListener("keydown", function (e){
	    	//console.log(e.keyCode);
	    	if(e.keyCode == 13){
	    		if(cell.getField() != "defect_RMRKS")
	    			cell.nav().next();
	    		else
	    			table.addRow();
	    	}
	    });
	    //반환
	    return input;
	};

	
    window.onload = function() {
    	var datas = "";
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
	                 	height:"500",
        		     	//height:730, // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
        		     	data:datas, //assign data to table
        		     	columns:[ //Define Table Columns
        		     	{formatter:"rowSelection", titleFormatter:"rowSelection", headerHozAlign:"center", hozAlign:"center", headerSort:false, width:40},
        		     	{title:"번호", field:"id", hozAlign:"center",headerHozAlign:"center",width : 80},
        		    	{title:"불량코드", field:"defect_CODE", width:100,headerHozAlign:"center", headerFilter:"input"},
        		    	{title:"불량명", field:"defect_NAME", width:200,headerHozAlign:"center", headerFilter:"input", editor:inputEditor},
        		    	{title:"약자", field:"defect_ABR", width:100,headerHozAlign:"center", headerFilter:"input", editor:inputEditor},
        		    	{title:"비고", field:"defect_RMRKS", width:200,headerHozAlign:"center", headerFilter:"input", editor:inputEditor},
        		    	{title:"사용유무", field:"defect_USE_STATUS", width:100,headerHozAlign:"center",hozAlign:"center", formatter:"tickCross",editor:"select", editorParams:{values:{"true":"사용", "false":"미사용"}}, headerFilter:true, headerFilterParams:{values:{"true":"사용", "false":"미사용"}}},
        		    	{title:"수정일자", field:"defect_MODIFY_D", width:150,headerHozAlign:"center",hozAlign:"right",sorter:"date",  headerFilter:"input"},
        		    	{title:"수정자", field:"defect_MODIFIER", width:150,headerHozAlign:"center", headerFilter:"input"}
        		     	],
        		    });
                }
        });
    }
    
    function deleteBtn(){
    	conf =  confirm("삭제 하시겠습니까?");
        if(!conf)
           return;
    	
    	var selectedData = table.getSelectedData();
    	//console.log(selectedData);
    	
    	jQuery.map(selectedData, function(value, index) {
    		console.log(value.defect_CODE);
    		
    		//행삭제
    		table.deleteRow(value.id);
    		
    		$.ajax({
	              method: "POST",
	              data : null,
	              url: "${contextPath}/defectRest/delete.do?DEFECT_CODE="+value.defect_CODE,
	              success: function (data,testStatus) {
	              }
	        });
    	});
    	
    	location.reload();
    }
    
    function updateBtn(){
    	conf =  confirm("수정 하시겠습니까?");
        if(!conf)
           return;
        
        var selectedData = table.getSelectedData();
        
    	jQuery.map(selectedData, function(value, index) {
    		console.log(value);
    		
    		$.ajax({
	              method: "POST",
	              data : {
	            	  DEFECT_CODE : value.defect_CODE,
	            	  DEFECT_NAME : value.defect_NAME,
	            	  DEFECT_ABR : value.defect_ABR,
	            	  DEFECT_RMRKS : value.defect_RMRKS,
	            	  DEFECT_USE_STATUS : value.defect_USE_STATUS
	              },
	              url: "${contextPath}/defectRest/update.do",
	              success: function (data,testStatus) {
	              }
	        });
    	});
    	
    	location.reload();
    }
	</script>
</body>

</html>