package com.Standard.Controller;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Common.Controller.HomeController;
import com.Standard.Dto.USER_INFO_TBL;
import com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException;

@RestController("UserRestController")
@RequestMapping("UserRest")
public class UserRestController {

	@Autowired
	SimpleDriverDataSource dataSource;

	@RequestMapping(value = "/view.do", method = RequestMethod.GET)
	public List<USER_INFO_TBL> view(HttpServletRequest request) throws SQLException {
		List<USER_INFO_TBL> list = new ArrayList<USER_INFO_TBL>();

		String sql = "select \r\n" + "			t1.USER_CODE\r\n" + "		,	t1.USER_PASSWORD\r\n"
				+ "        ,	t1.USER_NAME\r\n" + "        ,	t1.USER_TYPE\r\n"
				+ "		,	t2.CHILD_TBL_TYPE 'user_TYPE_NAME'\r\n" + "        ,	t1.COMPANY\r\n"
				+ "        ,	t3.CHILD_TBL_TYPE 'company_NAME'\r\n" + "        ,	t1.DEPT_CODE\r\n"
				+ "        ,	t4.CHILD_TBL_TYPE 'dept_NAME'\r\n" + "        ,	t1.USER_MODIFIER\r\n"
				+ "        ,	t1.USER_MODIFY_D\r\n" + "         ,	t1.USER_USE_STATUS\r\n"
				+ "from USER_INFO_TBL t1 \r\n" + "left outer join \r\n" + "(\r\n" + "	select\r\n" + "			*\r\n"
				+ "	from\r\n" + "			DTL_TBL\r\n" + "	where 	NEW_TBL_CODE = '1'\r\n" + ") t2\r\n"
				+ "on t1.USER_TYPE = t2.CHILD_TBL_NUM\r\n" + "left outer join \r\n" + "(\r\n" + "	select\r\n"
				+ "			*\r\n" + "	from\r\n" + "			DTL_TBL\r\n" + "	where 	NEW_TBL_CODE = '2'\r\n"
				+ ") t3\r\n" + "on t1.COMPANY = t3.CHILD_TBL_NUM\r\n" + "left outer join \r\n" + "(\r\n"
				+ "	select\r\n" + "			*\r\n" + "	from\r\n" + "			DTL_TBL\r\n"
				+ "	where 	NEW_TBL_CODE = '3'\r\n" + ") t4\r\n" + "on t1.DEPT_CODE = t4.CHILD_TBL_NUM";

		// request.getParameter("");

		int i = 0;

		//System.out.println(request.getParameter("USER_CODE"));
		//System.out.println(request.getParameter("USER_NAME"));

		String where = "";
		
		if (request.getParameter("USER_CODE") != "" && request.getParameter("USER_NAME") == "")
			where = " where t1.USER_CODE like '%" + request.getParameter("USER_CODE") + "%'";

		if (request.getParameter("USER_CODE") == "" && request.getParameter("USER_NAME") != "")
			where = " where t1.USER_NAME like '%" + request.getParameter("USER_NAME") + "%'";

		if (request.getParameter("USER_CODE") == "" && request.getParameter("USER_NAME") == "")
			where = " where t1.USER_CODE like '%" + request.getParameter("USER_CODE") + "%'"
					+ " AND t1.USER_NAME like '%" + request.getParameter("USER_NAME") + "%'";
		
		//if (request.getParameter("USER_NAME") != "")
			//sql += " where t1.USER_NAME like '%" + request.getParameter("USER_NAME") + "%'";
		if (request.getParameter("USER_NAME") != null)
		{
			if (request.getParameter("USER_NAME") != "")
				sql += " where t1.USER_NAME like '%" + request.getParameter("USER_NAME") + "%'";
		}
		if (request.getParameter("USER_CODE") == null)
			where = "";
		
		sql += where;
		
		//System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			USER_INFO_TBL data = new USER_INFO_TBL();
			data.setUSER_CODE(rs.getString("user_CODE"));
			data.setDEPT_CODE(rs.getString("dept_CODE"));
			data.setUSER_USE_STATUS(rs.getString("user_USE_STATUS"));
			data.setCOMPANY(rs.getString("company"));
			data.setUSER_TYPE(rs.getString("user_TYPE"));
			data.setUSER_MODIFY_D(rs.getString("user_MODIFY_D"));
			data.setUSER_NAME(rs.getString("user_NAME"));
			data.setUSER_PASSWORD(rs.getString("user_PASSWORD"));
			data.setUSER_TYPE_NAME(rs.getString("user_TYPE_NAME"));
			data.setUSER_MODIFIER(rs.getString("user_MODIFIER"));
			data.setCOMPANY_NAME(rs.getString("company_NAME"));
			data.setDEPT_NAME(rs.getString("dept_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 삽입
	@RequestMapping(value = "/insert2.do", method = RequestMethod.POST)
	public String insert2(HttpServletRequest request, Model model) throws SQLException, ParseException, UnknownHostException, ClassNotFoundException {
		String data = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(data);

		//System.out.println(obj.toJSONString());
		HttpSession httpSession = request.getSession();
		String modifier = (String) httpSession.getAttribute("id");

		Connection conn = dataSource.getConnection();
		String checkSql = "select USER_CODE from USER_INFO_TBL where USER_CODE='" + obj.get("USER_CODE") + "'";
		PreparedStatement pstmt = conn.prepareStatement(checkSql);
		ResultSet rs = pstmt.executeQuery();

		// 중복체크
		while (rs.next()) {
			String check_DEFECT_CODE = rs.getString("USER_CODE");

			if (check_DEFECT_CODE.length() > 0) {
				return "Overlap";
			}
		}
		// 날짜 설정
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String datestr = sdf.format(date.getTime());

		String sql = "";
		sql = "insert into USER_INFO_TBL values (";
		sql += "'" + obj.get("USER_CODE") + "',";
		sql += "hex(aes_encrypt('1234','a')),";
		sql += "'" + obj.get("USER_NAME") + "',";
		sql += "'" + obj.get("USER_TYPE") + "',";
		sql += "'" + obj.get("COMPANY") + "',";
		sql += "'" + obj.get("DEPT_CODE") + "',";
		sql += "'" + modifier + "',";
		sql += "'" + datestr + "',";
		sql += "'" + obj.get("USER_USE_STATUS") + "')";

		//System.out.println(sql);

		HomeController.LogInsert("", "1. Insert", sql, request);
		
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();

		sql = "";
		sql += "INSERT INTO MENU_MGMT_TBL";
		sql += " SELECT T1.USER_CODE, T3.RIGHTS_PROGRAM_CODE, 'true', 'true', 'true', T3.RIGHTS_MGMT_USE_STATUS   FROM USER_INFO_TBL T1";
		sql += " INNER JOIN RIGHTS_MGMT_TBL T3 ON T1.USER_TYPE = T3.RIGHTS_USER_TYPE";
		sql += " WHERE USER_CODE = '" + obj.get("USER_CODE") + "'";

		//System.out.println("사용자 메뉴 삽입 : " + sql);

		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		// 사용자 정보 관리에 있는 것을 조회해서 메뉴 관리에 값을 INSERT 해 준다.
		rs.close();
		pstmt.close();
		conn.close();

		return "Success";
	}

	// 수정
	@RequestMapping(value = "/update2.do", method = RequestMethod.POST)
	public String update2(HttpServletRequest request, Model model) throws SQLException, ParseException, UnknownHostException, ClassNotFoundException {
		String data = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(data);

		System.out.println(obj.toJSONString());
		// 특정 USER_CODE에 대한 정보 조회
		String sql = "SELECT USER_TYPE FROM USER_INFO_TBL where USER_CODE='" + obj.get("USER_CODE") + "'";
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		while (rs.next()) {
			//System.out.println(obj.get("USER_TYPE"));
			//System.out.println(rs.getString("USER_TYPE"));
			// 메뉴 관리 USER_TYPE과 사용자 관리 정보의 USER_TYPE이 동일하지 않다면, 메뉴 관리의 USER 정보 삭제
			// 이후 이름과 권한 정보 삽입
			if (!obj.get("USER_TYPE").equals(rs.getString("USER_TYPE"))) {
				sql = "delete from MENU_MGMT_TBL where MENU_USER_CODE='" + obj.get("USER_CODE") + "'";
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();

				sql = "INSERT INTO MENU_MGMT_TBL";
				sql += " SELECT T1.USER_CODE, T3.RIGHTS_PROGRAM_CODE, 'true', 'true', 'true', T3.RIGHTS_MGMT_USE_STATUS   FROM USER_INFO_TBL T1";
				sql += " INNER JOIN RIGHTS_MGMT_TBL T3 ON T1.USER_TYPE = T3.RIGHTS_USER_TYPE";
				sql += " WHERE USER_CODE = '" + obj.get("USER_CODE") + "'";

				//System.out.println("사용자 메뉴 삽입 : " + sql);

				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
			}
		}

		// 날짜 설정
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String datestr1 = sdf.format(date.getTime());

		HttpSession httpSession = request.getSession();
		String modifier = (String) httpSession.getAttribute("id");
		
		sql = "update USER_INFO_TBL set ";
		sql += "USER_NAME='" + obj.get("USER_NAME") + "'";
		sql += ",COMPANY='" + obj.get("COMPANY") + "'";
		sql += ",USER_TYPE='" + obj.get("USER_TYPE") + "'";
		sql += ",USER_MODIFIER='" + modifier + "'";
		sql += ",USER_USE_STATUS='" + obj.get("USER_USE_STATUS") + "'";
		sql += ",DEPT_CODE='" + obj.get("DEPT_CODE") + "'";
		sql += ",USER_MODIFY_D='" + datestr1 + "'";
		sql += " where USER_CODE='" + obj.get("USER_CODE") + "'";

		//System.out.println(sql);

		HomeController.LogInsert("", "2. Update", sql, request);
		
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		rs.close();
		pstmt.close();
		conn.close();

		return "Success";
	}

	@RequestMapping(value = "/delete2.do", method = RequestMethod.POST)
	public String delete2(HttpServletRequest request, Model model) throws SQLException, UnknownHostException, ClassNotFoundException {
		String USER_CODE = request.getParameter("USER_CODE");

		//System.out.println(USER_CODE);
		
		String sql = "delete from MENU_MGMT_TBL where MENU_USER_CODE = '"+USER_CODE+"'";

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		
		sql = "delete from USER_INFO_TBL where USER_CODE='" + USER_CODE + "'";

		HomeController.LogInsert("", "3. Delete", sql, request);
		
		/*
		try
		{
			Connection conn = dataSource.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
		}
		catch(Exception ex)
		{
			return "Fail";
		}
		*/
		
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
		
		return USER_CODE;
	}

	@RequestMapping(value = "/pwReset2.do", method = RequestMethod.POST)
	public String pwReset2(HttpServletRequest request, Model model) throws SQLException, UnknownHostException, ClassNotFoundException {
		String USER_CODE = request.getParameter("USER_CODE");

		//System.out.println(USER_CODE);

		String sql = "update USER_INFO_TBL set ";
		sql += "USER_PASSWORD=hex(aes_encrypt('1234','a'))";
		sql += " where USER_CODE='" + USER_CODE + "'";

		HomeController.LogInsert("", "7. Pw Reset", sql, request);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();

		return USER_CODE;
	}
}
