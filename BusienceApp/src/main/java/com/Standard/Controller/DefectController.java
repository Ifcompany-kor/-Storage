package com.Standard.Controller;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.Common.Controller.HomeController;

@Controller("DefectController")
@RequestMapping("defect")
public class DefectController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "",method = {RequestMethod.GET})
	public String list(Model model)
	{
		return "Standard/Defect";
	}
	
	@RequestMapping(value = "update",method = {RequestMethod.POST})
	public String update(HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException
	{
		String data = request.getParameter("dataList");
		//System.out.println(data);
		HttpSession httpSession = request.getSession();
		String modifier = (String) httpSession.getAttribute("id");
		//System.out.println(modifier);
		
		JSONParser parser = new JSONParser();
		JSONObject obj  = (JSONObject)parser.parse(data);
		
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		String datestr = sdf.format(date.getTime());
		
		String sql = "update DEFECT_INFO_TBL set DEFECT_NAME='"+(String)obj.get("defectName");
		sql += "',DEFECT_ABR='"+(String)obj.get("defectABR");
		sql += "',DEFECT_USE_STATUS='"+(String)obj.get("defectSTATUS");
		sql += "',DEFECT_RMRKS='"+(String)obj.get("DEFECT_RMRKS");
		sql += "',DEFECT_MODIFIER='"+modifier;
		sql += "',DEFECT_MODIFY_D='"+datestr;
		sql += "' where DEFECT_CODE='"+(String)obj.get("defectCode")+"'";
		
		//System.out.println(sql);
		HomeController.LogInsert("", "2. Update", sql, request);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
		
		return "redirect:/defect";
	}
	
	@RequestMapping(value = "delete",method = {RequestMethod.POST})
	public String delete(HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException
	{
		String no = request.getParameter("DEFECT_CODE");
		
		String sql = "delete from DEFECT_INFO_TBL where DEFECT_CODE = '"+no+"'";
		
		HomeController.LogInsert("", "3. Delete", sql, request);
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
		
		return "redirect:/defect";
	}
	
}
