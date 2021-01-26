package com.Standard.Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.Standard.Dto.DTL_TBL;
import com.Standard.Dto.EQUIPMENT_INFO_TBL;

@Controller("EquipmentController")
@RequestMapping("equipment")
public class EquipmentController {
	
	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value="", method=RequestMethod.GET)
	public String list(Model model) throws SQLException
	{
		
		// 사업장 불러오는 쿼리
		String sql = "select * from DTL_TBL where NEW_TBL_CODE = '2' and CHILD_TBL_USE_STATUS='true'";
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		List<DTL_TBL> companyList = new ArrayList<DTL_TBL>();
		
		while(rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("사업장 : " + data.toString());
			companyList.add(data);
		}
		
		// 설비상태 불러오는 쿼리
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '12' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> equipmentStatusList = new ArrayList<DTL_TBL>();
		
		while(rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("설비상태 : " + data.toString());
			equipmentStatusList.add(data);
		}
		// 설비 정보 관리 list 
		List<EQUIPMENT_INFO_TBL> equipmentList = new ArrayList<EQUIPMENT_INFO_TBL>();
		
		sql = "SELECT A.EQUIPMENT_USE_STATUS,A.EQUIPMENT_BUSINESS_PLACE,A.EQUIPMENT_INFO_CODE,A.EQUIPMENT_INFO_NAME,A.EQUIPMENT_INFO_ABR,A.EQUIPMENT_HEIGHT,A.EQUIPMENT_WIDTH,A.EQUIPMENT_DEPTH,A.EQUIPMENT_SERIAL_NUM,A.EQUIPMENT_WEIGHT,A.EQUIPMENT_RECEIVED_D,A.EQUIPMENT_MODEL_YEAR,A.EQUIPMENT_MANUFACTURER,A.EQUIPMENT_STATUS,A.EQUIPMENT_INFO_RMARK,A.EQUIPMENT_MODIFY_D,D.USER_NAME EQUIPMENT_MODIFIER, B.CHILD_TBL_TYPE AS EQUIPMENT_BUSINESS_PLACE_NAME, C.CHILD_TBL_TYPE AS EQUIPMENT_STATUS_NAME FROM EQUIPMENT_INFO_TBL A INNER JOIN DTL_TBL B ON A.EQUIPMENT_BUSINESS_PLACE = B.CHILD_TBL_NUM INNER JOIN DTL_TBL C ON A.EQUIPMENT_STATUS = C.CHILD_TBL_NUM INNER JOIN USER_INFO_TBL D ON A.EQUIPMENT_MODIFIER = D.USER_CODE  WHERE B.NEW_TBL_CODE=2 and  C.NEW_TBL_CODE=12";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		System.out.println(sql);
		
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
		
		
		model.addAttribute("companyList", companyList);
		model.addAttribute("equipmentStatusList", equipmentStatusList);
		model.addAttribute("equipmentList", equipmentList);
		
		rs.close();
		pstmt.close();
		conn.close();
		
		
		return "Standard/Equipment";
	}
	
	@RequestMapping(value = "/equip_ItemCode",method = {RequestMethod.GET})
	public String Equip_ItemCode(Model model)
	{
		return "PopUp/Standard/Equip_ItemCode";
	}	
	
}
