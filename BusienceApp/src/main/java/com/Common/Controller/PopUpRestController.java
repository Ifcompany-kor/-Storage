package com.Common.Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.Standard.Dto.DEFECT_INFO_TBL;
import com.Standard.Dto.EQUIPMENT_INFO_TBL;
import com.Standard.Dto.MOLD_INFO_TBL;
import com.Standard.Dto.PRODUCT_INFO_TBL;

@RestController
public class PopUpRestController {

	@Autowired
	SimpleDriverDataSource dataSource;

	@RequestMapping(value = "/defect_popup_data", method = { RequestMethod.GET })
	public List<DEFECT_INFO_TBL> defect_popup_data(
			@RequestParam(value = "DEFECT_CODE", required = false) String DEFECT_CODE,
			@RequestParam(value = "DEFECT_NAME", required = false) String DEFECT_NAME) throws SQLException {

		String sql = "";
		sql = "select * from DEFECT_INFO_TBL where DEFECT_NAME like '%" + DEFECT_NAME + "%' and ";
		sql += "DEFECT_CODE like '%" + DEFECT_CODE + "%'";

		if (DEFECT_CODE == null || DEFECT_CODE == "") {
			DEFECT_CODE = "";

			sql = "select * from DEFECT_INFO_TBL where DEFECT_NAME like '%" + DEFECT_NAME + "%'";
			sql += " or DEFECT_CODE like '%" + DEFECT_NAME + "%'";
		}
		if (DEFECT_NAME == null || DEFECT_NAME == "") {
			DEFECT_NAME = "";

			sql = "select * from DEFECT_INFO_TBL where DEFECT_CODE like '%" + DEFECT_CODE + "%'";
			sql += " or DEFECT_CODE like '%" + DEFECT_CODE + "%'";
		}

		sql += " and DEFECT_USE_STATUS='true'";
		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int t = 0;

		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); // 컬럼의 수

		List<DEFECT_INFO_TBL> list = new ArrayList<DEFECT_INFO_TBL>();

		while (rs.next()) {
			t++;
			DEFECT_INFO_TBL data = new DEFECT_INFO_TBL();
			data.setId(t);
			data.setDEFECT_CODE(rs.getString("DEFECT_CODE"));
			data.setDEFECT_NAME(rs.getString("DEFECT_NAME"));
			list.add(data);
		}

		return list;
	}

	@RequestMapping(value = "/product_popup_data", method = RequestMethod.GET)
	public List<PRODUCT_INFO_TBL> popup(
			@RequestParam(value = "PRODUCT_ITEM_CODE", required = false) String PRODUCT_ITEM_CODE,
			@RequestParam(value = "PRODUCT_ITEM_NAME", required = false) String PRODUCT_ITEM_NAME) throws SQLException {
		List<PRODUCT_INFO_TBL> list = new ArrayList<PRODUCT_INFO_TBL>();

		String sql = "";

		sql = "select * from PRODUCT_INFO_TBL where (PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%' and ";
		sql += "PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_CODE + "%')";

		if (PRODUCT_ITEM_CODE == null || PRODUCT_ITEM_CODE == "") {
			PRODUCT_ITEM_CODE = "";

			sql = "select * from PRODUCT_INFO_TBL where (PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%' or ";
			sql += "PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_NAME + "%')";
		}
		if (PRODUCT_ITEM_NAME == null || PRODUCT_ITEM_NAME == "") {
			PRODUCT_ITEM_NAME = "";

			sql = "select * from PRODUCT_INFO_TBL where (PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_CODE + "%' or ";
			sql += "PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_CODE + "%')";
		}

		sql += " and PRODUCT_USE_STATUS='true'";
		
		 System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			PRODUCT_INFO_TBL data = new PRODUCT_INFO_TBL();
			i++;
			data.setId(i);
			data.setPRODUCT_ITEM_CODE(rs.getString("PRODUCT_ITEM_CODE"));
			data.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 금형 팝업에게 json array 데이터를 전달함
	@RequestMapping(value = "/moldPopup", method = RequestMethod.GET)
	public List<MOLD_INFO_TBL> moldPopup(@RequestParam(value = "MOLD_INFO_NO", required = false) String MOLD_INFO_NO,
			@RequestParam(value = "MOLD_INFO_NAME", required = false) String MOLD_INFO_NAME) throws SQLException {
		List<MOLD_INFO_TBL> list = new ArrayList<MOLD_INFO_TBL>();

		String sql = "";

		sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%' and ";
		sql += "MOLD_INFO_NO like '%" + MOLD_INFO_NO + "%'";

		if (MOLD_INFO_NO == null || MOLD_INFO_NO == "") {
			MOLD_INFO_NO = "";

			sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%'";
		}
		if (MOLD_INFO_NAME == null || MOLD_INFO_NAME == "") {
			MOLD_INFO_NAME = "";

			sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%'";
		}

		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			MOLD_INFO_TBL data = new MOLD_INFO_TBL();
			i++;
			// data.setId(i);
			data.setMOLD_INFO_NO(rs.getString("MOLD_INFO_NO"));
			data.setMOLD_INFO_NAME(rs.getString("MOLD_INFO_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 품질 팝업에게 json array 데이터를 전달함
	@RequestMapping(value = "/productPopup", method = RequestMethod.GET)
	public List<PRODUCT_INFO_TBL> productPopup(
			@RequestParam(value = "PRODUCT_ITEM_CODE", required = false) String PRODUCT_ITEM_CODE,
			@RequestParam(value = "PRODUCT_ITEM_NAME", required = false) String PRODUCT_ITEM_NAME) throws SQLException {
		List<PRODUCT_INFO_TBL> list = new ArrayList<PRODUCT_INFO_TBL>();

		String sql = "";

		sql = "select * from PRODUCT_INFO_TBL where (PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%' and ";
		sql += "PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_CODE + "%')";

		if (PRODUCT_ITEM_CODE == null || PRODUCT_ITEM_CODE == "") {
			PRODUCT_ITEM_CODE = "";

			sql = "select * from PRODUCT_INFO_TBL where (PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%')";
		}
		if (PRODUCT_ITEM_NAME == null || PRODUCT_ITEM_NAME == "") {
			PRODUCT_ITEM_NAME = "";

			sql = "select * from PRODUCT_INFO_TBL where (PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_CODE + "%')";
		}

		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			PRODUCT_INFO_TBL data = new PRODUCT_INFO_TBL();
			i++;
			data.setId(i);
			data.setPRODUCT_ITEM_CODE(rs.getString("PRODUCT_ITEM_CODE"));
			data.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 품질 팝업에게 json array 데이터를 전달함
	@RequestMapping(value = "/equipmentPopup", method = RequestMethod.GET)
	public List<EQUIPMENT_INFO_TBL> equipmentPopup(
			@RequestParam(value = "EQUIPMENT_INFO_CODE", required = false) String EQUIPMENT_INFO_CODE,
			@RequestParam(value = "EQUIPMENT_INFO_NAME", required = false) String EQUIPMENT_INFO_NAME)
			throws SQLException {
		List<EQUIPMENT_INFO_TBL> list = new ArrayList<EQUIPMENT_INFO_TBL>();

		String sql = "";

		sql = "select * from EQUIPMENT_INFO_TBL where (EQUIPMENT_INFO_NAME like '%" + EQUIPMENT_INFO_NAME + "%' and ";
		sql += "EQUIPMENT_INFO_CODE like '%" + EQUIPMENT_INFO_CODE + "%')";

		if (EQUIPMENT_INFO_CODE == null || EQUIPMENT_INFO_CODE == "") {
			EQUIPMENT_INFO_CODE = "";

			sql = "select * from EQUIPMENT_INFO_TBL where (EQUIPMENT_INFO_NAME like '%" + EQUIPMENT_INFO_NAME + "%' or ";
			sql += "EQUIPMENT_INFO_CODE like '%" + EQUIPMENT_INFO_NAME + "%')";
		}
		if (EQUIPMENT_INFO_NAME == null || EQUIPMENT_INFO_NAME == "") {
			EQUIPMENT_INFO_NAME = "";

			sql = "select * from EQUIPMENT_INFO_TBL where (EQUIPMENT_INFO_CODE like '%" + EQUIPMENT_INFO_CODE + "%' or ";
			sql += "EQUIPMENT_INFO_NAME like '%" + EQUIPMENT_INFO_CODE + "%')";
		}
		
		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			EQUIPMENT_INFO_TBL data = new EQUIPMENT_INFO_TBL();
			i++;
			// data.setId(i);
			data.setEQUIPMENT_INFO_CODE(rs.getString("EQUIPMENT_INFO_CODE"));
			data.setEQUIPMENT_INFO_NAME(rs.getString("EQUIPMENT_INFO_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 품질 제품별 팝업(제품코드)에게 json array 전달
	@RequestMapping(value = "/productQualityPopup", method = RequestMethod.GET)
	public List<PRODUCT_INFO_TBL> productQualityPopup(
			@RequestParam(value = "PRODUCT_ITEM_CODE", required = false) String PRODUCT_ITEM_CODE,
			@RequestParam(value = "PRODUCT_ITEM_NAME", required = false) String PRODUCT_ITEM_NAME) throws SQLException {
		List<PRODUCT_INFO_TBL> list = new ArrayList<PRODUCT_INFO_TBL>();

		String sql = "";

		sql = "select * from PRODUCT_INFO_TBL where (PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%' and ";
		sql += "PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_CODE + "%')";

		if (PRODUCT_ITEM_CODE == null || PRODUCT_ITEM_CODE == "") {
			PRODUCT_ITEM_CODE = "";

			sql = "select * from PRODUCT_INFO_TBL where (PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%' or ";
			sql += "PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_NAME + "%')";
		}
		if (PRODUCT_ITEM_NAME == null || PRODUCT_ITEM_NAME == "") {
			PRODUCT_ITEM_NAME = "";

			sql = "select * from PRODUCT_INFO_TBL where (PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_CODE + "%' or ";
			sql += "PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_CODE + "%')";
		}

		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			PRODUCT_INFO_TBL data = new PRODUCT_INFO_TBL();
			i++;
			data.setId(i);
			data.setPRODUCT_ITEM_CODE(rs.getString("PRODUCT_ITEM_CODE"));
			data.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 팝업(불량코드)에게 json array 전달
	@RequestMapping(value = "/defectQualityPopup", method = RequestMethod.GET)
	public List<DEFECT_INFO_TBL> defectQualityPopup(
			@RequestParam(value = "PRODUCTION_DEFECT_CODE", required = false) String PRODUCTION_DEFECT_CODE,
			@RequestParam(value = "PRODUCTION_DEFECT_NAME", required = false) String PRODUCTION_DEFECT_NAME)
			throws SQLException {
		List<DEFECT_INFO_TBL> list = new ArrayList<DEFECT_INFO_TBL>();

		String sql = "";

		sql = "select * from DEFECT_INFO_TBL where (DEFECT_NAME like '%" + PRODUCTION_DEFECT_NAME + "%' and ";
		sql += "DEFECT_CODE like '%" + PRODUCTION_DEFECT_CODE + "%')";
		// System.out.println(PRODUCTION_DEFECT_NAME);
		if (PRODUCTION_DEFECT_CODE == null || PRODUCTION_DEFECT_CODE == "") {
			PRODUCTION_DEFECT_CODE = "";

			sql = "select * from DEFECT_INFO_TBL where (DEFECT_NAME like '%" + PRODUCTION_DEFECT_NAME + "%' or ";
			sql += "DEFECT_CODE like '%" + PRODUCTION_DEFECT_NAME + "%')";
		}
		if (PRODUCTION_DEFECT_NAME == null || PRODUCTION_DEFECT_NAME == "") {
			PRODUCTION_DEFECT_NAME = "";

			sql = "select * from DEFECT_INFO_TBL where (DEFECT_CODE like '%" + PRODUCTION_DEFECT_CODE + "%' or ";
			sql += "DEFECT_NAME like '%" + PRODUCTION_DEFECT_CODE + "%')";
		}
		sql += " and DEFECT_USE_STATUS='true'";

		System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			DEFECT_INFO_TBL data = new DEFECT_INFO_TBL();
			i++;
			data.setId(i);
			data.setDEFECT_CODE(rs.getString("DEFECT_CODE"));
			data.setDEFECT_NAME(rs.getString("DEFECT_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 금형 팝업에게 json array 데이터를 전달함
	@RequestMapping(value = "/moldPopup2", method = RequestMethod.GET)
	public List<MOLD_INFO_TBL> moldPopup2(@RequestParam(value = "MOLD_INFO_NO", required = false) String MOLD_INFO_NO,
			@RequestParam(value = "MOLD_INFO_NAME", required = false) String MOLD_INFO_NAME) throws SQLException {
		List<MOLD_INFO_TBL> list = new ArrayList<MOLD_INFO_TBL>();

		String sql = "";

		sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%' and ";
		sql += "MOLD_INFO_NO like '%" + MOLD_INFO_NO + "%'";

		if (MOLD_INFO_NO == null || MOLD_INFO_NO == "") {
			MOLD_INFO_NO = "";

			sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%'";
		}
		if (MOLD_INFO_NAME == null || MOLD_INFO_NAME == "") {
			MOLD_INFO_NAME = "";

			sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%'";
		}

		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			MOLD_INFO_TBL data = new MOLD_INFO_TBL();
			i++;
			// data.setId(i);
			data.setMOLD_INFO_NO(rs.getString("MOLD_INFO_NO"));
			data.setMOLD_INFO_NAME(rs.getString("MOLD_INFO_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 품질 팝업에게 json array 데이터를 전달함
	@RequestMapping(value = "/productPopup2", method = RequestMethod.GET)
	public List<PRODUCT_INFO_TBL> productPopup2(
			@RequestParam(value = "PRODUCT_ITEM_CODE", required = false) String PRODUCT_ITEM_CODE,
			@RequestParam(value = "PRODUCT_ITEM_NAME", required = false) String PRODUCT_ITEM_NAME) throws SQLException {
		List<PRODUCT_INFO_TBL> list = new ArrayList<PRODUCT_INFO_TBL>();

		String sql = "";

		sql = "select * from PRODUCT_INFO_TBL where PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%' and ";
		sql += "PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_CODE + "%'";

		if (PRODUCT_ITEM_CODE == null || PRODUCT_ITEM_CODE == "") {
			PRODUCT_ITEM_CODE = "";

			sql = "select * from PRODUCT_INFO_TBL where PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%'";
		}
		if (PRODUCT_ITEM_NAME == null || PRODUCT_ITEM_NAME == "") {
			PRODUCT_ITEM_NAME = "";

			sql = "select * from PRODUCT_INFO_TBL where PRODUCT_ITEM_CODE like '%" + PRODUCT_ITEM_CODE + "%'";
		}

		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			PRODUCT_INFO_TBL data = new PRODUCT_INFO_TBL();
			i++;
			data.setId(i);
			data.setPRODUCT_ITEM_CODE(rs.getString("PRODUCT_ITEM_CODE"));
			data.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 품질 팝업에게 json array 데이터를 전달함
	@RequestMapping(value = "/equipmentPopup2", method = RequestMethod.GET)
	public List<EQUIPMENT_INFO_TBL> equipmentPopup2(
			@RequestParam(value = "EQUIPMENT_INFO_CODE", required = false) String EQUIPMENT_INFO_CODE,
			@RequestParam(value = "EQUIPMENT_INFO_NAME", required = false) String EQUIPMENT_INFO_NAME)
			throws SQLException {
		List<EQUIPMENT_INFO_TBL> list = new ArrayList<EQUIPMENT_INFO_TBL>();

		String sql = "";

		sql = "select * from EQUIPMENT_INFO_TBL where EQUIPMENT_INFO_NAME like '%" + EQUIPMENT_INFO_NAME + "%' and ";
		sql += "EQUIPMENT_INFO_CODE like '%" + EQUIPMENT_INFO_CODE + "%'";

		if (EQUIPMENT_INFO_CODE == null || EQUIPMENT_INFO_CODE == "") {
			EQUIPMENT_INFO_CODE = "";

			sql = "select * from EQUIPMENT_INFO_TBL where EQUIPMENT_INFO_NAME like '%" + EQUIPMENT_INFO_NAME + "%'";
		}
		if (EQUIPMENT_INFO_NAME == null || EQUIPMENT_INFO_NAME == "") {
			EQUIPMENT_INFO_NAME = "";

			sql = "select * from EQUIPMENT_INFO_TBL where EQUIPMENT_INFO_NAME like '%" + EQUIPMENT_INFO_NAME + "%'";
		}

		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			EQUIPMENT_INFO_TBL data = new EQUIPMENT_INFO_TBL();
			i++;
			// data.setId(i);
			data.setEQUIPMENT_INFO_CODE(rs.getString("EQUIPMENT_INFO_CODE"));
			data.setEQUIPMENT_INFO_NAME(rs.getString("EQUIPMENT_INFO_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 품질 설비별 팝업(설비코드)에게 json array 전달
	@RequestMapping(value = "/equipmentQualityPopup", method = RequestMethod.GET)
	public List<EQUIPMENT_INFO_TBL> equipmentQualityPopup(
			@RequestParam(value = "PRODUCTION_EQUIPMENT_CODE", required = false) String PRODUCTION_EQUIPMENT_CODE,
			@RequestParam(value = "PRODUCTION_EQUIPMENT_INFO_NAME", required = false) String PRODUCTION_EQUIPMENT_INFO_NAME)
			throws SQLException {
		List<EQUIPMENT_INFO_TBL> list = new ArrayList<EQUIPMENT_INFO_TBL>();

		String sql = "";

		sql = "select * from EQUIPMENT_INFO_TBL where EQUIPMENT_INFO_NAME like '%" + PRODUCTION_EQUIPMENT_INFO_NAME
				+ "%' and ";
		sql += "EQUIPMENT_INFO_CODE like '%" + PRODUCTION_EQUIPMENT_CODE + "%'";

		if (PRODUCTION_EQUIPMENT_CODE == null || PRODUCTION_EQUIPMENT_CODE == "") {
			PRODUCTION_EQUIPMENT_CODE = "";

			sql = "select * from EQUIPMENT_INFO_TBL where EQUIPMENT_INFO_NAME like '%" + PRODUCTION_EQUIPMENT_INFO_NAME
					+ "%' or ";
			sql += "EQUIPMENT_INFO_CODE like '%" + PRODUCTION_EQUIPMENT_INFO_NAME + "%'";
		}
		if (PRODUCTION_EQUIPMENT_INFO_NAME == null || PRODUCTION_EQUIPMENT_INFO_NAME == "") {
			PRODUCTION_EQUIPMENT_INFO_NAME = "";

			sql = "select * from EQUIPMENT_INFO_TBL where EQUIPMENT_INFO_CODE like '%" + PRODUCTION_EQUIPMENT_CODE
					+ "%' or ";
			sql += "EQUIPMENT_INFO_NAME like '%" + PRODUCTION_EQUIPMENT_CODE + "%'";
		}

		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			EQUIPMENT_INFO_TBL data = new EQUIPMENT_INFO_TBL();
			i++;
			data.setId(i);
			data.setEQUIPMENT_INFO_CODE(rs.getString("EQUIPMENT_INFO_CODE"));
			data.setEQUIPMENT_INFO_NAME(rs.getString("EQUIPMENT_INFO_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

	// 품질 설비별 팝업(금형코드)에게 json array 전달
	@RequestMapping(value = "/moldQualityPopup", method = RequestMethod.GET)
	public List<MOLD_INFO_TBL> moldQualityPopup(
			@RequestParam(value = "MOLD_INFO_NO", required = false) String MOLD_INFO_NO,
			@RequestParam(value = "MOLD_INFO_NAME", required = false) String MOLD_INFO_NAME) throws SQLException {
		List<MOLD_INFO_TBL> list = new ArrayList<MOLD_INFO_TBL>();

		String sql = "";

		sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%' and ";
		sql += "MOLD_INFO_NO like '%" + MOLD_INFO_NO + "%'";

		if (MOLD_INFO_NO == null || MOLD_INFO_NO == "") {
			MOLD_INFO_NO = "";

			sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%' or ";
			sql += "MOLD_INFO_NO like '%" + MOLD_INFO_NAME + "%'";
		}
		if (MOLD_INFO_NAME == null || MOLD_INFO_NAME == "") {
			MOLD_INFO_NAME = "";

			sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NO like '%" + MOLD_INFO_NO + "%' or ";
			sql += "MOLD_INFO_NAME like '%" + MOLD_INFO_NO + "%'";
		}

		// System.out.println(sql);

		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();

		int i = 0;
		while (rs.next()) {
			MOLD_INFO_TBL data = new MOLD_INFO_TBL();
			i++;
			data.setId(i);
			data.setMOLD_INFO_NO(rs.getString("MOLD_INFO_NO"));
			data.setMOLD_INFO_NAME(rs.getString("MOLD_INFO_NAME"));
			list.add(data);
		}

		rs.close();
		pstmt.close();
		conn.close();

		return list;
	}

}
