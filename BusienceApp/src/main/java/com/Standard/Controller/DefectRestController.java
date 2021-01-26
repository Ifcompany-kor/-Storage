package com.Standard.Controller;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Common.Controller.HomeController;
import com.Standard.Dto.DEFECT_INFO_TBL;

@RestController("DefectRestController")
@RequestMapping("defectRest")
public class DefectRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/view.do",method = RequestMethod.GET)
	public List<DEFECT_INFO_TBL> view() throws SQLException
	{
		List<DEFECT_INFO_TBL> list = new ArrayList<DEFECT_INFO_TBL>();
		
		String sql = "select \r\n"
				+ "		t1.DEFECT_CODE,\r\n"
				+ "        t1.DEFECT_NAME,\r\n"
				+ "        t1.DEFECT_ABR,\r\n"
				+ "        t1.DEFECT_RMRKS,\r\n"
				+ "        t1.DEFECT_MODIFY_D,\r\n"
				+ "        t2.USER_NAME DEFECT_MODIFIER,\r\n"
				+ "        t1.DEFECT_USE_STATUS\r\n"
				+ "from DEFECT_INFO_TBL t1\r\n"
				+ "inner join USER_INFO_TBL t2 on t1.DEFECT_MODIFIER = t2.USER_CODE";
		
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
			data.setDEFECT_ABR(rs.getString("DEFECT_ABR"));
			data.setDEFECT_MODIFIER(rs.getString("DEFECT_MODIFIER"));
			data.setDEFECT_MODIFY_D(rs.getString("DEFECT_MODIFY_D"));
			data.setDEFECT_RMRKS(rs.getString("DEFECT_RMRKS"));
			data.setDEFECT_USE_STATUS(rs.getString("DEFECT_USE_STATUS"));
			//System.out.println(data.toString());
			list.add(data);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
	}
	
	@RequestMapping(value = "/insert.do",method = RequestMethod.POST)
	public String insert(HttpServletRequest request) throws SQLException, UnknownHostException, ClassNotFoundException
	{
		Connection conn = dataSource.getConnection();
		
		String DEFECT_CODE = request.getParameter("defectCode");
		String DEFECT_NAME = request.getParameter("defectName");
		String DEFECT_ABR = request.getParameter("defectABR");
		String defectSTATUS = request.getParameter("defectSTATUS");
		String DEFECT_RMRKS = request.getParameter("DEFECT_RMRKS");
		
		HttpSession httpSession = request.getSession();
		String DEFECT_MODIFIER = (String) httpSession.getAttribute("id");
		
		if(DEFECT_CODE.equals(""))
			return "None";
		
		String checkSql = "select DEFECT_CODE from DEFECT_INFO_TBL where DEFECT_CODE='"+DEFECT_CODE+"'";
		//System.out.println(checkSql);
		PreparedStatement pstmt = conn.prepareStatement(checkSql);
		ResultSet rs = pstmt.executeQuery();
		
		while (rs.next())
		{
			String check_DEFECT_CODE = rs.getString("DEFECT_CODE");
			
			if(check_DEFECT_CODE.length() > 0)
				return "Overlap";
		}
		
		//System.out.println("defectCode : "+DEFECT_CODE);
		//System.out.println("defectName : "+DEFECT_NAME);
		//System.out.println("defectABR : "+DEFECT_ABR);
		//System.out.println("defectSTATUS : "+defectSTATUS);
		//System.out.println("DEFECT_RMRKS : "+DEFECT_RMRKS);
		//System.out.println("DEFECT_MODIFIER : "+DEFECT_MODIFIER);
		
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		String datestr = sdf.format(date.getTime());
		
		String sql = "insert into DEFECT_INFO_TBL(DEFECT_CODE,DEFECT_NAME,DEFECT_ABR,DEFECT_RMRKS,DEFECT_USE_STATUS,DEFECT_MODIFY_D,DEFECT_MODIFIER) values ('";
		sql += DEFECT_CODE;
		sql += "','"+DEFECT_NAME;
		sql += "','"+DEFECT_ABR;
		sql += "','"+DEFECT_RMRKS;
		sql += "','"+defectSTATUS;
		sql += "','"+datestr;
		sql += "','"+DEFECT_MODIFIER+"')";
		
		HomeController.LogInsert("", "1. Insert", sql, request);
		//HomeController.LogInsert("", datestr, sql, request);
		
		//System.out.println(sql);
		
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
		
		return "Success";
	}
	
}
