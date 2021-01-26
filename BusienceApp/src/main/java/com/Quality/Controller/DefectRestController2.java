package com.Quality.Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Production.Dto.PRODUCTION_INFO_TBL_1;
import com.Standard.Dto.DEFECT_INFO_TBL;

@RestController("DefectRestController2")
@RequestMapping("defectRest2")
public class DefectRestController2 {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_TBL_1> list(HttpServletRequest request) throws ParseException, SQLException
	{
		String data = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(data);
		// System.out.println(obj.toJSONString());
		
		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("id");
		
		String sql = "SELECT \r\n"
				+ "			t1.PRODUCTION_DEFECT_CODE								-- 불량코드\r\n"
				+ "		,   t2.DEFECT_NAME  PRODUCTION_DEFECT_NAME                  -- 불량명\r\n"
				+ "		,	sum(t1.PRODUCTION_BAD) PRODUCTION_DEFECT_CODE_SUM	-- 불량수량\r\n"
				+ "		,	t1.PRODUCTION_PRODUCT_CODE								-- 품목코드\r\n"
				+ "        ,   t3.PRODUCT_ITEM_NAME               					-- 품목명\r\n"
				+ "        ,	t1.PRODUCTION_SERIAL_NUM							-- 시리얼번호\r\n"
				+ " FROM PRODUCTION_MGMT_TBL t1\r\n"
				+ " left outer join DEFECT_INFO_TBL t2 on t1.PRODUCTION_DEFECT_CODE = t2.DEFECT_CODE\r\n"
				+ " left outer join PRODUCT_INFO_TBL t3 on t1.PRODUCTION_PRODUCT_CODE = t3.PRODUCT_ITEM_CODE";
		
		String where = "";
		where = " and PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '" + obj.get("endDate")+" 08:29:59' ";
		where += "and left(PRODUCTION_DEFECT_CODE ,1) ='D'\r\n";
		
		if (obj.get("DEFECT_CODE") != null) {
			if (!obj.get("DEFECT_CODE").equals(""))
				where += " and PRODUCTION_DEFECT_CODE = '" + obj.get("DEFECT_CODE") + "'\r\n";
		}
		
		sql += where;
		
		sql += "group by PRODUCTION_SERIAL_NUM, PRODUCTION_EQUIPMENT_CODE, PRODUCTION_MOLD_INFO_CODE, \r\n"
				+ " PRODUCTION_PRODUCT_CODE,PRODUCTION_USER_CODE, PRODUCTION_DEFECT_CODE";
		
		//System.out.println("-쿼리로그");
		//System.out.println(sql);
		//System.out.println("-쿼리로그");
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		List<PRODUCTION_INFO_TBL_1> list = new ArrayList<PRODUCTION_INFO_TBL_1>();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while (rs.next()) {
			PRODUCTION_INFO_TBL_1 datain = new PRODUCTION_INFO_TBL_1();
			datain.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
			datain.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
			datain.setPRODUCTION_DEFECT_NAME(rs.getString("PRODUCTION_DEFECT_NAME"));
			datain.setPRODUCTION_DEFECT_CODE_SUM(rs.getString("PRODUCTION_DEFECT_CODE_SUM"));
			datain.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
			datain.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
			//System.out.println(datain.toString());
			list.add(datain);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
	}
}
