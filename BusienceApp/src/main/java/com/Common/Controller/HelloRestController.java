package com.Common.Controller;

import java.sql.Connection;
import java.sql.DriverManager;
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

import com.Production.Dto.PRODUCTION_INFO_;
import com.Standard.Dto.DEFECT_INFO_TBL;
import com.Standard.Dto.MOLD_INFO_TBL;
import com.Standard.Dto.USER_INFO_TBL;

@RestController("HelloRestController")
public class HelloRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/user_select", method = {RequestMethod.GET,RequestMethod.POST})
	public List<USER_INFO_TBL> user_select(HttpServletRequest request) throws ClassNotFoundException, SQLException
	{
		String temp1 = request.getParameter("temp1");
		
		String sql = "SELECT * FROM USER_INFO_TBL WHERE USER_CODE = '"+temp1+"'";
		
		//System.out.println(sql);
		
		Connection con = dataSource.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery(sql);
		
		List<USER_INFO_TBL> list = new ArrayList<USER_INFO_TBL>();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while(rs.next())
		{
			/*
			for(int i=1 ; i<=columnCnt ; i++){
			           	// 컬럼명                                   //데이터
			   System.out.println(rsmd.getColumnName(i)+","+rs.getString(rsmd.getColumnName(i)));  
		   }
			*/
			USER_INFO_TBL data = new USER_INFO_TBL();
			data.setUSER_CODE(rs.getString("USER_CODE"));
			data.setUSER_NAME(rs.getString("USER_NAME"));
			list.add(data);
		}
		
		rs.close();
		pstmt.close();
		con.close();
		
		return list;
	}
	
	@RequestMapping(value = "/mold_select", method = {RequestMethod.GET,RequestMethod.POST})
	public List<MOLD_INFO_TBL> mold_select(HttpServletRequest request) throws ClassNotFoundException, SQLException
	{
		String temp1 = request.getParameter("temp1");
		
		String sql = "SELECT * FROM MOLD_INFO_TBL WHERE MOLD_INFO_NAME LIKE '%"+temp1+"%'";
		
		//System.out.println(sql);
		
		Connection con = dataSource.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery(sql);
		
		List<MOLD_INFO_TBL> list = new ArrayList<MOLD_INFO_TBL>();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while(rs.next())
		{
			/*
			for(int i=1 ; i<=columnCnt ; i++){
			           	// 컬럼명                                   //데이터
			   System.out.println(rsmd.getColumnName(i)+","+rs.getString(rsmd.getColumnName(i)));  
		    }
			*/
			
			MOLD_INFO_TBL data = new MOLD_INFO_TBL();
			data.setMOLD_CUBIT(rs.getString("MOLD_CUBIT"));
			data.setMOLD_INFO_NO(rs.getString("MOLD_INFO_NO"));
			data.setMOLD_INFO_NAME(rs.getString("MOLD_INFO_NAME"));
			data.setMOLD_ITEM_CODE(rs.getString("MOLD_ITEM_CODE"));
			list.add(data);
		}
		
		rs.close();
		pstmt.close();
		con.close();
		
		return list;
	}
	
	@RequestMapping(value = "/dept_select", method = {RequestMethod.GET,RequestMethod.POST})
	public List<DEFECT_INFO_TBL> dept_select(HttpServletRequest request) throws SQLException
	{
		String sql = "SELECT * FROM DEFECT_INFO_TBL";
		
		Connection con = dataSource.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery(sql);
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		List<DEFECT_INFO_TBL> list = new ArrayList<DEFECT_INFO_TBL>();
		
		while(rs.next())
		{
			/*
			for(int i=1 ; i<=columnCnt ; i++){
			           			  // 컬럼명                                //데이터
			   System.out.println(rsmd.getColumnName(i)+","+rs.getString(rsmd.getColumnName(i)));  
		    }
			*/
			DEFECT_INFO_TBL data = new DEFECT_INFO_TBL();
			data.setDEFECT_CODE(rs.getString("DEFECT_CODE"));
			data.setDEFECT_NAME(rs.getString("DEFECT_NAME"));
			list.add(data);
		}
		
		rs.close();
		pstmt.close();
		con.close();
		
		return list;
	}
	
	@RequestMapping(value = "/bsapp2", method = {RequestMethod.GET,RequestMethod.POST})
	public void bsapp(HttpServletRequest request) throws ClassNotFoundException, SQLException
	{
		String PRODUCTION_SERIAL_NUM = request.getParameter("serial");						// 시리얼
		String PRODUCTION_INFO_NUM = request.getParameter("sunbun");						// 순번
		String PRODUCTION_EQUIPMENT_CODE = request.getParameter("equip_id");				// 설비코드
		String PRODUCTION_MOLD_INFO_CODE = request.getParameter("mold_id");					// 금형 no
		String PRODUCTION_PRODUCT_CODE = request.getParameter("product_id");				// 제품코드
		String PRODUCTION_DEFECT_CODE = request.getParameter("defect_id");					// 불량 정보
		String PRODUCTION_VOLUME = request.getParameter("count");							// 생산수량 (양품수량)
		String PRODUCTION_BAD = request.getParameter("bad");								// 불량수량
		String PRODUCTION_MODIFY_D = request.getParameter("user");							// 수정자
		String PRODUCTION_USER_CODE = request.getParameter("user_id");						// 사용자코드
		String PRODUCTION_CC = request.getParameter("status");								// 마감상태 : s (계속) 또는 e(끝남)
		String sort = request.getParameter("sort");											// 현재 데이터 종류 : p 또는 b
		
		
		String sql = "";
		
		if(PRODUCTION_CC.equals("S"))
		{
			//PRODUCTION_DEFECT_CODE = "";
			
			sql = "INSERT INTO `PRODUCTION_MGMT_TBL1`\r\n"
					+ "(`PRODUCTION_SERIAL_NUM`,\r\n"
					+ "`PRODUCTION_INFO_NUM`,\r\n"
					+ "`PRODUCTION_EQUIPMENT_CODE`,\r\n"
					+ "`PRODUCTION_MOLD_INFO_CODE`,\r\n"
					+ "`PRODUCTION_PRODUCT_CODE`,\r\n"
					+ "`PRODUCTION_DEFECT_CODE`,\r\n"
					+ "`PRODUCTION_VOLUME`,\r\n"
					+ "`PRODUCTION_BAD`,\r\n"
					+ "`PRODUCTION_CC`,\r\n"
					+ "`PRODUCTION_USER_CODE`)\r\n"
					+ "VALUES";
			sql += "("
					+ "'" + PRODUCTION_SERIAL_NUM + "',"
					+ "'" + PRODUCTION_INFO_NUM + "',"
					+ "'" + PRODUCTION_EQUIPMENT_CODE + "',"
					+ "'" + PRODUCTION_MOLD_INFO_CODE + "',"
					+ "'" + PRODUCTION_PRODUCT_CODE + "',"
					+ "'" + PRODUCTION_DEFECT_CODE + "',"
					+ "'" + PRODUCTION_VOLUME + "',"
					+ "'" + PRODUCTION_BAD + "',"
					+ "'" + PRODUCTION_CC + "',"
					+ "'" + PRODUCTION_USER_CODE + "'"
					+ ")";
			
			if(sort.equals("P"))
			{
				sql = "INSERT INTO `PRODUCTION_MGMT_TBL1`\r\n"
						+ "(`PRODUCTION_SERIAL_NUM`,\r\n"
						+ "`PRODUCTION_INFO_NUM`,\r\n"
						+ "`PRODUCTION_EQUIPMENT_CODE`,\r\n"
						+ "`PRODUCTION_MOLD_INFO_CODE`,\r\n"
						+ "`PRODUCTION_PRODUCT_CODE`,\r\n"
						+ "`PRODUCTION_DEFECT_CODE`,\r\n"
						+ "`PRODUCTION_VOLUME`,\r\n"
						+ "`PRODUCTION_BAD`,\r\n"
						+ "`PRODUCTION_CC`,\r\n"
						+ "`PRODUCTION_USER_CODE`)\r\n"
						+ "VALUES";
				sql += "("
						+ "'" + PRODUCTION_SERIAL_NUM + "',"
						+ "'" + PRODUCTION_INFO_NUM + "',"
						+ "'" + PRODUCTION_EQUIPMENT_CODE + "',"
						+ "'" + PRODUCTION_MOLD_INFO_CODE + "',"
						+ "'" + PRODUCTION_PRODUCT_CODE + "',"
						+ "'" + "',"
						+ "'" + PRODUCTION_VOLUME + "',"
						+ "'" + 0 + "',"
						+ "'" + PRODUCTION_CC + "',"
						+ "'" + PRODUCTION_USER_CODE + "'"
						+ ")";
			}
			else
			{
				sql = "INSERT INTO `PRODUCTION_MGMT_TBL1`\r\n"
						+ "(`PRODUCTION_SERIAL_NUM`,\r\n"
						+ "`PRODUCTION_INFO_NUM`,\r\n"
						+ "`PRODUCTION_EQUIPMENT_CODE`,\r\n"
						+ "`PRODUCTION_MOLD_INFO_CODE`,\r\n"
						+ "`PRODUCTION_PRODUCT_CODE`,\r\n"
						+ "`PRODUCTION_DEFECT_CODE`,\r\n"
						+ "`PRODUCTION_VOLUME`,\r\n"
						+ "`PRODUCTION_BAD`,\r\n"
						+ "`PRODUCTION_CC`,\r\n"
						+ "`PRODUCTION_USER_CODE`)\r\n"
						+ "VALUES";
				sql += "("
						+ "'" + PRODUCTION_SERIAL_NUM + "',"
						+ "'" + PRODUCTION_INFO_NUM + "',"
						+ "'" + PRODUCTION_EQUIPMENT_CODE + "',"
						+ "'" + PRODUCTION_MOLD_INFO_CODE + "',"
						+ "'" + PRODUCTION_PRODUCT_CODE + "',"
						+ "'" + PRODUCTION_DEFECT_CODE + "',"
						+ "'" + 0 + "',"
						+ "'" + PRODUCTION_BAD + "',"
						+ "'" + PRODUCTION_CC + "',"
						+ "'" + PRODUCTION_USER_CODE + "'"
						+ ")";
			}
		}
		else
		{
			sql = "update PRODUCTION_MGMT_TBL1 set ";
			sql += "PRODUCTION_CC='"+PRODUCTION_CC+"'";
			sql += " where PRODUCTION_SERIAL_NUM='"+PRODUCTION_SERIAL_NUM+"' and PRODUCTION_INFO_NUM="+PRODUCTION_INFO_NUM;
		}
		
		//System.out.println(sql);
		
		/*
		if(status.equals("S"))
		{
			
			sql = "INSERT INTO `PRODUCTION_MGMT_TBL`\r\n"
					+ "(`PRODUCTION_SERIAL_NUM`,\r\n"
					+ "`PRODUCTION_INFO_NUM`,\r\n"
					+ "`PRODUCTION_EQUIPMENT_CODE`,\r\n"
					+ "`PRODUCTION_MOLD_INFO_CODE`,\r\n"
					+ "`PRODUCTION_PRODUCT_CODE`,\r\n"
					+ "`PRODUCTION_DEFECT_CODE`,\r\n"
					+ "`PRODUCTION_VOLUME`,\r\n"
					+ "`PRODUCTION_BAD`,\r\n"
					+ "`PRODUCTION_MODIFY_D`,\r\n"
					+ "`PRODUCTION_CC`,\r\n"
					+ "`PRODUCTION_USER_CODE`)\r\n"
					+ "VALUES";
			sql += "("
					+ "'" + serial + "',"
					+ "'" + sunbun + "',"
					+ "'" + equip_id + "',"
					+ "'" + mold_id + "',"
					+ "'" + "test" + "',"
					+ "'" + defect_id + "',"
					+ "'" + count + "',"
					+ "'" + bad + "',"
					+ "'" + YmdHis + "',"
					+ "'" + status + "',"
					+ "'" + user_id + "'"
					+ ")";
			
			
			if(sort.equals("P"))
			{
				sql = "INSERT INTO `PRODUCTION_MGMT_TBL`\r\n"
						+ "(`PRODUCTION_SERIAL_NUM`,\r\n"
						+ "`PRODUCTION_INFO_NUM`,\r\n"
						+ "`PRODUCTION_EQUIPMENT_CODE`,\r\n"
						+ "`PRODUCTION_MOLD_INFO_CODE`,\r\n"
						+ "`PRODUCTION_PRODUCT_CODE`,\r\n"
						+ "`PRODUCTION_DEFECT_CODE`,\r\n"
						+ "`PRODUCTION_VOLUME`,\r\n"
						+ "`PRODUCTION_BAD`,\r\n"
						+ "`PRODUCTION_CC`,\r\n"
						+ "`PRODUCTION_USER_CODE`)\r\n"
						+ "VALUES";
				sql += "("
						+ "'" + serial + "',"
						+ "'" + sunbun + "',"
						+ "'" + equip_id + "',"
						+ "'" + mold_id + "',"
						+ "'" + "test" + "',"
						+ "'" + defect_id + "',"
						+ "'" + count + "',"
						+ "'" + 0 + "',"
						+ "'" + status + "',"
						+ "'" + user_id + "'"
						+ ")";
			}
			else
			{
				sql = "INSERT INTO `PRODUCTION_MGMT_TBL`\r\n"
						+ "(`PRODUCTION_SERIAL_NUM`,\r\n"
						+ "`PRODUCTION_INFO_NUM`,\r\n"
						+ "`PRODUCTION_EQUIPMENT_CODE`,\r\n"
						+ "`PRODUCTION_MOLD_INFO_CODE`,\r\n"
						+ "`PRODUCTION_PRODUCT_CODE`,\r\n"
						+ "`PRODUCTION_DEFECT_CODE`,\r\n"
						+ "`PRODUCTION_VOLUME`,\r\n"
						+ "`PRODUCTION_BAD`,\r\n"
						+ "`PRODUCTION_CC`,\r\n"
						+ "`PRODUCTION_USER_CODE`)\r\n"
						+ "VALUES";
				sql += "("
						+ "'" + serial + "',"
						+ "'" + sunbun + "',"
						+ "'" + equip_id + "',"
						+ "'" + mold_id + "',"
						+ "'" + "test" + "',"
						+ "'" + defect_id + "',"
						+ "'" + 0 + "',"
						+ "'" + bad + "',"
						+ "'" + status + "',"
						+ "'" + user_id + "'"
						+ ")";
			}
		}
		else
		{
			sql = "update PRODUCTION_MGMT_TBL set PRODUCTION_CC='"+status+"' where PRODUCTION_SERIAL_NUM='"+serial+"' and PRODUCTION_INFO_NUM='"+sunbun+"'";
		}
		
		System.out.println(sql);
		
		Connection con = dataSource.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.execute();
		
		pstmt.close();
		con.close();
		*/
		
		Connection con = dataSource.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.execute();
		
		pstmt.close();
		con.close();
	}
	
}
