package com.Standard.Controller;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.Common.Controller.HomeController;
import com.Standard.Dto.PRODUCT_INFO_TBL;

@RestController("ProductRestController")
@RequestMapping("productRest")
public class ProductRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/insert3.do", method = RequestMethod.POST)
	   public String insert3(HttpServletRequest request, Model model)
	         throws SQLException, org.json.simple.parser.ParseException, UnknownHostException, ClassNotFoundException {
	      String data = request.getParameter("data");
	      JSONParser parser = new JSONParser();
	      JSONObject obj = (JSONObject) parser.parse(data);
	      //System.out.println(obj.toJSONString());

	      Connection conn = dataSource.getConnection();
	      String checkSql = "select PRODUCT_ITEM_CODE from PRODUCT_INFO_TBL where PRODUCT_ITEM_CODE='"
	            + obj.get("PRODUCT_ITEM_CODE") + "'";
	      PreparedStatement pstmt = conn.prepareStatement(checkSql);
	      ResultSet rs = pstmt.executeQuery();

	      // 중복체크
	      while (rs.next()) {
	         String check_PRODUCT_ITEM_CODE = rs.getString("PRODUCT_ITEM_CODE");

	         if (check_PRODUCT_ITEM_CODE.length() > 0) {
	            return "Overlap";
	         }
	      }
	      // 날짜 설정
	      java.util.Date date = new java.util.Date();
	      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	      String datestr = sdf.format(date.getTime());

	      HttpSession httpSession = request.getSession();
		  String modifier = (String) httpSession.getAttribute("id");
	      
	      String sql = "insert into PRODUCT_INFO_TBL values (";
	      sql += "'" + obj.get("PRODUCT_BUSINESS_PLACE") + "',";
	      sql += "'" + obj.get("PRODUCT_ITEM_CODE") + "',";
	      sql += "'" + obj.get("PRODUCT_OLD_ITEM_CODE") + "',";
	      sql += "'" + obj.get("PRODUCT_ITEM_NAME") + "',";
	      sql += "'" + obj.get("PRODUCT_INFO_STND_1") + "',";
	      sql += "'" + obj.get("PRODUCT_INFO_STND_2") + "',";
	      sql += "'" + obj.get("PRODUCT_UNIT") + "',";
	      sql += "'" + obj.get("PRODUCT_MATERIAL") + "',";
	      sql += "'" + obj.get("PRODUCT_MTRL_CLSFC") + "',";
	      sql += "'" + obj.get("PRODUCT_ITEM_CLSFC_1") + "',";
	      sql += "'" + obj.get("PRODUCT_ITEM_CLSFC_2") + "',";
	      sql += "'" + obj.get("PRODUCT_SUBSID_MATL_MGMT") + "',";
	      sql += "'" + obj.get("PRODUCT_ITEM_STTS") + "',";
	      sql += "'" + obj.get("PRODUCT_BASIC_WAREHOUSE") + "',";
	      sql += "" + obj.get("PRODUCT_SFTY_STOCK") + ",";
	      sql += "" + obj.get("PRODUCT_MIN_VOL_ORDERS") + ",";
	      sql += "" + obj.get("PRODUCT_MAX_VOL_ORDERS") + ",";
	      sql += "'" + obj.get("PRODUCT_BUYER") + "',";
	      sql += "'" + obj.get("PRODUCT_WRHSN_INSPC") + "',";
	      sql += "'" + obj.get("PRODUCT_USE_STATUS") + "',";
	      sql += "'" + datestr + "',";
	      sql += "'" + modifier + "')";

	      HomeController.LogInsert("", "1. Insert", sql, request);
	      
	      //System.out.println("삽입 : " + sql);
	      // System.out.println(obj.get("PRODUCT_USE_STATUS"));

	      pstmt = conn.prepareStatement(sql);
	      pstmt.executeUpdate();

	      rs.close();
	      pstmt.close();
	      conn.close();

	      return "Success";
	   }
	// 수정
	@RequestMapping(value = "/update3.do", method = RequestMethod.POST)
	public String update2(HttpServletRequest request, Model model) throws SQLException, org.json.simple.parser.ParseException, UnknownHostException, ClassNotFoundException {
		String data = request.getParameter("data");
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(data);

		//System.out.println(obj.toJSONString());

		// 날짜 설정
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String datestr1 = sdf.format(date.getTime());
		
		HttpSession httpSession = request.getSession();
		String modifier = (String) httpSession.getAttribute("id");

		String sql = "update PRODUCT_INFO_TBL set ";
		sql += "PRODUCT_BUSINESS_PLACE='" + obj.get("PRODUCT_BUSINESS_PLACE") + "'";
		sql += ",PRODUCT_OLD_ITEM_CODE='" + obj.get("PRODUCT_OLD_ITEM_CODE") + "'";
		sql += ",PRODUCT_ITEM_NAME='" + obj.get("PRODUCT_ITEM_NAME") + "'";
		sql += ",PRODUCT_INFO_STND_1='" + obj.get("PRODUCT_INFO_STND_1") + "'";
		sql += ",PRODUCT_INFO_STND_2='" + obj.get("PRODUCT_INFO_STND_2") + "'";
		sql += ",PRODUCT_UNIT='" + obj.get("PRODUCT_UNIT") + "'";
		sql += ",PRODUCT_MATERIAL='" + obj.get("PRODUCT_MATERIAL") + "'";
		sql += ",PRODUCT_MTRL_CLSFC='" + obj.get("PRODUCT_MTRL_CLSFC") + "'";
		sql += ",PRODUCT_ITEM_CLSFC_1='" + obj.get("PRODUCT_ITEM_CLSFC_1") + "'";
		sql += ",PRODUCT_ITEM_CLSFC_2='" + obj.get("PRODUCT_ITEM_CLSFC_2") + "'";
		sql += ",PRODUCT_SUBSID_MATL_MGMT='" + obj.get("PRODUCT_SUBSID_MATL_MGMT") + "'";
		sql += ",PRODUCT_ITEM_STTS='" + obj.get("PRODUCT_ITEM_STTS") + "'";
		sql += ",PRODUCT_BASIC_WAREHOUSE='" + obj.get("PRODUCT_BASIC_WAREHOUSE") + "'";
		sql += ",PRODUCT_SFTY_STOCK=" + obj.get("PRODUCT_SFTY_STOCK") + "";
		sql += ",PRODUCT_MIN_VOL_ORDERS=" + obj.get("PRODUCT_MIN_VOL_ORDERS") + "";
		sql += ",PRODUCT_MAX_VOL_ORDERS=" + obj.get("PRODUCT_MAX_VOL_ORDERS") + "";
		sql += ",PRODUCT_BUYER='" + obj.get("PRODUCT_BUYER") + "'";
		sql += ",PRODUCT_WRHSN_INSPC='" + obj.get("PRODUCT_WRHSN_INSPC") + "'";
		sql += ",PRODUCT_USE_STATUS='" + obj.get("PRODUCT_USE_STATUS") + "'";
		sql += ",PRODUCT_MODIFIER='" + modifier + "'";
		sql += ",PRODUCT_MODIFY_D='" + datestr1 + "'";
		sql += " where PRODUCT_ITEM_CODE='" + obj.get("PRODUCT_ITEM_CODE") + "'";

		//System.out.println(sql);
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
	@RequestMapping(value = "/delete3.do", method = RequestMethod.POST)
	public String delete2(HttpServletRequest request, Model model) throws SQLException, ParseException, UnknownHostException, ClassNotFoundException {
		String PRODUCT_ITEM_CODE = request.getParameter("PRODUCT_ITEM_CODE");

		//System.out.println("PRODUCT_ITEM_CODE");
		
		String sql = "delete from PRODUCT_INFO_TBL where PRODUCT_ITEM_CODE='"+PRODUCT_ITEM_CODE+"'";
		
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
		
		return PRODUCT_ITEM_CODE;
	}
}
