package com.Standard.Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Production.Dto.PRODUCTION_INFO_;

@RestController("PhistoryRestController")
@RequestMapping("PhistoryRest")
public class PhistoryRestController {

	@Autowired
	SimpleDriverDataSource dataSource;

	// 수정
	@RequestMapping(value = "/update4.do", method = RequestMethod.POST)
	public String update4(HttpServletRequest request, Model model)
			throws SQLException, org.json.simple.parser.ParseException {
		String data = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(data);
		
		//페이지의 불량코드 수집
		String sql = "select * from DEFECT_INFO_TBL where DEFECT_CODE='"+obj.get("PRODUCTION_DEFECT_CODE")+"'";
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		//해당 불량코드에 맞는 불량명 수집
		String DEFECT_NAME_Check = "";
		while(rs.next()) {
			DEFECT_NAME_Check = rs.getString("DEFECT_NAME");
		}
		
		//수집한 불량명과 페이지의 불량명 체크
		if(!DEFECT_NAME_Check.equals(obj.get("PRODUCTION_DEFECT_NAME"))) {
			return "CodeCheck";
		}
		
		sql = " UPDATE PRODUCTION_MGMT_TBL"
				+ " SET PRODUCTION_DEFECT_CODE='" + obj.get("PRODUCTION_DEFECT_CODE") + "',"
				+ " PRODUCTION_BAD=" + obj.get("PRODUCTION_B_Qty")
				+ " WHERE PRODUCTION_SERIAL_NUM='" + obj.get("PRODUCTION_SERIAL_NUM") + "'"
				+ " and PRODUCTION_INFO_NUM=" + obj.get("PRODUCTION_INFO_NUM");

		//System.out.println(sql);

		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();

		return "Success";
	}

	// 삭제
	@RequestMapping(value = "/delete4.do", method = RequestMethod.POST)
	public String delete4(HttpServletRequest request, Model model)
			throws SQLException, org.json.simple.parser.ParseException {
		String data = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(data);

		//System.out.println("시리얼번호 =" +obj.get("PRODUCTION_SERIAL_NUM"));
		//System.out.println("숫자 =" +obj.get("PRODUCTION_INFO_NUM"));
		String sql = " DELETE FROM PRODUCTION_MGMT_TBL"
				+ " WHERE PRODUCTION_SERIAL_NUM='" + obj.get("PRODUCTION_SERIAL_NUM") + "'"
				+ " and PRODUCTION_INFO_NUM=" + obj.get("PRODUCTION_INFO_NUM");

		System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();

		return "Success";
	}
	
	//검색
	@RequestMapping(value = "/PhistoryEquipment", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_> pviewSearch(HttpServletRequest request)
			throws ParseException, SQLException, org.json.simple.parser.ParseException {
		String originData = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(originData);
		//System.out.println(obj.toJSONString());
		
		String sql = "SELECT \r\n"
				+ " C.PRODUCTION_SERIAL_NUM, \r\n"
				+ " C.PRODUCTION_INFO_NUM, \r\n"
				+ " C.PRODUCTION_EQUIPMENT_CODE, \r\n"
				+ " F.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
				+ " C.PRODUCTION_VOLUME, \r\n"
				+ " C.PRODUCTION_DEFECT_CODE,\r\n"
				+ " I.DEFECT_NAME,\r\n"
				+ " C.PRODUCTION_BAD, \r\n"
				+ " C.PRODUCTION_PRODUCT_CODE, \r\n"
				+ " E.PRODUCT_ITEM_NAME PRODUCT_ITEM_NAME, \r\n"
				+ " C.PRODUCTION_MOLD_INFO_CODE, \r\n"
				+ " G.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n"
				+ " C.PRODUCTION_USER_CODE PRODUCTION_USER_CODE,\r\n"
				+ " H.USER_NAME PRODUCTION_USER_NAME,\r\n"
				+ " C.PRODUCTION_MODIFY_D, \r\n"
				+ " C.PRODUCTION_CC \r\n"
				+ " FROM PRODUCTION_MGMT_TBL AS C\r\n"
				+ " inner join PRODUCT_INFO_TBL E ON C.PRODUCTION_PRODUCT_CODE = E.PRODUCT_ITEM_CODE \r\n"
				+ " inner join EQUIPMENT_INFO_TBL F ON C.PRODUCTION_EQUIPMENT_CODE = F.EQUIPMENT_INFO_CODE\r\n"
				+ " inner join MOLD_INFO_TBL G ON C.PRODUCTION_MOLD_INFO_CODE = G.MOLD_INFO_NO\r\n"
				+ " inner join USER_INFO_TBL H ON C.PRODUCTION_USER_CODE = H.USER_CODE\r\n"
				+ " inner join DEFECT_INFO_TBL I ON C.PRODUCTION_DEFECT_CODE = I.DEFECT_CODE\r\n";

		String where = " and PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '" + obj.get("endDate")+" 08:29:59'";
		
		//제품코드 검색
		if (obj.get("PRODUCT_ITEM_CODE") != null && !obj.get("PRODUCT_ITEM_CODE").equals("")) {
			where += " and PRODUCTION_PRODUCT_CODE like '%" + obj.get("PRODUCT_ITEM_CODE") + "%'"
					+ " and PRODUCT_ITEM_NAME like '%" + obj.get("PRODUCT_ITEM_NAME") + "%'";
		}
		//제품명 검색
		else {
			where += " and (PRODUCT_ITEM_NAME like '%" + obj.get("PRODUCT_ITEM_NAME") + "%'"
					+ " OR PRODUCTION_PRODUCT_CODE like '%" + obj.get("PRODUCT_ITEM_NAME") + "%')";
		}
		//설비코드 검색
		if (obj.get("EQUIPMENT_INFO_CODE") != null && !obj.get("EQUIPMENT_INFO_CODE").equals("")) {
			where += " and PRODUCTION_EQUIPMENT_CODE like '%" + obj.get("EQUIPMENT_INFO_CODE") + "%'"
					+ " and EQUIPMENT_INFO_NAME like '%" + obj.get("EQUIPMENT_INFO_NAME") + "%'";
		}
		//설비명 검색
		else {
			where += " and (EQUIPMENT_INFO_NAME like '%" + obj.get("EQUIPMENT_INFO_NAME") + "%'"
					+ " OR PRODUCTION_EQUIPMENT_CODE like '%" + obj.get("EQUIPMENT_INFO_NAME") + "%')";
		}	
		sql += where;

		sql += " order by PRODUCT_ITEM_CODE, PRODUCTION_SERIAL_NUM, PRODUCTION_INFO_NUM";

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		//System.out.println(sql);
		int i = 0;
		List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

		while (rs.next()) {
			if(rs.getInt("PRODUCTION_BAD") != 0) {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
				data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_VOLUME")); // 생산수량
				data1.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
				data1.setPRODUCTION_DEFECT_NAME(rs.getString("DEFECT_NAME"));
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
				data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
				data1.setPRODUCTION_MOLD_INFO_CODE(rs.getString("PRODUCTION_MOLD_INFO_CODE"));
				data1.setPRODUCTION_MOLD_INFO_NAME(rs.getString("PRODUCTION_MOLD_INFO_NAME"));
				data1.setPRODUCTION_USER_NAME(rs.getString("PRODUCTION_USER_NAME"));
				data1.setPRODUCTION_USER_CODE(rs.getString("PRODUCTION_USER_CODE"));
				data1.setPRODUCTION_CC(rs.getString("PRODUCTION_CC"));
				data1.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D"));
				list.add(data1);
			} else {
			}
		}

		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
}

