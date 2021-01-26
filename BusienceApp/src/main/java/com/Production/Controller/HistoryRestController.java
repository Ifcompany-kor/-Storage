package com.Production.Controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Production.Dto.PRODUCTION_INFO_;

@RestController("HistoryRestController")
@RequestMapping("HistoryRest")
public class HistoryRestController {

	@Autowired
	SimpleDriverDataSource dataSource;

	//설비별
	@RequestMapping(value = "/HistoryEquipment", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_> HistoryEquipment(HttpServletRequest request)
			throws ParseException, SQLException, org.json.simple.parser.ParseException {
		String originData = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(originData);
		//system.out.println(obj.toJSONString());

		String sql = "SELECT \r\n"
				+ " C.PRODUCTION_SERIAL_NUM, \r\n"
				+ " C.PRODUCTION_INFO_NUM, \r\n"
				+ " C.PRODUCTION_EQUIPMENT_CODE, \r\n"
				+ " F.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
				+ " sum(C.PRODUCTION_VOLUME) PRODUCTION_VOLUME, \r\n"
				+ " (case when C.PRODUCTION_DEFECT_CODE = '' then sum(C.PRODUCTION_VOLUME)-sum(C.PRODUCTION_BAD) else 0 end) PRODUCTION_PRODUCTS_VOLUME,\r\n"
				+ " C.PRODUCTION_DEFECT_CODE,\r\n"
				+ " sum(C.PRODUCTION_BAD) PRODUCTION_BAD, \r\n"
				+ " round(sum(C.PRODUCTION_BAD) / sum(C.PRODUCTION_VOLUME + C.PRODUCTION_BAD)* 100,2) PRODUCTION_DEFECT_RATE, \r\n"
				+ " C.PRODUCTION_PRODUCT_CODE, \r\n"
				+ " E.PRODUCT_ITEM_NAME PRODUCT_ITEM_NAME, \r\n"
				+ " C.PRODUCTION_MOLD_INFO_CODE, \r\n"
				+ " G.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n"
				+ " C.PRODUCTION_USER_CODE,\r\n" 
				+ " H.USER_NAME PRODUCTION_USER_NAME,\r\n"
				+ " C.PRODUCTION_MODIFY_D \r\n"
				+ " FROM PRODUCTION_MGMT_TBL AS C\r\n"
				+ " inner join PRODUCT_INFO_TBL E ON C.PRODUCTION_PRODUCT_CODE = E.PRODUCT_ITEM_CODE \r\n"
				+ " inner join EQUIPMENT_INFO_TBL F ON C.PRODUCTION_EQUIPMENT_CODE = F.EQUIPMENT_INFO_CODE\r\n"
				+ " inner join MOLD_INFO_TBL G ON C.PRODUCTION_MOLD_INFO_CODE = G.MOLD_INFO_NO\r\n"
				+ " inner join USER_INFO_TBL H ON C.PRODUCTION_USER_CODE = H.USER_CODE\r\n";

		String where = " and PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '" + obj.get("endDate")+" 08:29:59'";
		
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

		sql += " group by EQUIPMENT_INFO_NAME, PRODUCTION_SERIAL_NUM,  PRODUCTION_INFO_NUM  with rollup";

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		//system.out.println(sql);
		int i = 0;
		List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

		while (rs.next()) {

			if (rs.getInt("PRODUCTION_INFO_NUM") == 0) {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM("Sub Total");
				//설비별합계
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_VOLUME")); // 생산수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_VOLUME")-rs.getInt("PRODUCTION_BAD")); // 양품
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%"); // 불량율
				list.add(data1);
			} else {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
				data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_VOLUME")); // 생산수량
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
		//설비 총 합계
        if (list.size() > 0){
           if(list.get(list.size() - 1).getPRODUCTION_PRODUCTS_VOLUME() == list.get(list.size() - 2).getPRODUCTION_PRODUCTS_VOLUME()) {
              list.get(list.size() - 2).setPRODUCTION_SERIAL_NUM("Grand Total");
              list.remove(list.size() - 1);
           }
           else {
           list.get(list.size() - 1).setPRODUCTION_SERIAL_NUM("Grand Total");
           list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_CODE("");
           list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_INFO_NAME("");
           }
        }
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	//제품별
	@RequestMapping(value = "/HistoryProduct", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_> HistoryProduct(HttpServletRequest request)
			throws org.json.simple.parser.ParseException, SQLException {
		String originData = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(originData);
		//system.out.println(obj.toJSONString());

		String sql = "SELECT \r\n"
				+ " C.PRODUCTION_SERIAL_NUM, \r\n"
				+ " C.PRODUCTION_INFO_NUM, \r\n"
				+ " C.PRODUCTION_EQUIPMENT_CODE, \r\n"
				+ " F.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
				+ " sum(C.PRODUCTION_VOLUME) PRODUCTION_VOLUME, \r\n"
				+ " (case when C.PRODUCTION_DEFECT_CODE = '' then sum(C.PRODUCTION_VOLUME)-sum(C.PRODUCTION_BAD) else 0 end) PRODUCTION_PRODUCTS_VOLUME,\r\n"
				+ " C.PRODUCTION_DEFECT_CODE,\r\n"
				+ " sum(C.PRODUCTION_BAD) PRODUCTION_BAD, \r\n"
				+ " round(sum(C.PRODUCTION_BAD) / sum(C.PRODUCTION_VOLUME + C.PRODUCTION_BAD)* 100,2) PRODUCTION_DEFECT_RATE, \r\n"
				+ " C.PRODUCTION_PRODUCT_CODE, \r\n"
				+ " E.PRODUCT_ITEM_NAME PRODUCT_ITEM_NAME, \r\n"
				+ " C.PRODUCTION_MOLD_INFO_CODE, \r\n"
				+ " G.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n"
				+ " C.PRODUCTION_USER_CODE,\r\n" 
				+ " H.USER_NAME PRODUCTION_USER_NAME,\r\n"
				+ " C.PRODUCTION_MODIFY_D \r\n"
				+ " FROM PRODUCTION_MGMT_TBL AS C\r\n"
				+ " inner join PRODUCT_INFO_TBL E ON C.PRODUCTION_PRODUCT_CODE = E.PRODUCT_ITEM_CODE \r\n"
				+ " inner join EQUIPMENT_INFO_TBL F ON C.PRODUCTION_EQUIPMENT_CODE = F.EQUIPMENT_INFO_CODE\r\n"
				+ " inner join MOLD_INFO_TBL G ON C.PRODUCTION_MOLD_INFO_CODE = G.MOLD_INFO_NO\r\n"
				+ " inner join USER_INFO_TBL H ON C.PRODUCTION_USER_CODE = H.USER_CODE\r\n";

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
		
		sql += where;

		sql += " group by PRODUCT_ITEM_NAME, PRODUCTION_SERIAL_NUM, PRODUCTION_INFO_NUM with rollup";
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		//system.out.println(sql);
		int i = 0;
		List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

		while (rs.next()) {
			
			if (rs.getInt("PRODUCTION_INFO_NUM") == 0) {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM("Sub Total");
				//제품별 합계
				data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
				data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_VOLUME")); // 생산수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_VOLUME")-rs.getInt("PRODUCTION_BAD")); // 양품
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%"); // 불량율
				list.add(data1);
			} else {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
				data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_VOLUME")); // 생산수량
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
		//제품 총 합계
        if (list.size() > 0){
           if(list.get(list.size() - 1).getPRODUCTION_PRODUCTS_VOLUME() == list.get(list.size() - 2).getPRODUCTION_PRODUCTS_VOLUME()) {
              list.get(list.size() - 2).setPRODUCTION_SERIAL_NUM("Grand Total");
              list.remove(list.size() - 1);
           }
           else {
           list.get(list.size() - 1).setPRODUCTION_SERIAL_NUM("Grand Total");
           list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_CODE("");
           list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_INFO_NAME("");
           }
        }
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}

	//금형별
	@RequestMapping(value = "/HistoryMold", method = RequestMethod.GET)
	public List<PRODUCTION_INFO_> HistoryMold(HttpServletRequest request)
			throws org.json.simple.parser.ParseException, SQLException {
		String originData = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(originData);
		//system.out.println(obj.toJSONString());

		String sql = "SELECT \r\n"
				+ " C.PRODUCTION_SERIAL_NUM, \r\n"
				+ " C.PRODUCTION_INFO_NUM, \r\n"
				+ " C.PRODUCTION_EQUIPMENT_CODE, \r\n"
				+ " F.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
				+ " sum(C.PRODUCTION_VOLUME) PRODUCTION_VOLUME, \r\n"
				+ " (case when C.PRODUCTION_DEFECT_CODE = '' then sum(C.PRODUCTION_VOLUME)-sum(C.PRODUCTION_BAD) else 0 end) PRODUCTION_PRODUCTS_VOLUME,\r\n"
				+ " C.PRODUCTION_DEFECT_CODE,\r\n"
				+ " sum(C.PRODUCTION_BAD) PRODUCTION_BAD, \r\n"
				+ " round(sum(C.PRODUCTION_BAD) / sum(C.PRODUCTION_VOLUME + C.PRODUCTION_BAD)* 100,2) PRODUCTION_DEFECT_RATE, \r\n"
				+ " C.PRODUCTION_PRODUCT_CODE, \r\n"
				+ " E.PRODUCT_ITEM_NAME PRODUCT_ITEM_NAME, \r\n"
				+ " C.PRODUCTION_MOLD_INFO_CODE, \r\n"
				+ " G.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n"
				+ " C.PRODUCTION_USER_CODE,\r\n" 
				+ " H.USER_NAME PRODUCTION_USER_NAME,\r\n"
				+ " C.PRODUCTION_MODIFY_D \r\n"
				+ " FROM PRODUCTION_MGMT_TBL AS C\r\n"
				+ " inner join PRODUCT_INFO_TBL E ON C.PRODUCTION_PRODUCT_CODE = E.PRODUCT_ITEM_CODE \r\n"
				+ " inner join EQUIPMENT_INFO_TBL F ON C.PRODUCTION_EQUIPMENT_CODE = F.EQUIPMENT_INFO_CODE\r\n"
				+ " inner join MOLD_INFO_TBL G ON C.PRODUCTION_MOLD_INFO_CODE = G.MOLD_INFO_NO\r\n"
				+ " inner join USER_INFO_TBL H ON C.PRODUCTION_USER_CODE = H.USER_CODE\r\n";

		String where = " and PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '" + obj.get("endDate")+" 08:29:59'";
		
		//금형코드 검색
		if (obj.get("MOLD_INFO_NO") != null && !obj.get("MOLD_INFO_NO").equals("")) {
				where += " and PRODUCTION_MOLD_INFO_CODE like '%" + obj.get("MOLD_INFO_NO") + "%'"
						+ " and MOLD_INFO_NAME like '%" + obj.get("MOLD_INFO_NAME") + "%'";
		}
		//금형명 검색
		if (obj.get("MOLD_INFO_NAME") != null && !obj.get("MOLD_INFO_NAME").equals("")) {
				where += " and (MOLD_INFO_NAME like '%" + obj.get("MOLD_INFO_NAME") + "%'"
						+ " OR PRODUCTION_MOLD_INFO_CODE like '%" + obj.get("MOLD_INFO_NAME") + "%')";
				
		}
		sql += where;

		sql += " group by MOLD_INFO_NO, PRODUCTION_SERIAL_NUM, PRODUCTION_INFO_NUM with rollup";

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		//system.out.println(sql);
		int i= 0;
		List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

		while (rs.next()) {

			if (rs.getInt("PRODUCTION_INFO_NUM") == 0) {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM("Sub Total");
				//금형별합계
				data1.setPRODUCTION_MOLD_INFO_CODE(rs.getString("PRODUCTION_MOLD_INFO_CODE"));
				data1.setPRODUCTION_MOLD_INFO_NAME(rs.getString("PRODUCTION_MOLD_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_VOLUME")); // 생산수량
				data1.setPRODUCTION_PRODUCTS_VOLUME(rs.getInt("PRODUCTION_VOLUME")-rs.getInt("PRODUCTION_BAD")); // 양품
				data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_BAD")); // 불량수량
				data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%"); // 불량율				
				list.add(data1);
			} else {
				PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
				i++;
				data1.setId(i);
				data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
				data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
				data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
				data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
				data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_VOLUME")); // 생산수량
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
		//금형 총 합계
        if (list.size() > 0){
           if(list.get(list.size() - 1).getPRODUCTION_PRODUCTS_VOLUME() == list.get(list.size() - 2).getPRODUCTION_PRODUCTS_VOLUME()) {
              list.get(list.size() - 2).setPRODUCTION_SERIAL_NUM("Grand Total");
              list.remove(list.size() - 1);
           }
           else {
           list.get(list.size() - 1).setPRODUCTION_SERIAL_NUM("Grand Total");
           list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_CODE("");
           list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_INFO_NAME("");
           }
        }
		rs.close();
		pstmt.close();
		conn.close();
		return list;
	}
}
