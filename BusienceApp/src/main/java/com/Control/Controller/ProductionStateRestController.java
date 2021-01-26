package com.Control.Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Production.Dto.PRODUCTION_INFO_TBL_1;

@RestController("ProductionStateRestController")
@RequestMapping("productionrest")
public class ProductionStateRestController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/unit1",method = RequestMethod.GET)
	public List<PRODUCTION_INFO_TBL_1> unit1() throws SQLException {
		String pattern = "yyyy-MM-dd";
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

		String date = simpleDateFormat.format(new Date());
		
		String sql = "select \r\n"
				+ "			*\r\n"
				+ "from		PRODUCTION_MGMT_TBL\r\n"
				+ "where		date(PRODUCTION_MODIFY_D) = ?\r\n"
				+ "and 		PRODUCTION_EQUIPMENT_CODE = 'M001'\r\n"
				+ "order by    PRODUCTION_MODIFY_D desc\r\n"
				+ "limit 1";
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, date);
		ResultSet rs = pstmt.executeQuery();
		
		//ResultSetMetaData rsmd = rs.getMetaData();
		//int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		String PRODUCTION_CC = "";
		String PRODUCTION_SERIAL_NUM = "";
		
		//System.out.println(rs.next());
		while (rs.next()) {
			/*
			for(int i=1 ; i<=columnCnt ; i++){
			                		// 컬럼명                               //데이터
				System.out.println(rsmd.getColumnName(i)+","+rs.getString(rsmd.getColumnName(i)));  
			}
			*/
			PRODUCTION_CC = rs.getString("PRODUCTION_CC");
			
			if(PRODUCTION_CC.equals("S"))
				PRODUCTION_SERIAL_NUM = rs.getString("PRODUCTION_SERIAL_NUM");
		}
		
		//if(!PRODUCTION_SERIAL_NUM.equals(""))
			//System.out.println(PRODUCTION_SERIAL_NUM);
		//System.out.println(date);
		
		/*
		sql = "select \r\n"
				+ "        	D.PRODUCT_ITEM_NAME									-- 모델명\r\n"
				+ "        , 	B.q_ty1 PRODUCTION_VOLUME 							-- 생산수량\r\n"
				+ "        , 	ifnull(A.q_ty2,0) PRODUCTION_DEFECT_CODE 						-- 블량수량\r\n"
				+ "        ,	B.q_ty1 - ifnull(A.q_ty2,0) QUANTITY_GOODS					-- 양품수량\r\n"
				+ "        ,	C.PRODUCTION_SERIAL_NUM								-- 시리얼 번호\r\n"
				+ "		   ,   MID(C.PRODUCTION_SERIAL_NUM,7,4) AS TIME				-- 시간\r\n"	
				+ "from PRODUCTION_INFO_TBL AS C\r\n"
				+ "left outer join (select PRODUCTION_SERIAL_NUM,sum(PRODUCTION_VOLUME) AS q_ty2\r\n"
				+ "      from PRODUCTION_INFO_TBL\r\n"
				+ "        where date(PRODUCTION_MODIFY_D) = ? and PRODUCTION_DEFECT_CODE <> \"\" and PRODUCTION_EQUIPMENT_CODE = 'E001'\r\n"
				+ "      group by PRODUCTION_SERIAL_NUM)\r\n"
				+ "AS A on A.PRODUCTION_SERIAL_NUM = C.PRODUCTION_SERIAL_NUM\r\n"
				+ "left outer join (select PRODUCTION_SERIAL_NUM,sum(PRODUCTION_VOLUME) AS q_ty1\r\n"
				+ "      from PRODUCTION_INFO_TBL\r\n"
				+ "        where date(PRODUCTION_MODIFY_D) = ? and PRODUCTION_DEFECT_CODE = \"\" and PRODUCTION_EQUIPMENT_CODE = 'E001'\r\n"
				+ "      group by PRODUCTION_SERIAL_NUM)\r\n"
				+ "AS B on B.PRODUCTION_SERIAL_NUM = C.PRODUCTION_SERIAL_NUM\r\n"
				+ "inner join PRODUCT_INFO_TBL D on C.PRODUCTION_PRODUCT_CODE = D.PRODUCT_ITEM_CODE\r\n"
				+ "where date(C.PRODUCTION_MODIFY_D) = ? and C.PRODUCTION_EQUIPMENT_CODE = 'E001'\r\n"
				+ "group by C.PRODUCTION_SERIAL_NUM, C.PRODUCTION_EQUIPMENT_CODE, C.PRODUCTION_MOLD_INFO_CODE, C.PRODUCTION_PRODUCT_CODE";
		*/
		
		sql = "select\r\n"
				+ "				MID(t1.PRODUCTION_SERIAL_NUM,7,4) AS 			TIME						-- 시간\r\n"
				+ "			,	t2.PRODUCT_ITEM_NAME							PRODUCT_ITEM_NAME			-- 모델명\r\n"
				+ "			,	sum(PRODUCTION_VOLUME)							PRODUCTION_VOLUME			-- 생산수량\r\n"
				+ "            ,	sum(PRODUCTION_BAD)								PRODUCTION_DEFECT_CODE		-- 불량수량\r\n"
				+ "            ,	t1.PRODUCTION_SERIAL_NUM						PRODUCTION_SERIAL_NUM		-- 시리얼 번호\r\n"
				+ "            ,	sum(PRODUCTION_VOLUME) - sum(PRODUCTION_BAD)	QUANTITY_GOODS				-- 양품수량\r\n"
				+ "from	PRODUCTION_MGMT_TBL	as t1\r\n"
				+ "inner join PRODUCT_INFO_TBL t2 on t1.PRODUCTION_PRODUCT_CODE = t2.PRODUCT_ITEM_CODE\r\n"
				+ "where date(t1.PRODUCTION_MODIFY_D) = ? and t1.PRODUCTION_EQUIPMENT_CODE = 'M001'\r\n"
				+ "group by t1.PRODUCTION_SERIAL_NUM, t1.PRODUCTION_EQUIPMENT_CODE, t1.PRODUCTION_MOLD_INFO_CODE, t1.PRODUCTION_PRODUCT_CODE";
		
		//System.out.println(sql);
		
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, date);
		//pstmt.setString(2, "2020-12-05");
		//pstmt.setString(3, "2020-12-05");
		
		rs = pstmt.executeQuery();
		
		/*
		rsmd = rs.getMetaData();
		columnCnt = rsmd.getColumnCount(); //컬럼의 수
		*/
		
		List<PRODUCTION_INFO_TBL_1> list = new ArrayList<PRODUCTION_INFO_TBL_1>();
		
		while (rs.next()) {
			if(!PRODUCTION_SERIAL_NUM.equals(rs.getString("PRODUCTION_SERIAL_NUM")))
			{
				PRODUCTION_INFO_TBL_1 data = new PRODUCTION_INFO_TBL_1();
				// 시간
				StringBuffer timeSet = new StringBuffer(rs.getString("TIME"));
				timeSet.insert(2, ":");
							
				data.setTIME(timeSet.toString());
				
				data.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
				data.setPRODUCTION_VOLUME(rs.getString("PRODUCTION_VOLUME"));
				data.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
				data.setQUANTITY_GOODS(rs.getString("QUANTITY_GOODS"));
				data.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
				list.add(data);
			}
		}
		
		return list;
	}
	
	@RequestMapping(value = "/unit2",method = RequestMethod.GET)
	public List<PRODUCTION_INFO_TBL_1> unit2() throws SQLException {
		String pattern = "yyyy-MM-dd";
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

		String date = simpleDateFormat.format(new Date());
		
		String sql = "select \r\n"
				+ "			*\r\n"
				+ "from		PRODUCTION_MGMT_TBL\r\n"
				+ "where		date(PRODUCTION_MODIFY_D) = ?\r\n"
				+ "and 		PRODUCTION_EQUIPMENT_CODE = 'M002'\r\n"
				+ "order by    PRODUCTION_MODIFY_D desc\r\n"
				+ "limit 1";
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, date);
		ResultSet rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		String PRODUCTION_CC = "";
		String PRODUCTION_SERIAL_NUM = "";
		
		while (rs.next()) {
			/*
			for(int i=1 ; i<=columnCnt ; i++){
			                		// 컬럼명                               //데이터
				System.out.println(rsmd.getColumnName(i)+","+rs.getString(rsmd.getColumnName(i)));  
			}
			*/
			PRODUCTION_CC = rs.getString("PRODUCTION_CC");
			
			if(PRODUCTION_CC.equals("S"))
				PRODUCTION_SERIAL_NUM = rs.getString("PRODUCTION_SERIAL_NUM");
		}
		//System.out.println(PRODUCTION_CC);
		//if(!PRODUCTION_SERIAL_NUM.equals(""))
			//System.out.println(PRODUCTION_SERIAL_NUM);
		//System.out.println(date);
		
		/*
		sql = "select \r\n"
				+ "        	D.PRODUCT_ITEM_NAME									-- 모델명\r\n"
				+ "        , 	B.q_ty1 PRODUCTION_VOLUME							-- 생산수량\r\n"
				+ "        , 	ifnull(A.q_ty2,0) PRODUCTION_DEFECT_CODE 						-- 블량수량\r\n"
				+ "        ,	B.q_ty1 - ifnull(A.q_ty2,0) QUANTITY_GOODS					-- 양품수량\r\n"
				+ "        ,	C.PRODUCTION_SERIAL_NUM								-- 시리얼 번호\r\n"
				+ "		   ,   MID(C.PRODUCTION_SERIAL_NUM,7,4) AS TIME				-- 시간\r\n"	
				+ "from PRODUCTION_INFO_TBL AS C\r\n"
				+ "left outer join (select PRODUCTION_SERIAL_NUM,sum(PRODUCTION_VOLUME) AS q_ty2\r\n"
				+ "      from PRODUCTION_INFO_TBL\r\n"
				+ "        where date(PRODUCTION_MODIFY_D) = ? and PRODUCTION_DEFECT_CODE <> \"\" and PRODUCTION_EQUIPMENT_CODE = 'E002'\r\n"
				+ "      group by PRODUCTION_SERIAL_NUM)\r\n"
				+ "AS A on A.PRODUCTION_SERIAL_NUM = C.PRODUCTION_SERIAL_NUM\r\n"
				+ "left outer join (select PRODUCTION_SERIAL_NUM,sum(PRODUCTION_VOLUME) AS q_ty1\r\n"
				+ "      from PRODUCTION_INFO_TBL\r\n"
				+ "        where date(PRODUCTION_MODIFY_D) = ? and PRODUCTION_DEFECT_CODE = \"\" and PRODUCTION_EQUIPMENT_CODE = 'E002'\r\n"
				+ "      group by PRODUCTION_SERIAL_NUM)\r\n"
				+ "AS B on B.PRODUCTION_SERIAL_NUM = C.PRODUCTION_SERIAL_NUM\r\n"
				+ "inner join PRODUCT_INFO_TBL D on C.PRODUCTION_PRODUCT_CODE = D.PRODUCT_ITEM_CODE\r\n"
				+ "where date(C.PRODUCTION_MODIFY_D) = ? and C.PRODUCTION_EQUIPMENT_CODE = 'E002'\r\n"
				+ "group by C.PRODUCTION_SERIAL_NUM, C.PRODUCTION_EQUIPMENT_CODE, C.PRODUCTION_MOLD_INFO_CODE, C.PRODUCTION_PRODUCT_CODE";
		*/
		//System.out.println(sql);
		
		sql = "select\r\n"
				+ "				MID(t1.PRODUCTION_SERIAL_NUM,7,4) AS 			TIME						-- 시간\r\n"
				+ "			,	t2.PRODUCT_ITEM_NAME							PRODUCT_ITEM_NAME			-- 모델명\r\n"
				+ "			,	sum(PRODUCTION_VOLUME)							PRODUCTION_VOLUME			-- 생산수량\r\n"
				+ "            ,	sum(PRODUCTION_BAD)								PRODUCTION_DEFECT_CODE		-- 불량수량\r\n"
				+ "            ,	t1.PRODUCTION_SERIAL_NUM						PRODUCTION_SERIAL_NUM		-- 시리얼 번호\r\n"
				+ "            ,	sum(PRODUCTION_VOLUME) - sum(PRODUCTION_BAD)	QUANTITY_GOODS				-- 양품수량\r\n"
				+ "from	PRODUCTION_MGMT_TBL	as t1\r\n"
				+ "inner join PRODUCT_INFO_TBL t2 on t1.PRODUCTION_PRODUCT_CODE = t2.PRODUCT_ITEM_CODE\r\n"
				+ "where date(t1.PRODUCTION_MODIFY_D) = ? and t1.PRODUCTION_EQUIPMENT_CODE = 'M002'\r\n"
				+ "group by t1.PRODUCTION_SERIAL_NUM, t1.PRODUCTION_EQUIPMENT_CODE, t1.PRODUCTION_MOLD_INFO_CODE, t1.PRODUCTION_PRODUCT_CODE";
		
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, date);
		//pstmt.setString(2, "2020-12-05");
		//pstmt.setString(3, "2020-12-05");
		
		rs = pstmt.executeQuery();
		
		rsmd = rs.getMetaData();
		columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		List<PRODUCTION_INFO_TBL_1> list = new ArrayList<PRODUCTION_INFO_TBL_1>();
		
		while (rs.next()) {
			if(!PRODUCTION_SERIAL_NUM.equals(rs.getString("PRODUCTION_SERIAL_NUM")))
			{
				PRODUCTION_INFO_TBL_1 data = new PRODUCTION_INFO_TBL_1();
				// 시간
				StringBuffer timeSet = new StringBuffer(rs.getString("TIME"));
				timeSet.insert(2, ":");
							
				data.setTIME(timeSet.toString());
				
				data.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
				data.setPRODUCTION_VOLUME(rs.getString("PRODUCTION_VOLUME"));
				data.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
				data.setQUANTITY_GOODS(rs.getString("QUANTITY_GOODS"));
				data.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
				//System.out.println(data);
				list.add(data);
			}
		}
		
		return list;
	}
	
	@RequestMapping(value = "/out1",method = RequestMethod.GET)
	public PRODUCTION_INFO_TBL_1 out1() throws SQLException
	{
		String pattern = "yyyy-MM-dd";
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

		String date = simpleDateFormat.format(new Date());
		
		String sql = "select \r\n"
				+ "			*\r\n"
				+ "from		PRODUCTION_MGMT_TBL\r\n"
				+ "where		date(PRODUCTION_MODIFY_D) = ?\r\n"
				+ "and 		PRODUCTION_EQUIPMENT_CODE = 'M001'\r\n"
				+ "order by    PRODUCTION_MODIFY_D desc\r\n"
				+ "limit 1";
		
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, date);
		
		ResultSet rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		List<PRODUCTION_INFO_TBL_1> list = new ArrayList<PRODUCTION_INFO_TBL_1>();
		
		String PRODUCTION_CC = "";
		String PRODUCTION_SERIAL_NUM = "";
		
		while (rs.next()) {
			/*
			for(int i=1 ; i<=columnCnt ; i++){
			                	   // 컬럼명                   //데이터
				System.out.println(rsmd.getColumnName(i)+","+rs.getString(rsmd.getColumnName(i)));  
			}
			*/
			PRODUCTION_CC = rs.getString("PRODUCTION_CC");
			PRODUCTION_SERIAL_NUM = rs.getString("PRODUCTION_SERIAL_NUM");
		}
		
		PRODUCTION_INFO_TBL_1 data = new PRODUCTION_INFO_TBL_1();
		
		if(PRODUCTION_CC.equals("E"))
			return data;
		
		//System.out.println("----------");
		
		/*
		sql = "select \r\n"
				+ "        	D.PRODUCT_ITEM_NAME									-- 모델명\r\n"
				+ "        , 	B.q_ty1 PRODUCTION_VOLUME							-- 생산수량\r\n"
				+ "        , 	ifnull(A.q_ty2,0) PRODUCTION_DEFECT_CODE 						-- 블량수량\r\n"
				+ "        ,	B.q_ty1 - ifnull(A.q_ty2,0) QUANTITY_GOODS					-- 양품수량\r\n"
				+ "        ,	C.PRODUCTION_MODIFY_D								-- 시작시간\r\n"
				+ "from \r\n"
				+ "(\r\n"
				+ "	select\r\n"
				+ "		*\r\n"
				+ "	from\r\n"
				+ "		PRODUCTION_INFO_TBL\r\n"
				+ "     where PRODUCTION_SERIAL_NUM = ?   \r\n"
				+ ") AS C\r\n"
				+ "left outer join (select PRODUCTION_SERIAL_NUM,sum(PRODUCTION_VOLUME) AS q_ty2\r\n"
				+ "      from PRODUCTION_INFO_TBL\r\n"
				+ "        where date(PRODUCTION_MODIFY_D) = ? and PRODUCTION_DEFECT_CODE <> \"\" and PRODUCTION_EQUIPMENT_CODE = 'E001'\r\n"
				+ "      group by PRODUCTION_SERIAL_NUM)\r\n"
				+ "AS A on A.PRODUCTION_SERIAL_NUM = C.PRODUCTION_SERIAL_NUM\r\n"
				+ "left outer join (select PRODUCTION_SERIAL_NUM,sum(PRODUCTION_VOLUME) AS q_ty1\r\n"
				+ "      from PRODUCTION_INFO_TBL\r\n"
				+ "        where date(PRODUCTION_MODIFY_D) = ? and PRODUCTION_DEFECT_CODE = \"\" and PRODUCTION_EQUIPMENT_CODE = 'E001'\r\n"
				+ "      group by PRODUCTION_SERIAL_NUM)\r\n"
				+ "AS B on B.PRODUCTION_SERIAL_NUM = C.PRODUCTION_SERIAL_NUM\r\n"
				+ "inner join PRODUCT_INFO_TBL D on C.PRODUCTION_PRODUCT_CODE = D.PRODUCT_ITEM_CODE\r\n"
				+ "group by C.PRODUCTION_SERIAL_NUM, C.PRODUCTION_EQUIPMENT_CODE, C.PRODUCTION_MOLD_INFO_CODE, C.PRODUCTION_PRODUCT_CODE";
		*/
		sql = "select\r\n"
				+ "				MID(t1.PRODUCTION_SERIAL_NUM,7,4) AS 			TIME						-- 시간\r\n"
				+ "			,	t2.PRODUCT_ITEM_NAME							PRODUCT_ITEM_NAME			-- 모델명\r\n"
				+ "			,	sum(PRODUCTION_VOLUME)							PRODUCTION_VOLUME			-- 생산수량\r\n"
				+ "            ,	sum(PRODUCTION_BAD)								PRODUCTION_DEFECT_CODE		-- 불량수량\r\n"
				+ "            ,	t1.PRODUCTION_SERIAL_NUM						PRODUCTION_SERIAL_NUM		-- 시리얼 번호\r\n"
				+ "            ,	sum(PRODUCTION_VOLUME) - sum(PRODUCTION_BAD)	QUANTITY_GOODS				-- 양품수량\r\n"
				+ "            ,	t1.PRODUCTION_MODIFY_D							PRODUCTION_MODIFY_D			-- 시간\r\n"
				+ "from	PRODUCTION_MGMT_TBL	as t1\r\n"
				+ "inner join PRODUCT_INFO_TBL t2 on t1.PRODUCTION_PRODUCT_CODE = t2.PRODUCT_ITEM_CODE\r\n"
				+ "where date(t1.PRODUCTION_MODIFY_D) = ? and t1.PRODUCTION_EQUIPMENT_CODE = 'M001'\r\n"
				+ "and PRODUCTION_SERIAL_NUM = ?   \r\n"
				+ "group by t1.PRODUCTION_SERIAL_NUM, t1.PRODUCTION_EQUIPMENT_CODE, t1.PRODUCTION_MOLD_INFO_CODE, t1.PRODUCTION_PRODUCT_CODE";
		
		pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, date);
		pstmt.setString(2, PRODUCTION_SERIAL_NUM);
		
		rs = pstmt.executeQuery();
		
		rsmd = rs.getMetaData();
		columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while (rs.next()) {
			data.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
			data.setPRODUCTION_VOLUME(rs.getString("PRODUCTION_VOLUME"));
			data.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
			data.setQUANTITY_GOODS(rs.getString("QUANTITY_GOODS"));
			data.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D"));
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return data;
	}
	
	@RequestMapping(value = "/out2",method = RequestMethod.GET)
	public PRODUCTION_INFO_TBL_1 out2() throws SQLException
	{
		String pattern = "yyyy-MM-dd";
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

		String date = simpleDateFormat.format(new Date());
		
		String sql = "select \r\n"
				+ "			*\r\n"
				+ "from		PRODUCTION_MGMT_TBL\r\n"
				+ "where		date(PRODUCTION_MODIFY_D) = ?\r\n"
				+ "and 		PRODUCTION_EQUIPMENT_CODE = 'M002'\r\n"
				+ "order by    PRODUCTION_MODIFY_D desc\r\n"
				+ "limit 1";
		
		//System.out.println(sql);
		
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, date);
		
		ResultSet rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		List<PRODUCTION_INFO_TBL_1> list = new ArrayList<PRODUCTION_INFO_TBL_1>();
		
		String PRODUCTION_CC = "";
		String PRODUCTION_SERIAL_NUM = "";
		
		while (rs.next()) {
			/*
			for(int i=1 ; i<=columnCnt ; i++){
			                	   // 컬럼명                   //데이터
				System.out.println(rsmd.getColumnName(i)+","+rs.getString(rsmd.getColumnName(i)));  
			}
			*/
			PRODUCTION_CC = rs.getString("PRODUCTION_CC");
			PRODUCTION_SERIAL_NUM = rs.getString("PRODUCTION_SERIAL_NUM");
		}
		
		PRODUCTION_INFO_TBL_1 data = new PRODUCTION_INFO_TBL_1();
		
		if(PRODUCTION_CC.equals("E"))
			return data;
		
		//System.out.println("----------");
		
		/*
		sql = "select \r\n"
				+ "        	D.PRODUCT_ITEM_NAME									-- 모델명\r\n"
				+ "        , 	B.q_ty1 PRODUCTION_VOLUME							-- 생산수량\r\n"
				+ "        , 	ifnull(A.q_ty2,0) PRODUCTION_DEFECT_CODE 						-- 블량수량\r\n"
				+ "        ,	B.q_ty1 - ifnull(A.q_ty2,0) QUANTITY_GOODS					-- 양품수량\r\n"
				+ "        ,	C.PRODUCTION_MODIFY_D								-- 시작시간\r\n"
				+ "from \r\n"
				+ "(\r\n"
				+ "	select\r\n"
				+ "		*\r\n"
				+ "	from\r\n"
				+ "		PRODUCTION_INFO_TBL\r\n"
				+ "     where PRODUCTION_SERIAL_NUM = ?   \r\n"
				+ ") AS C\r\n"
				+ "left outer join (select PRODUCTION_SERIAL_NUM,sum(PRODUCTION_VOLUME) AS q_ty2\r\n"
				+ "      from PRODUCTION_INFO_TBL\r\n"
				+ "        where date(PRODUCTION_MODIFY_D) = ? and PRODUCTION_DEFECT_CODE <> \"\" and PRODUCTION_EQUIPMENT_CODE = 'E002'\r\n"
				+ "      group by PRODUCTION_SERIAL_NUM)\r\n"
				+ "AS A on A.PRODUCTION_SERIAL_NUM = C.PRODUCTION_SERIAL_NUM\r\n"
				+ "left outer join (select PRODUCTION_SERIAL_NUM,sum(PRODUCTION_VOLUME) AS q_ty1\r\n"
				+ "      from PRODUCTION_INFO_TBL\r\n"
				+ "        where date(PRODUCTION_MODIFY_D) = ? and PRODUCTION_DEFECT_CODE = \"\" and PRODUCTION_EQUIPMENT_CODE = 'E002'\r\n"
				+ "      group by PRODUCTION_SERIAL_NUM)\r\n"
				+ "AS B on B.PRODUCTION_SERIAL_NUM = C.PRODUCTION_SERIAL_NUM\r\n"
				+ "inner join PRODUCT_INFO_TBL D on C.PRODUCTION_PRODUCT_CODE = D.PRODUCT_ITEM_CODE\r\n"
				+ "group by C.PRODUCTION_SERIAL_NUM, C.PRODUCTION_EQUIPMENT_CODE, C.PRODUCTION_MOLD_INFO_CODE, C.PRODUCTION_PRODUCT_CODE";
		*/
		sql = "select\r\n"
				+ "				MID(t1.PRODUCTION_SERIAL_NUM,7,4) AS 			TIME						-- 시간\r\n"
				+ "			,	t2.PRODUCT_ITEM_NAME							PRODUCT_ITEM_NAME			-- 모델명\r\n"
				+ "			,	sum(PRODUCTION_VOLUME)							PRODUCTION_VOLUME			-- 생산수량\r\n"
				+ "            ,	sum(PRODUCTION_BAD)								PRODUCTION_DEFECT_CODE		-- 불량수량\r\n"
				+ "            ,	t1.PRODUCTION_SERIAL_NUM						PRODUCTION_SERIAL_NUM		-- 시리얼 번호\r\n"
				+ "            ,	sum(PRODUCTION_VOLUME) - sum(PRODUCTION_BAD)	QUANTITY_GOODS				-- 양품수량\r\n"
				+ "            ,	t1.PRODUCTION_MODIFY_D							PRODUCTION_MODIFY_D			-- 시간\r\n"
				+ "from	PRODUCTION_MGMT_TBL	as t1\r\n"
				+ "inner join PRODUCT_INFO_TBL t2 on t1.PRODUCTION_PRODUCT_CODE = t2.PRODUCT_ITEM_CODE\r\n"
				+ "where date(t1.PRODUCTION_MODIFY_D) = ? and t1.PRODUCTION_EQUIPMENT_CODE = 'M002'\r\n"
				+ "and PRODUCTION_SERIAL_NUM = ?   \r\n"
				+ "group by t1.PRODUCTION_SERIAL_NUM, t1.PRODUCTION_EQUIPMENT_CODE, t1.PRODUCTION_MOLD_INFO_CODE, t1.PRODUCTION_PRODUCT_CODE";
		
		pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, date);
		pstmt.setString(2, PRODUCTION_SERIAL_NUM);
		
		rs = pstmt.executeQuery();
		
		rsmd = rs.getMetaData();
		columnCnt = rsmd.getColumnCount(); //컬럼의 수
		
		while (rs.next()) {
			data.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
			data.setPRODUCTION_VOLUME(rs.getString("PRODUCTION_VOLUME"));
			data.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
			data.setQUANTITY_GOODS(rs.getString("QUANTITY_GOODS"));
			data.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D"));
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return data;
	}
	
}
