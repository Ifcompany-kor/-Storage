package com.Standard.Controller;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.Common.Controller.HomeController;
import com.Standard.Dto.MOLD_INFO_TBL;

@RestController("MoldRestController")
@RequestMapping("moldRest")
public class MoldRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/view.do",method = RequestMethod.GET)
	public List<MOLD_INFO_TBL> view() throws SQLException
	{
		List<MOLD_INFO_TBL> list = new ArrayList<MOLD_INFO_TBL>();
		
		String sql = "select \r\n"
				+ "			t1.BUSINESS_PLACE,t1.MOLD_INFO_NO,t1.MOLD_INFO_NAME,t1.MOLD_INFO_RANK,t1.MOLD_INFO_STND,t1.MOLD_ITEM_CODE,t1.MANUFACTURER,t1.BUSINESS_PERSON\r\n"
				+ "		,	t1.MOLD_RECEIVED_D,t1.MOLD_CUBIT,t5.USER_NAME USER_MODIFIER,t1.USER_MODIFY_D,t1.MOLD_USE_STATUS\r\n"
				+ "        ,	t4.PRODUCT_ITEM_NAME    \r\n"
				+ "		,	t2.CHILD_TBL_TYPE BUSINESS_PLACE_NAME\r\n"
				+ "        ,	t3.CHILD_TBL_TYPE MOLD_INFO_RANK_NAME\r\n"
				+ "from MOLD_INFO_TBL t1\r\n"
				+ "INNER JOIN USER_INFO_TBL t5 ON t1.USER_MODIFIER = t5.USER_CODE \r\n"
				+ "left outer join \r\n"
				+ "(\r\n"
				+ "	select\r\n"
				+ "			*\r\n"
				+ "	from\r\n"
				+ "			DTL_TBL\r\n"
				+ "	where 	NEW_TBL_CODE = '2'\r\n"
				+ ") t2\r\n"
				+ "on t1.BUSINESS_PLACE = t2.CHILD_TBL_NUM\r\n"
				+ "left outer join \r\n"
				+ "(\r\n"
				+ "	select\r\n"
				+ "			*\r\n"
				+ "	from\r\n"
				+ "			DTL_TBL\r\n"
				+ "	where 	NEW_TBL_CODE = '11'\r\n"
				+ ") t3\r\n"
				+ "on t1.MOLD_INFO_RANK = t3.CHILD_TBL_NUM\r\n"
				+ "left outer join PRODUCT_INFO_TBL t4\r\n"
				+ "on t1.MOLD_ITEM_CODE = t4.PRODUCT_ITEM_CODE";
		
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		int i = 0;
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while (rs.next()) {
			//for(int j=1 ; j<=columnCnt ; j++){
			                		// 컬럼명                                   //데이터
				//System.out.println(rsmd.getColumnName(j)+","+rs.getString(rsmd.getColumnName(j)));  
			//}
			MOLD_INFO_TBL data = new MOLD_INFO_TBL();
			i++;
			data.setId(i);
			//System.out.println(rs.get);//
			data.setBUSINESS_PLACE(rs.getString("BUSINESS_PLACE"));
			data.setMOLD_CUBIT(rs.getString("MOLD_CUBIT"));
			data.setMOLD_INFO_NO(rs.getString("MOLD_INFO_NO"));
			data.setMOLD_INFO_NAME(rs.getString("MOLD_INFO_NAME"));
			data.setMOLD_INFO_RANK(rs.getString("MOLD_INFO_RANK")+":"+rs.getString("MOLD_INFO_RANK_NAME"));
			data.setMOLD_INFO_STND(rs.getString("MOLD_INFO_STND"));
			data.setMOLD_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
			data.setMOLD_ITEM_CODE(rs.getString("MOLD_ITEM_CODE"));
			data.setMANUFACTURER(rs.getString("MANUFACTURER"));
			data.setBUSINESS_PERSON(rs.getString("BUSINESS_PERSON"));
			data.setMOLD_RECEIVED_D(rs.getString("MOLD_RECEIVED_D"));
			data.setUSER_MODIFIER(rs.getString("USER_MODIFIER"));
			data.setUSER_MODIFY_D(rs.getString("USER_MODIFY_D"));
			data.setMOLD_USE_STATUS(rs.getString("MOLD_USE_STATUS"));
			data.setMOLD_INFO_RANK_CODE(rs.getString("MOLD_INFO_RANK_NAME"));
			data.setBUSINESS_PLACE_CODE(rs.getString("BUSINESS_PLACE")+":"+rs.getString("BUSINESS_PLACE_NAME"));
			list.add(data);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
	}
	
	@RequestMapping(value = "/insert",method = {RequestMethod.POST})
	public String insert(@RequestParam(value="data",required=false) String data,
			HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException
	{
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = null;
		JSONParser parser = new JSONParser();
		JSONObject obj  = (JSONObject)parser.parse(data);
	
		//System.out.println(obj.toJSONString());
		
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		String datestr = sdf.format(date.getTime());
		
		String sql = "select * from MOLD_INFO_TBL where MOLD_INFO_NO='"+obj.get("MOLD_INFO_NO")+"'";
	
		 //System.out.println(sql); 
		 pstmt = conn.prepareStatement(sql); 
		 ResultSet rs = pstmt.executeQuery(); 
		 
		 while (rs.next()) { 
			 return "Overlap"; 
		}
		
		//{"MOLD_INFO_NO":"567","MOLD_ITEM_CODE":"code1","BUSINESS_PLACE_CODE":0,"MOLD_INFO_NAME":"","USER_MODIFIER":"관리자","MOLD_INFO_STND":"","MOLD_USE_STATUS":"true","MOLD_RECEIVED_D":"","MANUFACTURER":"","MOLD_INFO_RANK":0,"BUSINESS_PERSON":""}
		
		 HttpSession httpSession = request.getSession();
		String modifier = (String) httpSession.getAttribute("id");
		 
		sql = "insert into MOLD_INFO_TBL(BUSINESS_PLACE,MOLD_INFO_NO,MOLD_ITEM_CODE,MOLD_INFO_NAME\r\n"
				+ ",MOLD_INFO_STND,MOLD_USE_STATUS,MOLD_RECEIVED_D,MANUFACTURER,MOLD_INFO_RANK\r\n"
				+ ",BUSINESS_PERSON,USER_MODIFIER,USER_MODIFY_D,MOLD_CUBIT) Values (";
		sql += "'"+obj.get("BUSINESS_PLACE_CODE")+"',";
		sql += "'"+obj.get("MOLD_INFO_NO")+"',";
		sql += "'"+obj.get("MOLD_ITEM_CODE")+"',";
		sql += "'"+obj.get("MOLD_INFO_NAME")+"',";
		sql += "'"+obj.get("MOLD_INFO_STND")+"',";
		sql += "'"+obj.get("MOLD_USE_STATUS")+"',";
		if(obj.get("MOLD_RECEIVED_D")== "")
			sql += "'"+obj.get("MOLD_RECEIVED_D")+"',";
		else
			sql += "'"+datestr+"',";
		sql += "'"+obj.get("MANUFACTURER")+"',";
		sql += "'"+obj.get("MOLD_INFO_RANK")+"',";
		sql += "'"+obj.get("BUSINESS_PERSON")+"',";
		sql += "'"+modifier+"',";
		sql += "'"+datestr+"',";
		if(obj.get("MOLD_CUBIT").equals(""))
			sql += "'"+1+"'";
		else
			sql += "'"+obj.get("MOLD_CUBIT")+"'";
		sql += ")";
		
		//System.out.println(sql);
		HomeController.LogInsert("", "1. Insert", sql, request);
		
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		conn.close();
		
		
		return "Success";
	}
	
	
	// 삭제
		@RequestMapping(value = "/delete2.do", method = RequestMethod.POST)
		public String delete2(HttpServletRequest request, Model model) throws SQLException, ParseException, UnknownHostException, ClassNotFoundException {
			String MOLD_INFO_NO = request.getParameter("MOLD_INFO_NO");

			String sql = "delete from MOLD_INFO_TBL where MOLD_INFO_NO = '"+ MOLD_INFO_NO +"'";
			
			//System.out.println(sql);
			HomeController.LogInsert("", "3. Delete", sql, request);
			
			Connection conn = dataSource.getConnection();
			PreparedStatement pstmt = null;
			try {
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
				System.out.println("에러에러");
				return "error";
			}finally {
				pstmt.close();
				conn.close();
			}
			
			return MOLD_INFO_NO;
		}
	
	@RequestMapping(value = "/popup",method = RequestMethod.GET)
	public List<MOLD_INFO_TBL> popup(@RequestParam(value="MOLD_INFO_NO",required=false) String MOLD_INFO_NO,
			@RequestParam(value="MOLD_INFO_NAME",required=false) String MOLD_INFO_NAME) throws SQLException
	{
		System.out.println("OK");
		
		List<MOLD_INFO_TBL> list = new ArrayList<MOLD_INFO_TBL>();
		
		String sql = "select * from MOLD_INFO_TBL ";
		
		String where = "where MOLD_INFO_NO like '%"+MOLD_INFO_NO+"%' and ";
		where += "MOLD_INFO_NAME like '%"+MOLD_INFO_NAME+"%'";
		
		if(MOLD_INFO_NAME == null || MOLD_INFO_NAME == "")
			where = "where MOLD_INFO_NO like '%"+MOLD_INFO_NO+"%'";
		
		if(MOLD_INFO_NO == null || MOLD_INFO_NO == "")
			where = "where MOLD_INFO_NAME like '%"+MOLD_INFO_NAME+"%'";
		
		sql += where;
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		int i = 0;
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while (rs.next()) {
			//for(int j=1 ; j<=columnCnt ; j++){
			                		// 컬럼명                                   //데이터
				//System.out.println(rsmd.getColumnName(j)+","+rs.getString(rsmd.getColumnName(j)));  
			//}
			MOLD_INFO_TBL data = new MOLD_INFO_TBL();
			i++;
			data.setId(i);
			//System.out.println(rs.get);//
			data.setMOLD_INFO_NO(rs.getString("MOLD_INFO_NO"));
			data.setMOLD_INFO_NAME(rs.getString("MOLD_INFO_NAME"));
			list.add(data);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return list;
	}
	
}
