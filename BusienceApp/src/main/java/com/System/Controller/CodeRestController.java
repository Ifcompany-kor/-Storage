package com.System.Controller;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Common.Controller.HomeController;
import com.Standard.Dto.CMN_TBL;
import com.Standard.Dto.DTL_TBL;

@RestController("CodeRestController")
@RequestMapping("CodeRest")
public class CodeRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/view.do",method = RequestMethod.GET)
	public List<CMN_TBL> view(HttpServletRequest request) throws SQLException
	{
		List<CMN_TBL> list = new ArrayList<CMN_TBL>();
		
		String sql = "select * from CMN_TBL";
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while (rs.next()) {
			CMN_TBL data = new CMN_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setNEW_TBL_NAME(rs.getString("NEW_TBL_NAME"));
			if(rs.getString("NEW_TBL_INDEX")==null)
				data.setNEW_TBL_INDEX("");
			else
				data.setNEW_TBL_INDEX(rs.getString("NEW_TBL_INDEX"));
			
			list.add(data);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
	}
	
	@RequestMapping(value = "/view2.do",method = RequestMethod.GET)
	public List<DTL_TBL> view2(HttpServletRequest request) throws SQLException
	{
		List<DTL_TBL> list = new ArrayList<DTL_TBL>();
		
		String sql = "select * from DTL_TBL";
		sql += " where NEW_TBL_CODE="+request.getParameter("NEW_TBL_CODE")+" order by CHILD_TBL_NUM+0";
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while (rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_RMARK(rs.getString("CHILD_TBL_RMARK"));
			data.setCHILD_TBL_USE_STATUS(rs.getString("CHILD_TBL_USE_STATUS"));
			list.add(data);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
	}
	
	@RequestMapping(value = "/insert.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String insert(HttpServletRequest request) throws SQLException, UnknownHostException, ClassNotFoundException
	{
		String NEW_TBL_CODE = request.getParameter("NEW_TBL_CODE");
		String CHILD_TBL_TYPE = request.getParameter("CHILD_TBL_TYPE");
		String CHILD_TBL_RMARK = request.getParameter("CHILD_TBL_RMARK");
		String CHILD_TBL_USE_STATUS = request.getParameter("CHILD_TBL_USE_STATUS");
		
		String sql = "select max(CHILD_TBL_NUM+0)+1 CHILD_TBL_NUM from DTL_TBL where ";
		sql += "NEW_TBL_CODE = '"+NEW_TBL_CODE+"'";
		
		//System.out.println(sql);
		
		String CHILD_TBL_NUM = "";
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		while (rs.next())
			CHILD_TBL_NUM = rs.getString("CHILD_TBL_NUM");
		
		//System.out.println(CHILD_TBL_NUM);
		
		sql = "INSERT INTO DTL_TBL "
				+ "VALUES "
				+ "('"+NEW_TBL_CODE+"',"
				+ "'"+CHILD_TBL_NUM+"',"
				+ "'"+CHILD_TBL_TYPE+"',"
				+ "'"+CHILD_TBL_RMARK+"',"
				+ "'"+CHILD_TBL_USE_STATUS+"')";
		
		HomeController.LogInsert("", "1. Insert", sql, request);
		
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		rs.close();
		pstmt.close();
		conn.close();
		
		return "Success";
	}
	
	@RequestMapping(value = "/update.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String update(HttpServletRequest request) throws SQLException, UnknownHostException, ClassNotFoundException
	{
		String NEW_TBL_CODE = request.getParameter("NEW_TBL_CODE");
		String CHILD_TBL_NUM = request.getParameter("CHILD_TBL_NUM");
		String CHILD_TBL_TYPE = request.getParameter("CHILD_TBL_TYPE");
		String CHILD_TBL_RMARK = request.getParameter("CHILD_TBL_RMARK");
		String CHILD_TBL_USE_STATUS = request.getParameter("CHILD_TBL_USE_STATUS");
		
		String sql = "update DTL_TBL set ";
		sql += "CHILD_TBL_TYPE='"+CHILD_TBL_TYPE+"'";
		sql += ",CHILD_TBL_RMARK='"+CHILD_TBL_RMARK+"'";
		sql += ",CHILD_TBL_USE_STATUS='"+CHILD_TBL_USE_STATUS+"'";
		sql += " where NEW_TBL_CODE="+NEW_TBL_CODE;
		sql += " and CHILD_TBL_NUM="+CHILD_TBL_NUM;
		
		//System.out.println(sql);
		HomeController.LogInsert("", "2. Update", sql, request);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
		
		return "Success";
	}
	
}
