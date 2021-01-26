package com.Common.Controller;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.net.http.HttpRequest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.Standard.Dto.DTL_TBL;

@Controller
public class HomeController {
	
	@Autowired
	SimpleDriverDataSource dataSource;
	
	public static void LogInsert(String PROGRAM_NAME,String BTN_NUM,String LOG_SQL,HttpServletRequest request) throws SQLException, UnknownHostException, ClassNotFoundException
	{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://xeonic11.cafe24.com:3306/xeonic11","xeonic11","gil45200!");
		
		//Connection conn = dataSource.getConnection();
		HttpSession session = request.getSession();
		
		InetAddress ip = InetAddress.getLocalHost(); 
		String COM_NAME = ip.getHostName();
		String IP_NO = ip.getHostAddress();
		
		String sql = "INSERT INTO `LOG_TBL`\r\n"
				+ "(\r\n"
				+ "`PROGRAM_NAME`,\r\n"
				+ "`BTN_NUM`,\r\n"
				+ "`LOG_SQL`,\r\n"
				+ "`USER_NAME`,\r\n"
				+ "`IP_NO`,\r\n"
				+ "`COM_NAME`)\r\n"
				+ "VALUES\r\n"
				+ "(";
		sql += "'" + PROGRAM_NAME + "',";
		sql += "'" + BTN_NUM + "',";
		sql += "\"" + LOG_SQL + "\",";
		sql += "'" + session.getAttribute("name") + "',";
		sql += "'" + IP_NO + "',";
		sql += "'" + COM_NAME + "'";
		sql += ")";
		
		//System.out.println(sql);
		
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.execute();
		
		pstmt.close();
		con.close();
	}
	
	@RequestMapping(value = "/", method = {RequestMethod.GET})
	public String home() {
		return "Common/login";
	}
	
	@RequestMapping(value = "/main", method = {RequestMethod.GET})
	public String main(Model model,HttpServletRequest request) throws SQLException {
		List<DTL_TBL> list = new ArrayList<DTL_TBL>();
		
		HttpSession session = request.getSession();
		
		/*
		String sql = "select\r\n"
				+ "			t1.RIGHTS_MGMT_USE_STATUS CHILD_TBL_USE_STATUS\r\n"
				+ "        ,	t2.CHILD_TBL_TYPE\r\n"
				+ "        ,	t2.CHILD_TBL_RMARK\r\n"
				+ "from\r\n"
				+ "		(\r\n"
				+ "			select\r\n"
				+ "					*\r\n"
				+ "			from\r\n"
				+ "					RIGHTS_MGMT_TBL\r\n"
				+ "			where\r\n"
				+ "					RIGHTS_USER_TYPE = '"+session.getAttribute("type")+"'"
				+ "        ) t1\r\n"
				+ "left outer join \r\n"
				+ "		(\r\n"
				+ "			select \r\n"
				+ "					* \r\n"
				+ "			from DTL_TBL where NEW_TBL_CODE='13'\r\n"
				+ "        ) t2\r\n"
				+ "on t1.RIGHTS_PROGRAM_CODE = t2.CHILD_TBL_NUM"
				+ " order by t1.RIGHTS_PROGRAM_CODE+0";
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		while (rs.next()) 
		{
			DTL_TBL inputdata = new DTL_TBL();
			
			//inputdata.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			//inputdata.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			inputdata.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			
			String[] array = rs.getString("CHILD_TBL_RMARK").split("/");
			inputdata.setURL(array[0]);
			inputdata.setPARENT(array[1]);
			inputdata.setCHILD_TBL_USE_STATUS(rs.getString("CHILD_TBL_USE_STATUS"));
			list.add(inputdata);
		}
		*/
		
		String sql = "select \r\n"
				+ "		ifnull(t1.MENU_MGMT_USE_STATUS,'true') CHILD_TBL_USE_STATUS,\r\n"
				+ "        t2.CHILD_TBL_TYPE MENU_PROGRAM_NAME,\r\n"
				+ "		t2.CHILD_TBL_RMARK,\r\n"
				+ "		t2.CHILD_TBL_TYPE,\r\n"	
				+ "		t2.CHILD_TBL_NUM\r\n"	
				+ "from	\r\n"
				+ "		(\r\n"
				+ "			select\r\n"
				+ "					*\r\n"
				+ "			from\r\n"
				+ "					MENU_MGMT_TBL\r\n"
				+ "			where MENU_USER_CODE = '"+session.getAttribute("id")+"'\r\n"
				+ "        ) t1\r\n"
				+ "right outer join \r\n"
				+ "		(\r\n"
				+ "			select \r\n"
				+ "					* \r\n"
				+ "			from DTL_TBL where NEW_TBL_CODE='13'\r\n"
				+ "        ) t2\r\n"
				+ "on t1.MENU_PROGRAM_CODE = t2.CHILD_TBL_NUM"
				+ " order by t2.CHILD_TBL_NUM+0";
		
		//System.out.println(sql);
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		while (rs.next()) 
		{
			DTL_TBL inputdata = new DTL_TBL();
			
			inputdata.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			inputdata.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			
			String[] array = rs.getString("CHILD_TBL_RMARK").split("/");
			inputdata.setURL(array[0]);
			inputdata.setPARENT(array[1]);
			inputdata.setCHILD_TBL_USE_STATUS(rs.getString("CHILD_TBL_USE_STATUS"));
			list.add(inputdata);
		}
		
		/*
		for (int i = 0; i < list.size(); i++) {
			try
			{
				if(list.get(i).getCHILD_TBL_TYPE().equals(list2.get(i).getCHILD_TBL_TYPE()))
				{
					if(!list2.get(i).getCHILD_TBL_USE_STATUS().equals(list.get(i).getCHILD_TBL_USE_STATUS()))
					{
						list.get(i).setCHILD_TBL_USE_STATUS(list2.get(i).getCHILD_TBL_USE_STATUS());
					}
				}
			}
			catch(Exception ex)
			{
				//System.out.println(ex.getMessage());
			}
		}
		*/
		
		session.setAttribute("catagorylist", list);
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return "main";
	}
	
	@RequestMapping(value = "/index", method = {RequestMethod.GET})
	public String index() {
		return "index";
	}
	
	@RequestMapping(value = "/pwchange", method = {RequestMethod.GET})
	public String pwchange() {
		return "Common/pwchange";
	}
	
	@RequestMapping(value = "/logout", method = {RequestMethod.GET})
	public String logout(HttpServletRequest request) throws UnknownHostException, ClassNotFoundException, SQLException {
		HomeController.LogInsert("", "4. Log Out", "", request);
		
		HttpSession session = request.getSession();
		session.invalidate();
		return "Common/login";
	}
	
}
