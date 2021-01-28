<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!doctype html>
<html lang="en">

<head>
<title>Dashboard | Klorofil - Free Bootstrap Dashboard Template</title>
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
		<jsp:include page="navbar.jsp"></jsp:include>
		<!-- END NAVBAR -->
		<!-- LEFT SIDEBAR -->
		<jsp:include page="sidebar.jsp"></jsp:include>
		<!-- END LEFT SIDEBAR -->
		<!-- MAIN -->
		<div class="main">
			<!-- MAIN CONTENT -->
			<div class="main-content">
				<div class="container-fluid">
					<div class="col-md-12" style="margin: 0px; padding: 0px;">
						<div class="panel" style="margin: 0px; padding: 0px;">
							<div class="panel-heading">
								<h3 class="panel-title">발주 관리</h3>
								<div class="right">
									<button type="button"
										style="font-size: 13px; font-family: 'Noto Sans KR', sans-serif;"
										class="btn btn-default btn-sm">
										<span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
										입력
									</button>

									<button onclick="newBtn()" type="button"
										style="font-size: 13px; font-family: 'Noto Sans KR', sans-serif;"
										class="btn btn-default btn-sm">
										<span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> 
										수정
									</button>

									<button type="button"
										style="font-size: 13px; font-family: 'Noto Sans KR', sans-serif;"
										class="btn btn-default btn-sm" data-toggle="modal"
										data-target="#exampleModalCenter">
										<span class="glyphicon glyphicon-paste" aria-hidden="true"></span>
										삭제
									</button>
									<button type="button" class="btn-toggle-collapse"><i class="lnr lnr-chevron-up"></i></button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="container-fluid">
					<div class="col-md-12" style="margin: 0px; padding: 0px;">
						<div class="panel" style="margin: 0px; padding: 0px;">
							<div class="panel-body">
								<div id="example-table1"></div>
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
	<script src="${contextPath}/resources/assets/vendor/jquery.easy-pie-chart/jquery.easypiechart.min.js"></script>
	<script src="${contextPath}/resources/assets/vendor/chartist/js/chartist.min.js"></script>
	<script src="${contextPath}/resources/assets/scripts/klorofil-common.js"></script>

	<script type="text/javascript">
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
	        height:1000,
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

	table = new Tabulator("#example-table2", { 
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
	        height:1000,
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
	</script>

	<script>
	$(function() {
		var data, options;

		// headline charts
		data = {
			labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
			series: [
				[23, 29, 24, 40, 25, 24, 35],
				[14, 25, 18, 34, 29, 38, 44],
			]
		};

		options = {
			height: 300,
			showArea: true,
			showLine: false,
			showPoint: false,
			fullWidth: true,
			axisX: {
				showGrid: false
			},
			lineSmooth: false,
		};

		new Chartist.Line('#headline-chart', data, options);


		// visits trend charts
		data = {
			labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
			series: [{
				name: 'series-real',
				data: [200, 380, 350, 320, 410, 450, 570, 400, 555, 620, 750, 900],
			}, {
				name: 'series-projection',
				data: [240, 350, 360, 380, 400, 450, 480, 523, 555, 600, 700, 800],
			}]
		};

		options = {
			fullWidth: true,
			lineSmooth: false,
			height: "270px",
			low: 0,
			high: 'auto',
			series: {
				'series-projection': {
					showArea: true,
					showPoint: false,
					showLine: false
				},
			},
			axisX: {
				showGrid: false,

			},
			axisY: {
				showGrid: false,
				onlyInteger: true,
				offset: 0,
			},
			chartPadding: {
				left: 20,
				right: 20
			}
		};

		new Chartist.Line('#visits-trends-chart', data, options);


		// visits chart
		data = {
			labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
			series: [
				[6384, 6342, 5437, 2764, 3958, 5068, 7654]
			]
		};

		options = {
			height: 300,
			axisX: {
				showGrid: false
			},
		};

		new Chartist.Bar('#visits-chart', data, options);


		// real-time pie chart
		var sysLoad = $('#system-load').easyPieChart({
			size: 130,
			barColor: function(percent) {
				return "rgb(" + Math.round(200 * percent / 100) + ", " + Math.round(200 * (1.1 - percent / 100)) + ", 0)";
			},
			trackColor: 'rgba(245, 245, 245, 0.8)',
			scaleColor: false,
			lineWidth: 5,
			lineCap: "square",
			animate: 800
		});

		var updateInterval = 3000; // in milliseconds

		setInterval(function() {
			var randomVal;
			randomVal = getRandomInt(0, 100);

			sysLoad.data('easyPieChart').update(randomVal);
			sysLoad.find('.percent').text(randomVal);
		}, updateInterval);

		function getRandomInt(min, max) {
			return Math.floor(Math.random() * (max - min + 1)) + min;
		}

	});
	</script>
</body>

</html>