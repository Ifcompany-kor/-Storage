package com.Standard.Controller;

import java.net.UnknownHostException;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

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
	
	@RequestMapping(value = "delete",method = {RequestMethod.POST})
	public void delete(HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException
	{
		String no = request.getParameter("DEFECT_CODE");
		
		String sql = "delete from DEFECT_INFO_TBL where DEFECT_CODE = '"+no+"'";
		
		//HomeController.LogInsert("", "3. Delete", sql, request);
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
	@RequestMapping(value = "update",method = {RequestMethod.POST})
	public void update(DEFECT_INFO_TBL dtl) throws Exception
	{
		System.out.println(dtl.toString());
		
		String sql = "update DEFECT_INFO_TBL set DEFECT_NAME='"+dtl.getDEFECT_NAME();
		sql += "',DEFECT_ABR='"+dtl.getDEFECT_ABR();
		sql += "',DEFECT_USE_STATUS='"+dtl.getDEFECT_USE_STATUS();
		sql += "',DEFECT_RMRKS='"+dtl.getDEFECT_RMRKS();
		sql += "',DEFECT_MODIFIER='admin";
		sql += "' where DEFECT_CODE='"+dtl.getDEFECT_CODE()+"'";
		
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
	}
	
}
