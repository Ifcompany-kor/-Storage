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

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.Common.Controller.HomeController;
import com.Standard.Dto.DTL_TBL;
import com.Standard.Dto.EQUIPMENT_INFO_TBL;

@RestController("EquipmentRestController")
@RequestMapping("EquipmentRest")
public class EquipmentRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value="popup", method=RequestMethod.GET)
	public List<EQUIPMENT_INFO_TBL> popup(@RequestParam(value="EQUIPMENT_INFO_CODE",required=false) String EQUIPMENT_INFO_CODE,
			@RequestParam(value="EQUIPMENT_INFO_NAME",required=false) String EQUIPMENT_INFO_NAME) throws SQLException
	{
		//System.out.println(EQUIPMENT_INFO_CODE);
		//System.out.println(EQUIPMENT_INFO_NAME);
		
		// 설비 정보 관리 list 
		List<EQUIPMENT_INFO_TBL> equipmentList = new ArrayList<EQUIPMENT_INFO_TBL>();
		
		String sql = "SELECT "
				+ "A.*, "
				+ "B.CHILD_TBL_TYPE AS EQUIPMENT_BUSINESS_PLACE_NAME, "
				+ "C.CHILD_TBL_TYPE AS EQUIPMENT_STATUS_NAME "
				+ "FROM EQUIPMENT_INFO_TBL A "
				+ "INNER JOIN DTL_TBL B "
				+ "ON A.EQUIPMENT_BUSINESS_PLACE = B.CHILD_TBL_NUM "
				+ "INNER JOIN DTL_TBL C "
				+ "ON A.EQUIPMENT_STATUS = C.CHILD_TBL_NUM ";
		
		String where = "WHERE B.NEW_TBL_CODE=2 and  C.NEW_TBL_CODE=12 and ";
		where += "EQUIPMENT_INFO_CODE like '%"+EQUIPMENT_INFO_CODE+"%' and ";
		where += "EQUIPMENT_INFO_NAME like '%"+EQUIPMENT_INFO_NAME+"%'";
		
		if(EQUIPMENT_INFO_CODE == null || EQUIPMENT_INFO_CODE == "")
		{
			where = "WHERE B.NEW_TBL_CODE=2 and  C.NEW_TBL_CODE=12 and ";
			where += "EQUIPMENT_INFO_NAME like '%"+EQUIPMENT_INFO_NAME+"%'";
		}
		if(EQUIPMENT_INFO_NAME == null || EQUIPMENT_INFO_NAME == "")
		{
			where = "WHERE B.NEW_TBL_CODE=2 and  C.NEW_TBL_CODE=12 and ";
			where += "EQUIPMENT_INFO_CODE like '%"+EQUIPMENT_INFO_CODE+"%'";
		}
		
		//System.out.println(where);
		
		//String order = " ORDER BY EQUIPMENT_INFO_CODE*1 ASC";
		
		sql += where;
		//sql += order;
		
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next()) {
			EQUIPMENT_INFO_TBL data = new EQUIPMENT_INFO_TBL();
			data.setEQUIPMENT_BUSINESS_PLACE(rs.getString("EQUIPMENT_BUSINESS_PLACE"));
			data.setEQUIPMENT_BUSINESS_PLACE_NAME(rs.getString("EQUIPMENT_BUSINESS_PLACE_NAME"));
			data.setEQUIPMENT_INFO_CODE(rs.getString("EQUIPMENT_INFO_CODE"));
			data.setEQUIPMENT_INFO_NAME(rs.getString("EQUIPMENT_INFO_NAME"));
			data.setEQUIPMENT_INFO_ABR(rs.getString("EQUIPMENT_INFO_ABR"));
			data.setEQUIPMENT_HEIGHT(rs.getFloat("EQUIPMENT_HEIGHT"));
			data.setEQUIPMENT_WIDTH(rs.getFloat("EQUIPMENT_WIDTH"));
			data.setEQUIPMENT_DEPTH(rs.getFloat("EQUIPMENT_DEPTH"));
			data.setEQUIPMENT_SERIAL_NUM(rs.getString("EQUIPMENT_SERIAL_NUM"));
			data.setEQUIPMENT_WEIGHT(rs.getFloat("EQUIPMENT_WEIGHT"));
			data.setEQUIPMENT_RECEIVED_D(rs.getString("EQUIPMENT_RECEIVED_D"));
			data.setEQUIPMENT_MODEL_YEAR(rs.getString("EQUIPMENT_MODEL_YEAR"));
			data.setEQUIPMENT_MANUFACTURER(rs.getString("EQUIPMENT_MANUFACTURER"));
			data.setEQUIPMENT_STATUS(rs.getString("EQUIPMENT_STATUS"));
			data.setEQUIPMENT_STATUS_NAME(rs.getString("EQUIPMENT_STATUS_NAME"));
			data.setEQUIPMENT_INFO_RMARK(rs.getString("EQUIPMENT_INFO_RMARK"));
			data.setEQUIPMENT_USE_STATUS(rs.getString("EQUIPMENT_USE_STATUS"));
			data.setEQUIPMENT_MODIFY_D(rs.getString("EQUIPMENT_MODIFY_D"));
			data.setEQUIPMENT_MODIFIER(rs.getString("EQUIPMENT_MODIFIER"));
			equipmentList.add(data);
			//System.out.println("설비 정보 리스트 : " + data);
		}
		
		return equipmentList;
	}

	@RequestMapping(value = "/insert4.do", method = RequestMethod.POST)
	public String insert4(HttpServletRequest request, EQUIPMENT_INFO_TBL Equipment, Model model)
			throws ParseException, SQLException, UnknownHostException, ClassNotFoundException {
		String data = request.getParameter("data");
		//System.out.println("data값 : " + data);
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(data);
		//System.out.println(obj.toJSONString());

		Connection conn = dataSource.getConnection();
		String checkSql = "select EQUIPMENT_INFO_CODE from EQUIPMENT_INFO_TBL where EQUIPMENT_INFO_CODE='"
				+ obj.get("EQUIPMENT_INFO_CODE") + "'";
		//System.out.println(checkSql);
		PreparedStatement pstmt = conn.prepareStatement(checkSql);
		ResultSet rs = pstmt.executeQuery();

		// 중복체크
		while (rs.next()) {
			String check_EQUIPMENT_INFO_CODE = rs.getString("EQUIPMENT_INFO_CODE");

			if (check_EQUIPMENT_INFO_CODE.length() > 0) {
				return "Overlap";
			}
		}

		HttpSession httpSession = request.getSession();
		String modifier = (String) httpSession.getAttribute("id");

		// 날짜 설정
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String datestr = sdf.format(date.getTime());

		String sql = "insert into EQUIPMENT_INFO_TBL values (";
		sql += "'" + obj.get("EQUIPMENT_BUSINESS_PLACE") + "',";
		sql += "'" + obj.get("EQUIPMENT_INFO_CODE") + "',";
		sql += "'" + obj.get("EQUIPMENT_INFO_NAME") + "',";
		sql += "'" + obj.get("EQUIPMENT_INFO_ABR") + "',";
		sql += "" + obj.get("EQUIPMENT_HEIGHT") + ",";
		sql += "" + obj.get("EQUIPMENT_WIDTH") + ",";
		sql += "" + obj.get("EQUIPMENT_DEPTH") + ",";
		sql += "'" + obj.get("EQUIPMENT_SERIAL_NUM") + "',";
		sql += "" + obj.get("EQUIPMENT_WEIGHT") + ",";
		sql += "'" + obj.get("EQUIPMENT_RECEIVED_D") + "',";
		sql += "'" + obj.get("EQUIPMENT_MODEL_YEAR") + "',";
		sql += "'" + obj.get("EQUIPMENT_MANUFACTURER") + "',";
		sql += "'" + obj.get("EQUIPMENT_STATUS") + "',";
		sql += "'" + obj.get("EQUIPMENT_INFO_RMARK") + "',";
		sql += "'" + obj.get("EQUIPMENT_USE_STATUS") + "',";
		sql += "'" + datestr + "',";
		sql += "'" + modifier + "')";

		System.out.println("삽입 : " + sql);
		
		HomeController.LogInsert("", "1. Insert", sql, request);
		
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();

		rs.close();
		pstmt.close();
		conn.close();

		return "Success";
	}
	// 파일 저장 메소드
	
	  

	// 수정
	@RequestMapping(value = "/update4.do", method = RequestMethod.POST)
	public String update4(HttpServletRequest request, Model model)
			throws SQLException, org.json.simple.parser.ParseException, UnknownHostException, ClassNotFoundException {
		String data = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(data);

		//System.out.println(obj.toJSONString());
		
		HttpSession httpSession = request.getSession();
		String modifier = (String) httpSession.getAttribute("id");

		// 날짜 설정
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String datestr = sdf.format(date.getTime());

		String sql = "UPDATE EQUIPMENT_INFO_TBL set ";
	      sql += "EQUIPMENT_BUSINESS_PLACE = '" + obj.get("EQUIPMENT_BUSINESS_PLACE") + "',";
	      sql += "EQUIPMENT_INFO_CODE = '" + obj.get("EQUIPMENT_INFO_CODE") + "',";
	      sql += "EQUIPMENT_INFO_NAME = '" + obj.get("EQUIPMENT_INFO_NAME") + "',";
	      sql += "EQUIPMENT_INFO_ABR = '" + obj.get("EQUIPMENT_INFO_ABR") + "',";
	      sql += "EQUIPMENT_HEIGHT = " + obj.get("EQUIPMENT_HEIGHT") + ",";
	      sql += "EQUIPMENT_WIDTH = " + obj.get("EQUIPMENT_WIDTH") + ",";
	      sql += "EQUIPMENT_DEPTH = " + obj.get("EQUIPMENT_DEPTH") + ",";
	      sql += "EQUIPMENT_SERIAL_NUM = '" + obj.get("EQUIPMENT_SERIAL_NUM") + "',";
	      sql += "EQUIPMENT_WEIGHT = " + obj.get("EQUIPMENT_WEIGHT") + ",";
	      sql += "EQUIPMENT_RECEIVED_D = '" + obj.get("EQUIPMENT_RECEIVED_D") + "',";
	      sql += "EQUIPMENT_MODEL_YEAR = '" + obj.get("EQUIPMENT_MODEL_YEAR") + "',";
	      sql += "EQUIPMENT_MANUFACTURER = '" + obj.get("EQUIPMENT_MANUFACTURER") + "',";
	      sql += "EQUIPMENT_STATUS = '" + obj.get("EQUIPMENT_STATUS") + "',";
	      sql += "EQUIPMENT_INFO_RMARK = '" + obj.get("EQUIPMENT_INFO_RMARK") + "',";
	      sql += "EQUIPMENT_USE_STATUS = '" + obj.get("EQUIPMENT_USE_STATUS") + "',";
	      sql += "EQUIPMENT_MODIFY_D = '" + datestr + "',";
	      sql += "EQUIPMENT_MODIFIER = '" + modifier + "'";
	      sql += " where EQUIPMENT_INFO_CODE = '" + obj.get("EQUIPMENT_INFO_CODE") + "'";
	   
		System.out.println(sql);
	    HomeController.LogInsert("", "2. Update", sql, request);
	      
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();

		return "Success";
	}

	// 삭제
	@RequestMapping(value = "/delete4.do", method = RequestMethod.POST)
	public String delete2(HttpServletRequest request, Model model) throws SQLException, ParseException, UnknownHostException, ClassNotFoundException {
		String EQUIPMENT_INFO_CODE = request.getParameter("EQUIPMENT_INFO_CODE");

		//System.out.println("EQUIPMENT_INFO_CODE");

		String sql = "delete from EQUIPMENT_INFO_TBL where EQUIPMENT_INFO_CODE='" + EQUIPMENT_INFO_CODE + "'";

		HomeController.LogInsert("", "3. Delete", sql, request);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("에러에러");
			return "error";
		}finally {
			pstmt.close();
			conn.close();
		}

		return EQUIPMENT_INFO_CODE;

	}

}
