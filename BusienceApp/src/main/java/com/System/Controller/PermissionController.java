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

@Controller("PermissionController")
@RequestMapping("permission")
public class PermissionController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "",method = {RequestMethod.GET})
	public String list(Model model,HttpServletRequest request) throws SQLException
	{
		return "System/Permission";
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
				
				String sql = "UPDATE `RIGHTS_MGMT_TBL`"
						+ "SET "
						+ "RIGHTS_MGMT_USE_STATUS = '"+datas.get("rights_MGMT_USE_STATUS")+"'"
						+ "WHERE RIGHTS_USER_TYPE = '"+datas.get("rights_USER_TYPE")+"' AND RIGHTS_PROGRAM_CODE = '"+datas.get("rights_PROGRAM_CODE")+"'";
				//System.out.println(sql);
				
				HomeController.LogInsert("", "2. Update", sql, request);
				
				Connection conn = dataSource.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
				pstmt.close();
				conn.close();
			}
		}
		
		return "redirect:/permission";
	}
	
}
