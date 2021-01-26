<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<meta charset="UTF-8">

<%
String PRODUCTION_SERIAL_NUM = request.getParameter("serial");						// 시리얼
String PRODUCTION_INFO_NUM = request.getParameter("sunbun");						// 순번
String PRODUCTION_EQUIPMENT_CODE = request.getParameter("equip_id");				// 설비코드
String PRODUCTION_MOLD_INFO_CODE = request.getParameter("mold_id");					// 금형 no
String PRODUCTION_PRODUCT_CODE = request.getParameter("product_id");				// 제품코드
String PRODUCTION_DEFECT_CODE = request.getParameter("defect_id");					// 불량 정보
String PRODUCTION_VOLUME = request.getParameter("count");							// 생산수량 (양품수량)
String PRODUCTION_BAD = request.getParameter("bad");								// 불량수량
String PRODUCTION_MODIFY_D = request.getParameter("user");							// 수정자
String PRODUCTION_USER_CODE = request.getParameter("user_id");						// 사용자코드
String PRODUCTION_CC = request.getParameter("status");								// 마감상태 : s (계속) 또는 e(끝남)
String sort = request.getParameter("sort");											// 현재 데이터 종류 : p 또는 b

String sql = "";

if(PRODUCTION_CC.equals("S"))
{
	/*
	sql = "INSERT INTO `busience2`.`PRODUCTION_MGMT_TBL`\r\n"
			+ "(`PRODUCTION_SERIAL_NUM`,\r\n"
			+ "`PRODUCTION_INFO_NUM`,\r\n"
			+ "`PRODUCTION_EQUIPMENT_CODE`,\r\n"
			+ "`PRODUCTION_MOLD_INFO_CODE`,\r\n"
			+ "`PRODUCTION_PRODUCT_CODE`,\r\n"
			+ "`PRODUCTION_DEFECT_CODE`,\r\n"
			+ "`PRODUCTION_VOLUME`,\r\n"
			+ "`PRODUCTION_BAD`,\r\n"
			+ "`PRODUCTION_CC`,\r\n"
			+ "`PRODUCTION_USER_CODE`)\r\n"
			+ "VALUES";
	sql += "("
			+ "'" + PRODUCTION_SERIAL_NUM + "',"
			+ "'" + PRODUCTION_INFO_NUM + "',"
			+ "'" + PRODUCTION_EQUIPMENT_CODE + "',"
			+ "'" + PRODUCTION_MOLD_INFO_CODE + "',"
			+ "'" + PRODUCTION_PRODUCT_CODE + "',"
			+ "'" + PRODUCTION_DEFECT_CODE + "',"
			+ "'" + PRODUCTION_VOLUME + "',"
			+ "'" + PRODUCTION_BAD + "',"
			+ "'" + PRODUCTION_CC + "',"
			+ "'" + PRODUCTION_USER_CODE + "'"
			+ ")";
	*/
	if(sort.equals("P"))
	{
		sql = "INSERT INTO `busience2`.`PRODUCTION_MGMT_TBL`\r\n"
				+ "(`PRODUCTION_SERIAL_NUM`,\r\n"
				+ "`PRODUCTION_INFO_NUM`,\r\n"
				+ "`PRODUCTION_EQUIPMENT_CODE`,\r\n"
				+ "`PRODUCTION_MOLD_INFO_CODE`,\r\n"
				+ "`PRODUCTION_PRODUCT_CODE`,\r\n"
				+ "`PRODUCTION_DEFECT_CODE`,\r\n"
				+ "`PRODUCTION_VOLUME`,\r\n"
				+ "`PRODUCTION_BAD`,\r\n"
				+ "`PRODUCTION_CC`,\r\n"
				+ "`PRODUCTION_USER_CODE`)\r\n"
				+ "VALUES";
		sql += "("
				+ "'" + PRODUCTION_SERIAL_NUM + "',"
				+ "'" + PRODUCTION_INFO_NUM + "',"
				+ "'" + PRODUCTION_EQUIPMENT_CODE + "',"
				+ "'" + PRODUCTION_MOLD_INFO_CODE + "',"
				+ "'" + PRODUCTION_PRODUCT_CODE + "',"
				+ "'" + "',"
				+ "'" + PRODUCTION_VOLUME + "',"
				+ "'" + 0 + "',"
				+ "'" + PRODUCTION_CC + "',"
				+ "'" + PRODUCTION_USER_CODE + "'"
				+ ")";
	}
	else
	{
		sql = "INSERT INTO `busience2`.`PRODUCTION_MGMT_TBL`\r\n"
				+ "(`PRODUCTION_SERIAL_NUM`,\r\n"
				+ "`PRODUCTION_INFO_NUM`,\r\n"
				+ "`PRODUCTION_EQUIPMENT_CODE`,\r\n"
				+ "`PRODUCTION_MOLD_INFO_CODE`,\r\n"
				+ "`PRODUCTION_PRODUCT_CODE`,\r\n"
				+ "`PRODUCTION_DEFECT_CODE`,\r\n"
				+ "`PRODUCTION_VOLUME`,\r\n"
				+ "`PRODUCTION_BAD`,\r\n"
				+ "`PRODUCTION_CC`,\r\n"
				+ "`PRODUCTION_USER_CODE`)\r\n"
				+ "VALUES";
		sql += "("
				+ "'" + PRODUCTION_SERIAL_NUM + "',"
				+ "'" + PRODUCTION_INFO_NUM + "',"
				+ "'" + PRODUCTION_EQUIPMENT_CODE + "',"
				+ "'" + PRODUCTION_MOLD_INFO_CODE + "',"
				+ "'" + PRODUCTION_PRODUCT_CODE + "',"
				+ "'" + PRODUCTION_DEFECT_CODE + "',"
				+ "'" + 0 + "',"
				+ "'" + PRODUCTION_BAD + "',"
				+ "'" + PRODUCTION_CC + "',"
				+ "'" + PRODUCTION_USER_CODE + "'"
				+ ")";
	}
}
else
{
	sql = "update PRODUCTION_MGMT_TBL set ";
	sql += "PRODUCTION_CC='"+PRODUCTION_CC+"'";
	sql += " where PRODUCTION_SERIAL_NUM='"+PRODUCTION_SERIAL_NUM+"' and PRODUCTION_INFO_NUM="+PRODUCTION_INFO_NUM;
}

//System.out.println(sql);

//System.out.println(request.getRealPath("/")+"log.txt");

try
{
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://busience2.cafe24.com:3306/busience2","busience2","business12!!");
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.execute();
	pstmt.close();
	con.close();
}
catch(Exception ex)
{
	sql += "\r\n";
	sql += "에러\r\n";
	sql += ex.getMessage()+"\r\n";
}

/*
File file = new File(request.getRealPath("/")+"log.txt");

if(!file.exists())
	file.createNewFile();

BufferedReader br = new BufferedReader(new FileReader(file));
String readLine = null;
String write = "";
while( ( readLine =  br.readLine()) != null ){
    //System.out.println(readLine);
    write += readLine+"\r\n";
}
write += "\r\n";

BufferedWriter writer = new BufferedWriter(new FileWriter(file));

sql += "\r\n";
Calendar cal = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss a");
String datestr = sdf.format(cal.getTime());
sql += datestr;

sql += "\r\n";

write += sql;

writer.write(write);
br.close();
writer.close();
*/

%>