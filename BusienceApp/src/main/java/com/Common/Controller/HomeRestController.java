package com.Common.Controller;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Standard.Dto.DTL_TBL;
import com.System.Dto.RIGHTS_MGMT_TBL;

@RestController
public class HomeRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/login", method = {RequestMethod.GET,RequestMethod.POST})
	public String login2(HttpServletRequest request,Model model) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException {
		
		String data = request.getParameter("usetData");
		JSONParser parser = new JSONParser();
		JSONObject obj  = (JSONObject)parser.parse(data);
		
		//System.out.println(obj.toJSONString());
		
		if(obj.get("inputId").equals(""))
			return "inputIdNone";
		if(obj.get("inputPass").equals(""))
			return "inputPassNone";
		
		Connection conn = dataSource.getConnection();
		String sql = "select USER_CODE,USER_USE_STATUS from USER_INFO_TBL where USER_CODE='"+obj.get("inputId")+"'";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		String idFlag = "";
		
		String USER_CODE_FLAG = "";
		String USER_USE_STATUS_FLAG = "";
		while(rs.next())
		{
			USER_CODE_FLAG = rs.getString("USER_CODE");
			USER_USE_STATUS_FLAG = rs.getString("USER_USE_STATUS");
		}
		
		if(USER_CODE_FLAG.equals(""))
			return "IdNot";
		
		if(USER_USE_STATUS_FLAG.equals("false"))
			return "IdNot2";
		
		sql = "select USER_TYPE,USER_CODE,USER_NAME, CONVERT(aes_decrypt(unhex(USER_PASSWORD),'a')using euckr) USER_PW from USER_INFO_TBL";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		String flag = "";
		while (rs.next()) 
		{
			//System.out.println(rs.getString("USER_PW"));
			//System.out.println(obj.get("inputPass"));
			String USER_CODE = rs.getString("USER_CODE");
			String USER_NAME = rs.getString("USER_NAME");
			String USER_TYPE = rs.getString("USER_TYPE");
			
			if(obj.get("inputId").equals(USER_CODE))
			{
				if(rs.getString("USER_PW").equals(obj.get("inputPass")))
				{
					HttpSession session = request.getSession();
					session.setAttribute("id", USER_CODE);
					session.setAttribute("name", USER_NAME);
					session.setAttribute("type", USER_TYPE);
					
					//System.out.println(USER_NAME);
					
					flag = "loginSuccess";
				}
				else
					flag = "loginFail";
			}
		}
		
		HomeController.LogInsert("", "5. Log in", sql, request);
		
		List<DTL_TBL> list = new ArrayList<DTL_TBL>();
		
		sql = "SELECT * FROM DTL_TBL where NEW_TBL_CODE = '13'";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		while (rs.next()) 
		{
			/*
			for(int i=1 ; i<=columnCnt ; i++){
				                // 컬럼명                                   //데이터
				System.out.println(rsmd.getColumnName(i)+","+rs.getString(rsmd.getColumnName(i)));  
			}
			*/
			DTL_TBL inputdata = new DTL_TBL();
			
			inputdata.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			inputdata.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			inputdata.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			
			String[] array = rs.getString("CHILD_TBL_RMARK").split("/");
			inputdata.setURL(array[0]);
			inputdata.setPARENT(array[1]);
			inputdata.setCHILD_TBL_USE_STATUS("CHILD_TBL_USE_STATUS");
			
			//System.out.println(inputdata.toString());
			
			list.add(inputdata);
		}
		
		//System.out.println(flag);
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return flag;
	}
	
	@RequestMapping(value = "/pwchange2", method = {RequestMethod.GET})
	public String pwchange2(HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException {
		String data = request.getParameter("usetData");
		JSONParser parser = new JSONParser();
		JSONObject obj  = (JSONObject)parser.parse(data);
		
		//System.out.println(obj.toJSONString());
		
		if(obj.get("inputPass").equals(""))
			return "inputPassNone";
		if(obj.get("inputPass2").equals(""))
			return "inputPassNone2";
		
		if(!obj.get("inputPass").equals(obj.get("inputPass2")))
			return "inputPassNot";
		
		HttpSession session = request.getSession();
		String id = (String)session.getAttribute("id");
		
		Connection conn = dataSource.getConnection();
		String sql = "update USER_INFO_TBL set ";
		sql += "USER_PASSWORD=hex(aes_encrypt('"+obj.get("inputPass")+"','a'))";
		sql += " where USER_CODE='"+id+"'";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		//System.out.println(sql);
		
		HomeController.LogInsert("", "6. Pw Change", sql, request);
		
		return "Success";
	}
	
	@RequestMapping(value = "/userType", method = {RequestMethod.GET,RequestMethod.POST})
	public List<DTL_TBL> userType(HttpServletRequest request,Model model) throws ParseException, SQLException {
		
		String sql = "select * from DTL_TBL where NEW_TBL_CODE='1'";
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		List<DTL_TBL> deptList = new ArrayList<DTL_TBL>();
		
		while (rs.next()) 
		{
			DTL_TBL data =new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println(data.toString());
			deptList.add(data);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return deptList;
	}
	
	// 권한 관리 페이지에서 타입명을 클릭할때 뿌려줄 데이터
	@RequestMapping(value = "/permissionView", method = {RequestMethod.GET,RequestMethod.POST})
	public List<RIGHTS_MGMT_TBL> permissionView(HttpServletRequest request,Model model) throws ParseException, SQLException {
		String RIGHTS_USER_TYPE = request.getParameter("RIGHTS_USER_TYPE");
		
		String sql = "select\r\n"
				+ "			t1.*\r\n"
				+ "        ,	t2.*\r\n"
				+ "from\r\n"
				+ "		(\r\n"
				+ "			select\r\n"
				+ "					*\r\n"
				+ "			from\r\n"
				+ "					RIGHTS_MGMT_TBL\r\n"
				+ "			where\r\n"
				+ "					RIGHTS_USER_TYPE = '"+RIGHTS_USER_TYPE+"'"
				+ "        ) t1\r\n"
				+ "left outer join \r\n"
				+ "		(\r\n"
				+ "			select \r\n"
				+ "					* \r\n"
				+ "			from DTL_TBL where NEW_TBL_CODE='13'\r\n"
				+ "        ) t2\r\n"
				+ "on t1.RIGHTS_PROGRAM_CODE = t2.CHILD_TBL_NUM"
				+ " order by t1.RIGHTS_PROGRAM_CODE+0";
		
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		List<RIGHTS_MGMT_TBL> deptList = new ArrayList<RIGHTS_MGMT_TBL>();
		
		while (rs.next()) 
		{
			RIGHTS_MGMT_TBL data = new RIGHTS_MGMT_TBL();
			data.setRIGHTS_USER_TYPE(rs.getString("RIGHTS_USER_TYPE"));
			data.setRIGHTS_PROGRAM_CODE(rs.getString("RIGHTS_PROGRAM_CODE"));
			data.setRIGHTS_MGMT_USE_STATUS(rs.getString("RIGHTS_MGMT_USE_STATUS"));
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_RMARK(rs.getString("CHILD_TBL_RMARK"));
			deptList.add(data);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return deptList;
	}
}
