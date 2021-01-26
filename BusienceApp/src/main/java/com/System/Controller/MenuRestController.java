package com.System.Controller;

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

import com.Standard.Dto.MENU_MGMT_TBL;

@RestController("MenuRestController")
@RequestMapping("MenuRest")
public class MenuRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/view.do",method = RequestMethod.GET)
	public List<MENU_MGMT_TBL> view(HttpServletRequest request) throws SQLException
	{
		List<MENU_MGMT_TBL> list = new ArrayList<MENU_MGMT_TBL>();
		
		String sql = "select \r\n"
				+ "		t1.*,\r\n"
				+ "        t2.CHILD_TBL_TYPE MENU_PROGRAM_NAME\r\n"
				+ "from	\r\n"
				+ "		(\r\n"
				+ "			select\r\n"
				+ "					*\r\n"
				+ "			from\r\n"
				+ "					MENU_MGMT_TBL\r\n"
				+ "			where MENU_USER_CODE = '"+request.getParameter("MENU_USER_CODE")+"'\r\n"
				+ "        ) t1\r\n"
				+ "left outer join \r\n"
				+ "		(\r\n"
				+ "			select \r\n"
				+ "					* \r\n"
				+ "			from DTL_TBL where NEW_TBL_CODE='13'\r\n"
				+ "        ) t2\r\n"
				+ "on t1.MENU_PROGRAM_CODE = t2.CHILD_TBL_NUM"
				+ " order by MENU_PROGRAM_CODE+0";
		
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while (rs.next()) {
			MENU_MGMT_TBL data = new MENU_MGMT_TBL();
			data.setMENU_USER_CODE(rs.getString("MENU_USER_CODE"));
			data.setMENU_PROGRAM_CODE(rs.getString("MENU_PROGRAM_CODE"));
			data.setMENU_READ_USE_STATUS(rs.getString("MENU_READ_USE_STATUS"));
			data.setMENU_WRITE_USE_STATUS(rs.getString("MENU_WRITE_USE_STATUS"));
			data.setMENU_DEL_USE_STATUS(rs.getString("MENU_DEL_USE_STATUS"));
			data.setMENU_MGMT_USE_STATU(rs.getString("MENU_MGMT_USE_STATUS"));
			data.setMENU_PROGRAM_NAME(rs.getString("MENU_PROGRAM_NAME"));
			list.add(data);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
	}
	
}
