package com.System.Controller;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
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

@Controller("MenuController")
@RequestMapping("menu")
public class MenuController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "",method = {RequestMethod.GET})
	public String list(Model model,HttpServletRequest request) throws SQLException
	{
		return "System/Menu";
	}
	
	@RequestMapping(value = "update",method = {RequestMethod.POST})
	public String update(HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException
	{
		String data = request.getParameter("dataList");
		String modifier = request.getParameter("modifier");
		//System.out.println(modifier);
		
		JSONParser parser = new JSONParser();
		JSONObject obj  = (JSONObject)parser.parse(data);
		JSONArray dataList = (JSONArray) obj.get("data");
		
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		String datestr = sdf.format(date.getTime());
		
		if(dataList.size() > 0)
		{
			for (int i = 0; i < dataList.size(); i++)
			{
				JSONObject datas = (JSONObject) dataList.get(i);
				//System.out.println(datas.toJSONString());
				
				
				String sql = "UPDATE MENU_MGMT_TBL\r\n"
						+ "SET\r\n"
						+ "MENU_READ_USE_STATUS = '"+datas.get("menu_READ_USE_STATUS")+"',\r\n"
						+ "MENU_WRITE_USE_STATUS = '"+datas.get("menu_WRITE_USE_STATUS")+"',\r\n"
						+ "MENU_DEL_USE_STATUS = '"+datas.get("menu_DEL_USE_STATUS")+"',\r\n";
				/*
				String sql = "UPDATE MENU_MGMT_TBL\r\n"
						+ "SET\r\n"
						+ "MENU_READ_USE_STATUS = '"+"true"+"',\r\n"
						+ "MENU_WRITE_USE_STATUS = '"+"true"+"',\r\n"
						+ "MENU_DEL_USE_STATUS = '"+"true"+"',\r\n";
				*/
				
				HttpSession session = request.getSession();
				
				if(datas.get("menu_READ_USE_STATUS").equals("false"))
					sql		+= "MENU_MGMT_USE_STATUS = '"+"false"+"'\r\n";
				else
					sql		+= "MENU_MGMT_USE_STATUS = '"+datas.get("menu_MGMT_USE_STATU")+"'\r\n";
						
				sql		+= "WHERE MENU_USER_CODE = '"+datas.get("menu_USER_CODE")+"'\r\n";
				sql		+= "AND MENU_PROGRAM_CODE = '"+datas.get("menu_PROGRAM_CODE")+"'";
				
				HomeController.LogInsert("", "2. Update", sql, request);
				
				//System.out.println(sql);
				Connection conn = dataSource.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
				pstmt.close();
				conn.close();
			}
		}
		
		return "redirect:/menu";
	}
	
}
