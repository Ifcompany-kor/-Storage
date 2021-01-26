package com.Production.Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Production.Dto.PRODUCTION_INFO_;
import com.Production.Dto.PRODUCTION_INFO_YEAR;

@RestController("PerformanceRestController")
@RequestMapping("PerformanceRest")
public class PerformanceRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	private Object PRODUCTION_INFO_NUM;

	// 설비별
	@RequestMapping(value = "/PerformanceEquipment", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_> PerformanceEquipment(HttpServletRequest request)
			throws ParseException, SQLException, org.json.simple.parser.ParseException {
		String originData = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(originData);
		// system.out.println(obj.toJSONString());

		String sql = "SELECT \r\n" + " C.PRODUCTION_SERIAL_NUM, \r\n" + " C.PRODUCTION_INFO_NUM, \r\n"
				+ " C.PRODUCTION_EQUIPMENT_CODE, \r\n" + " F.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
				+ " sum(C.PRODUCTION_VOLUME) PRODUCTION_P_Qty, \r\n"
				+ " (case when C.PRODUCTION_DEFECT_CODE = '' then sum(C.PRODUCTION_VOLUME)-sum(C.PRODUCTION_BAD) else 0 end) PRODUCTION_PRODUCTS_VOLUME,\r\n"
				+ " C.PRODUCTION_DEFECT_CODE,\r\n" + " sum(C.PRODUCTION_BAD) PRODUCTION_BAD, \r\n"
				+ " round(sum(C.PRODUCTION_BAD) / sum(C.PRODUCTION_VOLUME)* 100,2) PRODUCTION_DEFECT_RATE, \r\n"
				+ " C.PRODUCTION_PRODUCT_CODE, \r\n" + " E.PRODUCT_ITEM_NAME PRODUCT_ITEM_NAME, \r\n"
				+ " C.PRODUCTION_MOLD_INFO_CODE, \r\n" + " G.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n"
				+ " C.PRODUCTION_USER_CODE,\r\n" + " H.USER_NAME PRODUCTION_USER_NAME,\r\n"
				+ " C.PRODUCTION_MODIFY_D \r\n" + " FROM PRODUCTION_MGMT_TBL AS C\r\n"
				+ " inner join PRODUCT_INFO_TBL E ON C.PRODUCTION_PRODUCT_CODE = E.PRODUCT_ITEM_CODE \r\n"
				+ " inner join EQUIPMENT_INFO_TBL F ON C.PRODUCTION_EQUIPMENT_CODE = F.EQUIPMENT_INFO_CODE\r\n"
				+ " inner join MOLD_INFO_TBL G ON C.PRODUCTION_MOLD_INFO_CODE = G.MOLD_INFO_NO\r\n"
				+ " inner join USER_INFO_TBL H ON C.PRODUCTION_USER_CODE = H.USER_CODE\r\n";

		String where = " and PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '"
				+ obj.get("endDate") + " 08:29:59'";

		// 설비코드 검색
		if (obj.get("EQUIPMENT_INFO_CODE") != null && !obj.get("EQUIPMENT_INFO_CODE").equals("")) {
			where += " and PRODUCTION_EQUIPMENT_CODE like '%" + obj.get("EQUIPMENT_INFO_CODE") + "%'"
					+ " and EQUIPMENT_INFO_NAME like '%" + obj.get("EQUIPMENT_INFO_NAME") + "%'";
		}
		// 설비명 검색
		else {
			where += " and (EQUIPMENT_INFO_NAME like '%" + obj.get("EQUIPMENT_INFO_NAME") + "%'"
					+ " OR PRODUCTION_EQUIPMENT_CODE like '%" + obj.get("EQUIPMENT_INFO_NAME") + "%')";
		}
		sql += where;

		sql += " group by PRODUCTION_SERIAL_NUM, PRODUCTION_DEFECT_CODE  with rollup";

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		System.out.println(sql);
		int i = 0;
		List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

		while (rs.next()) {
			if (rs.getString("PRODUCTION_DEFECT_CODE") == null) {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				// 설비 Sub Total
				data1.setPRODUCTION_SERIAL_NUM("Sub Total");
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty")); // 생산수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_P_Qty") - rs.getInt("PRODUCTION_BAD")); // 양품
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%"); // 불량율
				list.add(data1);
			} else {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
				if (rs.getInt("PRODUCTION_BAD") == 0) {
					data1.setPRODUCTION_INFO_NUM("1");
				} else {
					data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
				}
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty")); // 생산수량
				data1.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_PRODUCTS_VOLUME")); // 양품
				data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
				data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
				data1.setPRODUCTION_MOLD_INFO_CODE(rs.getString("PRODUCTION_MOLD_INFO_CODE"));
				data1.setPRODUCTION_MOLD_INFO_NAME(rs.getString("PRODUCTION_MOLD_INFO_NAME"));
				data1.setPRODUCTION_USER_NAME(rs.getString("PRODUCTION_USER_NAME"));
				data1.setPRODUCTION_USER_CODE(rs.getString("PRODUCTION_USER_CODE"));
				data1.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D"));
				list.add(data1);
			}
		}
		// 설비 Grand Total
		if (list.size() > 0) {
			if (list.get(list.size() - 1).getPRODUCTION_PRODUCTS_VOLUME() == list.get(list.size() - 2)
					.getPRODUCTION_PRODUCTS_VOLUME()) {
				list.get(list.size() - 2).setPRODUCTION_SERIAL_NUM("Grand Total");
				list.remove(list.size() - 1);
			} else {
				list.get(list.size() - 1).setPRODUCTION_SERIAL_NUM("Grand Total");
				list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_CODE("");
				list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_INFO_NAME("");
			}
		}
		rs.close();
		pstmt.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 제품별
	@RequestMapping(value = "/PerformanceProduct", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_> PerformanceProduct(HttpServletRequest request)
			throws org.json.simple.parser.ParseException, SQLException {
		String originData = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(originData);
		// system.out.println(obj.toJSONString());

		String sql = "SELECT \r\n" + " C.PRODUCTION_SERIAL_NUM, \r\n" + " C.PRODUCTION_INFO_NUM, \r\n"
				+ " C.PRODUCTION_EQUIPMENT_CODE, \r\n" + " F.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
				+ " sum(C.PRODUCTION_VOLUME) PRODUCTION_P_Qty, \r\n"
				+ " (case when C.PRODUCTION_DEFECT_CODE = '' then sum(C.PRODUCTION_VOLUME)-sum(C.PRODUCTION_BAD) else 0 end) PRODUCTION_PRODUCTS_VOLUME,\r\n"
				+ " C.PRODUCTION_DEFECT_CODE,\r\n" + " sum(C.PRODUCTION_BAD) PRODUCTION_BAD, \r\n"
				+ " round(sum(C.PRODUCTION_BAD) / sum(C.PRODUCTION_VOLUME)* 100,2) PRODUCTION_DEFECT_RATE, \r\n"
				+ " C.PRODUCTION_PRODUCT_CODE, \r\n" + " E.PRODUCT_ITEM_NAME PRODUCT_ITEM_NAME, \r\n"
				+ " C.PRODUCTION_MOLD_INFO_CODE, \r\n" + " G.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n"
				+ " C.PRODUCTION_USER_CODE,\r\n" + " H.USER_NAME PRODUCTION_USER_NAME,\r\n"
				+ " C.PRODUCTION_MODIFY_D \r\n" + " FROM PRODUCTION_MGMT_TBL AS C\r\n"
				+ " inner join PRODUCT_INFO_TBL E ON C.PRODUCTION_PRODUCT_CODE = E.PRODUCT_ITEM_CODE \r\n"
				+ " inner join EQUIPMENT_INFO_TBL F ON C.PRODUCTION_EQUIPMENT_CODE = F.EQUIPMENT_INFO_CODE\r\n"
				+ " inner join MOLD_INFO_TBL G ON C.PRODUCTION_MOLD_INFO_CODE = G.MOLD_INFO_NO\r\n"
				+ " inner join USER_INFO_TBL H ON C.PRODUCTION_USER_CODE = H.USER_CODE\r\n";

		String where = " and PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '"
				+ obj.get("endDate") + " 08:29:59'";

		// 제품코드 검색
		if (obj.get("PRODUCT_ITEM_CODE") != null && !obj.get("PRODUCT_ITEM_CODE").equals("")) {
			where += " and PRODUCTION_PRODUCT_CODE like '%" + obj.get("PRODUCT_ITEM_CODE") + "%'"
					+ " and PRODUCT_ITEM_NAME like '%" + obj.get("PRODUCT_ITEM_NAME") + "%'";
		}
		// 제품명 검색
		else {
			where += " and (PRODUCT_ITEM_NAME like '%" + obj.get("PRODUCT_ITEM_NAME") + "%'"
					+ " OR PRODUCTION_PRODUCT_CODE like '%" + obj.get("PRODUCT_ITEM_NAME") + "%')";
		}
		sql += where;

		sql += " group by PRODUCTION_SERIAL_NUM, PRODUCTION_DEFECT_CODE with rollup";

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		System.out.println(sql);
		int i = 0;
		List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

		while (rs.next()) {
			if (rs.getString("PRODUCTION_DEFECT_CODE") == null) {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				// 제품 Sub Total
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM("Sub Total");
				data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
				data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty")); // 생산수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_P_Qty") - rs.getInt("PRODUCTION_BAD")); // 양품
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%"); // 불량율
				list.add(data1);
			} else {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
				if (rs.getInt("PRODUCTION_BAD") == 0) {
					data1.setPRODUCTION_INFO_NUM("1");
				} else {
					data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
				}
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty")); // 생산수량
				data1.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_PRODUCTS_VOLUME")); // 양품
				data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
				data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
				data1.setPRODUCTION_MOLD_INFO_CODE(rs.getString("PRODUCTION_MOLD_INFO_CODE"));
				data1.setPRODUCTION_MOLD_INFO_NAME(rs.getString("PRODUCTION_MOLD_INFO_NAME"));
				data1.setPRODUCTION_USER_NAME(rs.getString("PRODUCTION_USER_NAME"));
				data1.setPRODUCTION_USER_CODE(rs.getString("PRODUCTION_USER_CODE"));
				data1.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D"));
				list.add(data1);
			}
		}
		// 제품 Grand Total
		if (list.size() > 0) {
			if (list.get(list.size() - 1).getPRODUCTION_PRODUCTS_VOLUME() == list.get(list.size() - 2)
					.getPRODUCTION_PRODUCTS_VOLUME()) {
				list.get(list.size() - 2).setPRODUCTION_SERIAL_NUM("Grand Total");
				list.remove(list.size() - 1);
			} else {
				list.get(list.size() - 1).setPRODUCTION_SERIAL_NUM("Grand Total");
				list.get(list.size() - 1).setPRODUCTION_PRODUCT_CODE("");
				list.get(list.size() - 1).setPRODUCT_ITEM_NAME("");
			}
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 금형별
	@RequestMapping(value = "/PerformanceMold", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_> PerformanceMold(HttpServletRequest request)
			throws org.json.simple.parser.ParseException, SQLException {
		String originData = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(originData);
		// system.out.println(obj.toJSONString());

		String sql = "SELECT \r\n" + " C.PRODUCTION_SERIAL_NUM, \r\n" + " C.PRODUCTION_INFO_NUM, \r\n"
				+ " C.PRODUCTION_EQUIPMENT_CODE, \r\n" + " F.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
				+ " sum(C.PRODUCTION_VOLUME) PRODUCTION_P_Qty, \r\n"
				+ " (case when C.PRODUCTION_DEFECT_CODE = '' then sum(C.PRODUCTION_VOLUME)-sum(C.PRODUCTION_BAD) else 0 end) PRODUCTION_PRODUCTS_VOLUME,\r\n"
				+ " C.PRODUCTION_DEFECT_CODE,\r\n" + " sum(C.PRODUCTION_BAD) PRODUCTION_BAD, \r\n"
				+ " round(sum(C.PRODUCTION_BAD) / sum(C.PRODUCTION_VOLUME)* 100,2) PRODUCTION_DEFECT_RATE, \r\n"
				+ " C.PRODUCTION_PRODUCT_CODE, \r\n" + " E.PRODUCT_ITEM_NAME PRODUCT_ITEM_NAME, \r\n"
				+ " C.PRODUCTION_MOLD_INFO_CODE, \r\n" + " G.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n"
				+ " C.PRODUCTION_USER_CODE,\r\n" + " H.USER_NAME PRODUCTION_USER_NAME,\r\n"
				+ " C.PRODUCTION_MODIFY_D \r\n" + " FROM PRODUCTION_MGMT_TBL AS C\r\n"
				+ " inner join PRODUCT_INFO_TBL E ON C.PRODUCTION_PRODUCT_CODE = E.PRODUCT_ITEM_CODE \r\n"
				+ " inner join EQUIPMENT_INFO_TBL F ON C.PRODUCTION_EQUIPMENT_CODE = F.EQUIPMENT_INFO_CODE\r\n"
				+ " inner join MOLD_INFO_TBL G ON C.PRODUCTION_MOLD_INFO_CODE = G.MOLD_INFO_NO\r\n"
				+ " inner join USER_INFO_TBL H ON C.PRODUCTION_USER_CODE = H.USER_CODE\r\n";

		String where = " and PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '"
				+ obj.get("endDate") + " 08:29:59'";

		// 금형코드 검색
		if (obj.get("MOLD_INFO_NO") != null && !obj.get("MOLD_INFO_NO").equals("")) {
			where += " and PRODUCTION_MOLD_INFO_CODE like '%" + obj.get("MOLD_INFO_NO") + "%'"
					+ " and MOLD_INFO_NAME like '%" + obj.get("MOLD_INFO_NAME") + "%'";
		}
		// 금형명 검색
		if (obj.get("MOLD_INFO_NAME") != null && !obj.get("MOLD_INFO_NAME").equals("")) {
			where += " and (MOLD_INFO_NAME like '%" + obj.get("MOLD_INFO_NAME") + "%'"
					+ " OR PRODUCTION_MOLD_INFO_CODE like '%" + obj.get("MOLD_INFO_NAME") + "%')";

		}
		sql += where;

		sql += " group by PRODUCTION_SERIAL_NUM, PRODUCTION_DEFECT_CODE with rollup";

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		// system.out.println(sql);
		int i = 0;
		List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

		while (rs.next()) {
			if (rs.getString("PRODUCTION_DEFECT_CODE") == null) {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				// 금형 Sub Total
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM("Sub Total");
				data1.setPRODUCTION_MOLD_INFO_CODE(rs.getString("PRODUCTION_MOLD_INFO_CODE"));
				data1.setPRODUCTION_MOLD_INFO_NAME(rs.getString("PRODUCTION_MOLD_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty")); // 생산수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_P_Qty") - rs.getInt("PRODUCTION_BAD")); // 양품
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%"); // 불량율
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				list.add(data1);
			} else {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
				if (rs.getInt("PRODUCTION_BAD") == 0) {
					data1.setPRODUCTION_INFO_NUM("1");
				} else {
					data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
				}
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty")); // 생산수량
				data1.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_PRODUCTS_VOLUME")); // 양품
				data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
				data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
				data1.setPRODUCTION_MOLD_INFO_CODE(rs.getString("PRODUCTION_MOLD_INFO_CODE"));
				data1.setPRODUCTION_MOLD_INFO_NAME(rs.getString("PRODUCTION_MOLD_INFO_NAME"));
				data1.setPRODUCTION_USER_NAME(rs.getString("PRODUCTION_USER_NAME"));
				data1.setPRODUCTION_USER_CODE(rs.getString("PRODUCTION_USER_CODE"));
				data1.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D"));
				list.add(data1);
			}
		}
		// 금형 Grand Total
		if (list.size() > 0) {
			if (list.get(list.size() - 1).getPRODUCTION_PRODUCTS_VOLUME() == list.get(list.size() - 2)
					.getPRODUCTION_PRODUCTS_VOLUME()) {
				list.get(list.size() - 2).setPRODUCTION_SERIAL_NUM("Grand Total");
				list.remove(list.size() - 1);
			} else {
				list.get(list.size() - 1).setPRODUCTION_SERIAL_NUM("Grand Total");
				list.get(list.size() - 1).setPRODUCTION_MOLD_INFO_CODE("");
				list.get(list.size() - 1).setPRODUCTION_MOLD_INFO_NAME("");
			}
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 월별
	@RequestMapping(value = "/MonthProduct", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_> MonthProduct(HttpServletRequest request)
			throws org.json.simple.parser.ParseException, SQLException, ParseException {
		String originData = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(originData);

		String firstDay = (String) obj.get("firstDay");
		String endDay = (String) obj.get("endDay");

		DateFormat format = new SimpleDateFormat("yyyyMMdd");

		Date date = format.parse(firstDay);
		// System.out.println(date);
		Date date1 = format.parse(endDay);

		Calendar cal = Calendar.getInstance();
		cal.setTime(date);

		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(date1);

		int firstDay1 = cal.get(Calendar.DATE);
		int lastDay1 = cal1.get(Calendar.DATE);

		String sql = "SELECT \r\n" + "    C.PRODUCTION_PRODUCT_CODE,\r\n"
				+ "    E.PRODUCT_ITEM_NAME PRODUCT_ITEM_NAME,\r\n"
				+ "    MONTH(C.PRODUCTION_MODIFY_D) PRODUCTION_MODIFY_D,\r\n"
				+ "    SUM(C.PRODUCTION_VOLUME) PRODUCTION_P_Qty,\r\n" + "    SUM(C.PRODUCTION_BAD) PRODUCTION_BAD,\r\n"
				+ "    SUM(C.PRODUCTION_VOLUME) - SUM(C.PRODUCTION_BAD) PRODUCTION_PRODUCTS_VOLUME,\r\n"
				+ "    ROUND(SUM(C.PRODUCTION_BAD) / SUM(C.PRODUCTION_VOLUME) * 100,\r\n"
				+ "            2) PRODUCTION_DEFECT_RATE\r\n" + "FROM\r\n" + "    PRODUCTION_MGMT_TBL AS C\r\n"
				+ "        INNER JOIN\r\n"
				+ "    PRODUCT_INFO_TBL E ON C.PRODUCTION_PRODUCT_CODE = E.PRODUCT_ITEM_CODE";

		String where = " where PRODUCTION_MODIFY_D between '" + obj.get("startDate") + "-" + firstDay1
				+ " 08:30:00' and '" + obj.get("endDate") + "-" + lastDay1 + " 08:29:59'";

		// 제품코드 검색
		if (obj.get("PRODUCT_ITEM_CODE") != null && !obj.get("PRODUCT_ITEM_CODE").equals("")) {
			where += " and PRODUCTION_PRODUCT_CODE like '%" + obj.get("PRODUCT_ITEM_CODE") + "%'"
					+ " and PRODUCT_ITEM_NAME like '%" + obj.get("PRODUCT_ITEM_NAME") + "%'";
		}
		// 제품명 검색
		else {
			where += " and (PRODUCT_ITEM_NAME like '%" + obj.get("PRODUCT_ITEM_NAME") + "%'"
					+ " OR PRODUCTION_PRODUCT_CODE like '%" + obj.get("PRODUCT_ITEM_NAME") + "%')";
		}
		sql += where;

		sql += " group by DATE_FORMAT(PRODUCTION_MODIFY_D, '%Y-%m') , PRODUCTION_PRODUCT_CODE with rollup";

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		System.out.println(sql);
		int i = 0;

		List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

		while (rs.next()) {

			if (rs.getString("PRODUCTION_PRODUCT_CODE") == null) {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				// 금형 Sub Total
				i++;
				data1.setId(i);
				data1.setPRODUCTION_PRODUCT_CODE("Sub Total");
				data1.setPRODUCT_ITEM_NAME("");
				data1.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D") + "월");
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty")); // 생산수량
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_P_Qty") - rs.getInt("PRODUCTION_BAD")); // 양품
				data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%"); // 불량율
				list.add(data1);
			} else {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();

				data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
				data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
				data1.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D") + "월");
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty")); // 생산수량
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_PRODUCTS_VOLUME")); // 양품
				if (rs.getString("PRODUCTION_DEFECT_RATE") == null) {
					data1.setPRODUCTION_DEFECT_RATE("0");
				} else if (rs.getString("PRODUCTION_DEFECT_RATE").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%"); // 불량율
				list.add(data1);

			}

		}

		// 설비 Grand Total
		if (list.size() > 0) {

			if (list.get(list.size() - 1).getPRODUCTION_PRODUCTS_VOLUME() == list.get(list.size() - 2)
					.getPRODUCTION_PRODUCTS_VOLUME()) {
				list.get(list.size() - 2).setPRODUCTION_PRODUCT_CODE("Grand Total");
				list.remove(list.size() - 1);
			} else {

				list.get(list.size() - 1).setPRODUCTION_PRODUCT_CODE("Grand Total");
				list.get(list.size() - 1).setPRODUCT_ITEM_NAME("");
				list.get(list.size() - 1).setPRODUCTION_MODIFY_D("");

			}
		}
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	// 연별
	@RequestMapping(value = "/YearsProduct", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_YEAR> YearsProduct(HttpServletRequest request)
			throws org.json.simple.parser.ParseException, SQLException {
		String originData = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(originData);
		// system.out.println(obj.toJSONString());

		String sql = "SELECT \r\n"
				+ "    PRODUCTION_PRODUCT_CODE,\r\n"
				+ "    PRODUCT_ITEM_NAME,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '1' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_1,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '1' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_1,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '1' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_1,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '1' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_1,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '2' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_2,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '2' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_2,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '2' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_2,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '2' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_2,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '3' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_3,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '3' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_3,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '3' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_3,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '3' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_3,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '4' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_4,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '4' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_4,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '4' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_4,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '4' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_4,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '5' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_5,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '5' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_5,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '5' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_5,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '5' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_5,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '6' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_6,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '6' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_6,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '6' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_6,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '6' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_6,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '7' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_7,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '7' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_7,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '7' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_7,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '7' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_7,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '8' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_8,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '8' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_8,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '8' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_8,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '8' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_8,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '9' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_9,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '9' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_9,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '9' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_9,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '9' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_9,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '10' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_10,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '10' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_10,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '10' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_10,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '10' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_10,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '11' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_11,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '11' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_11,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '11' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_11,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '11' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_11,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '12' THEN PRODUCTION_P_Qty\r\n"
				+ "    END) AS PRODUCTION_P_Qty_12,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '12' THEN PRODUCTION_BAD\r\n"
				+ "    END) AS PRODUCTION_B_Qty_12,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '12' THEN PRODUCTION_PRODUCTS_VOLUME\r\n"
				+ "    END) AS PRODUCTION_PRODUCTS_VOLUME_12,\r\n"
				+ "    SUM(CASE\r\n"
				+ "        WHEN M = '12' THEN PRODUCTION_DEFECT_RATE\r\n"
				+ "    END) AS PRODUCTION_DEFECT_RATE_12,\r\n"
				+ "    SUM(PRODUCTION_P_Qty) AS SUM_PRODUCTION_P_Qty,\r\n"
				+ "    SUM(PRODUCTION_BAD) AS SUM_PRODUCTION_B_Qty,\r\n"
				+ "    SUM(PRODUCTION_PRODUCTS_VOLUME) AS SUM_PRODUCTION_PRODUCTS_VOLUME,\r\n"
				+ "    ROUND(SUM(PRODUCTION_BAD) / SUM(PRODUCTION_P_Qty) * 100, 2) AS SUM_PRODUCTION_PRODUCTION_DEFECT_RATE\r\n"
				+ "FROM\r\n"
				+ "    (SELECT \r\n"
				+ "        C.PRODUCTION_PRODUCT_CODE,\r\n"
				+ "            E.PRODUCT_ITEM_NAME PRODUCT_ITEM_NAME,\r\n"
				+ "            MONTH(C.PRODUCTION_MODIFY_D) AS M,\r\n"
				+ "            C.PRODUCTION_MODIFY_D PRODUCTION_MODIFY_D,\r\n"
				+ "            SUM(C.PRODUCTION_VOLUME) PRODUCTION_P_Qty,\r\n"
				+ "            SUM(C.PRODUCTION_VOLUME) - SUM(C.PRODUCTION_BAD) PRODUCTION_PRODUCTS_VOLUME,\r\n"
				+ "            SUM(C.PRODUCTION_BAD) PRODUCTION_BAD,\r\n"
				+ "            ROUND(SUM(C.PRODUCTION_BAD) / SUM(C.PRODUCTION_VOLUME) * 100, 2) PRODUCTION_DEFECT_RATE\r\n"
				+ "    FROM\r\n"
				+ "        PRODUCTION_MGMT_TBL AS C\r\n"
				+ "    INNER JOIN PRODUCT_INFO_TBL E ON C.PRODUCTION_PRODUCT_CODE = E.PRODUCT_ITEM_CODE";

		String where = " where PRODUCTION_MODIFY_D like '" + obj.get("startDate") + "%'";

		// 제품코드 검색
		if (obj.get("PRODUCT_ITEM_CODE") != null && !obj.get("PRODUCT_ITEM_CODE").equals("")) {
			where += " and PRODUCTION_PRODUCT_CODE like '%" + obj.get("PRODUCT_ITEM_CODE") + "%'"
					+ " and PRODUCT_ITEM_NAME like '%" + obj.get("PRODUCT_ITEM_NAME") + "%'";
		}
		// 제품명 검색
		else {
			where += " and (PRODUCT_ITEM_NAME like '%" + obj.get("PRODUCT_ITEM_NAME") + "%'"
					+ " OR PRODUCTION_PRODUCT_CODE like '%" + obj.get("PRODUCT_ITEM_NAME") + "%')";
		}
		sql += where;

		sql += " group by PRODUCTION_PRODUCT_CODE , MONTH(PRODUCTION_MODIFY_D)) AS A";
		sql += " group by PRODUCTION_PRODUCT_CODE with rollup";
		

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		System.out.println(sql);
		int i = 0;
		List<PRODUCTION_INFO_YEAR> list = new ArrayList<PRODUCTION_INFO_YEAR>();

		while (rs.next()) {


			PRODUCTION_INFO_YEAR data1 = new PRODUCTION_INFO_YEAR();
			i++;
			data1.setId(i);
			data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
			data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
			data1.setPRODUCTION_P_Qty_1(rs.getInt("PRODUCTION_P_Qty_1")); // 1월 생산수량
			data1.setPRODUCTION_P_Qty_2(rs.getInt("PRODUCTION_P_Qty_2")); // 2월 생산수량
			data1.setPRODUCTION_P_Qty_3(rs.getInt("PRODUCTION_P_Qty_3")); // 3월 생산수량
			data1.setPRODUCTION_P_Qty_4(rs.getInt("PRODUCTION_P_Qty_4")); // 4월 생산수량
			data1.setPRODUCTION_P_Qty_5(rs.getInt("PRODUCTION_P_Qty_5")); // 5월 생산수량
			data1.setPRODUCTION_P_Qty_6(rs.getInt("PRODUCTION_P_Qty_6")); // 6월 생산수량
			data1.setPRODUCTION_P_Qty_7(rs.getInt("PRODUCTION_P_Qty_7")); // 7월 생산수량
			data1.setPRODUCTION_P_Qty_8(rs.getInt("PRODUCTION_P_Qty_8")); // 8월 생산수량
			data1.setPRODUCTION_P_Qty_9(rs.getInt("PRODUCTION_P_Qty_9")); // 9월 생산수량
			data1.setPRODUCTION_P_Qty_10(rs.getInt("PRODUCTION_P_Qty_10")); // 10월 생산수량
			data1.setPRODUCTION_P_Qty_11(rs.getInt("PRODUCTION_P_Qty_11")); // 11월 생산수량
			data1.setPRODUCTION_P_Qty_12(rs.getInt("PRODUCTION_P_Qty_12")); // 12월 생산수량
			data1.setPRODUCTION_B_Qty_1(rs.getInt("PRODUCTION_B_Qty_1")); // 1월 불량수량
			data1.setPRODUCTION_B_Qty_2(rs.getInt("PRODUCTION_B_Qty_2")); // 2월 불량수량
			data1.setPRODUCTION_B_Qty_3(rs.getInt("PRODUCTION_B_Qty_3")); // 3월 불량수량
			data1.setPRODUCTION_B_Qty_4(rs.getInt("PRODUCTION_B_Qty_4")); // 4월 불량수량
			data1.setPRODUCTION_B_Qty_5(rs.getInt("PRODUCTION_B_Qty_5")); // 5월 불량수량
			data1.setPRODUCTION_B_Qty_6(rs.getInt("PRODUCTION_B_Qty_6")); // 6월 불량수량
			data1.setPRODUCTION_B_Qty_7(rs.getInt("PRODUCTION_B_Qty_7")); // 7월 불량수량
			data1.setPRODUCTION_B_Qty_8(rs.getInt("PRODUCTION_B_Qty_8")); // 8월 불량수량
			data1.setPRODUCTION_B_Qty_9(rs.getInt("PRODUCTION_B_Qty_9")); // 9월 불량수량
			data1.setPRODUCTION_B_Qty_10(rs.getInt("PRODUCTION_B_Qty_10")); // 10월 불량수량
			data1.setPRODUCTION_B_Qty_11(rs.getInt("PRODUCTION_B_Qty_11")); // 11월 불량수량
			data1.setPRODUCTION_B_Qty_12(rs.getInt("PRODUCTION_B_Qty_12")); // 12월 불량수량
			data1.setPRODUCTION_PRODUCTS_VOLUME_1(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_1")); // 1월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_2(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_2")); // 2월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_3(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_3")); // 3월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_4(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_4")); // 4월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_5(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_5")); // 5월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_6(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_6")); // 6월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_7(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_7")); // 7월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_8(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_8")); // 8월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_9(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_9")); // 9월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_10(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_10")); // 10월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_11(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_11")); // 11월 양품
			data1.setPRODUCTION_PRODUCTS_VOLUME_12(rs.getInt("PRODUCTION_PRODUCTS_VOLUME_12")); // 12월 양품
			data1.setSUM_PRODUCTION_P_Qty(rs.getInt("SUM_PRODUCTION_P_Qty")); // 생산합계
			data1.setSUM_PRODUCTION_B_Qty(rs.getInt("SUM_PRODUCTION_B_Qty")); // 생산합계
			data1.setSUM_PRODUCTION_PRODUCTS_VOLUME(rs.getInt("SUM_PRODUCTION_PRODUCTS_VOLUME")); // 생산합계
		
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_1") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_1").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_1("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_1(rs.getString("PRODUCTION_DEFECT_RATE_1") + "%"); // 1월 불량율
			}
			else
				data1.setPRODUCTION_DEFECT_RATE_1("0");
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_2") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_2").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_2("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_2(rs.getString("PRODUCTION_DEFECT_RATE_2") + "%"); // 2월 불량율
			}
			else
				data1.setPRODUCTION_DEFECT_RATE_2("0");
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_3") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_3").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_3("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_3(rs.getString("PRODUCTION_DEFECT_RATE_3") + "%"); // 3월 불량율
			}
			data1.setPRODUCTION_DEFECT_RATE_3("0");
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_4") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_4").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_4("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_4(rs.getString("PRODUCTION_DEFECT_RATE_4") + "%"); // 4월 불량율
			}
			else 
				data1.setPRODUCTION_DEFECT_RATE_4("0");
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_5") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_5").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_5("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_5(rs.getString("PRODUCTION_DEFECT_RATE_5") + "%"); // 5월 불량율
			}
			else
				data1.setPRODUCTION_DEFECT_RATE_5("0");
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_6") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_6").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_6("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_6(rs.getString("PRODUCTION_DEFECT_RATE_6") + "%"); // 6월 불량율
			}
			else 
				data1.setPRODUCTION_DEFECT_RATE_6("0");
		
			if(rs.getString("PRODUCTION_DEFECT_RATE_7") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_7").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_7("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_7(rs.getString("PRODUCTION_DEFECT_RATE_7") + "%"); // 7월 불량율
			}
			else
				data1.setPRODUCTION_DEFECT_RATE_7("0");
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_8") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_8").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_8("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_8(rs.getString("PRODUCTION_DEFECT_RATE_8") + "%"); // 8월 불량율
			}
			else
				data1.setPRODUCTION_DEFECT_RATE_8("0");
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_9") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_9").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_9("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_9(rs.getString("PRODUCTION_DEFECT_RATE_9") + "%"); // 9월 불량율
			}
			else
				data1.setPRODUCTION_DEFECT_RATE_9("0");
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_10") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_10").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_10("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_10(rs.getString("PRODUCTION_DEFECT_RATE_10") + "%"); // 10월 불량율
			}
			else
				data1.setPRODUCTION_DEFECT_RATE_10("0");
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_11") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_11").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_11("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_11(rs.getString("PRODUCTION_DEFECT_RATE_11") + "%"); // 11월 불량율
			}
			else 
				data1.setPRODUCTION_DEFECT_RATE_11("0");
			
			
			if(rs.getString("PRODUCTION_DEFECT_RATE_12") != null)
			{
				if (rs.getString("PRODUCTION_DEFECT_RATE_12").equals("0.00")) {
					data1.setPRODUCTION_DEFECT_RATE_12("0");
				} else
					data1.setPRODUCTION_DEFECT_RATE_12(rs.getString("PRODUCTION_DEFECT_RATE_12") + "%"); // 12월 불량율
			}
			else
				data1.setPRODUCTION_DEFECT_RATE_12("0");
			
			if(rs.getString("SUM_PRODUCTION_PRODUCTION_DEFECT_RATE") != null)
			{
				if (rs.getString("SUM_PRODUCTION_PRODUCTION_DEFECT_RATE").equals("0.00")) {
					data1.setSUM_PRODUCTION_PRODUCTION_DEFECT_RATE("0");
				} else
					data1.setSUM_PRODUCTION_PRODUCTION_DEFECT_RATE(rs.getString("SUM_PRODUCTION_PRODUCTION_DEFECT_RATE") + "%"); // 12월 불량율
			}
			else
				data1.setPRODUCTION_DEFECT_RATE_12("0");
			
			System.out.println(data1.toString());
			list.add(data1);

		}

		if (list.size() > 0) {
			
				list.get(list.size() - 1).setPRODUCT_ITEM_NAME("Grand Total");
			}
		
		rs.close();
		pstmt.close();
		pstmt.close();
		conn.close();
		return list;
	}
}
