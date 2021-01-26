package com.Standard.Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.Standard.Dto.DTL_TBL;
import com.Standard.Dto.PRODUCT_INFO_TBL;

@Controller("ProductController")
@RequestMapping("product")
public class ProductController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "",method = {RequestMethod.GET})
	   public String list(Model model) throws SQLException
	   {
		// 사업장 불러오는 쿼리
		String sql = "select * from DTL_TBL where NEW_TBL_CODE = '2' and CHILD_TBL_USE_STATUS='true'";
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		List<DTL_TBL> companyList  = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("사업장 : "+data.toString());
			companyList.add(data);
		}
		// 단위 불러오는 쿼리
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '4' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> unitList = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("단위 : "+data.toString());
			unitList.add(data);
		}
		// 자재분류 불러오는 쿼리
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '5' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> mtrlClsfcList = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("자재분류 : "+data.toString());
			mtrlClsfcList.add(data);
		}
		// 품목분류1 불러오는 쿼리
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '6' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> itemClsfc1List = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("품목분류1 : "+data.toString());
			itemClsfc1List.add(data);
		}
		// 품목분류2 불러오는 쿼리
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '7' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> itemClsfc2List = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("품목분류2 : "+data.toString());
			itemClsfc2List.add(data);
		}
		
		// 재질 불러오는 쿼리
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '8' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> materialList = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("재질 : "+data.toString());
			materialList.add(data);
		}
		// 품목상태 불러오는 쿼리
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '9' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> itemStatusList = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("품목상태 : "+data.toString());
			itemStatusList.add(data);
		}
		// 기본창고 불러오는 쿼리
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '10' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> basicWarehouseList = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data = new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println("기본창고 : "+data.toString());
			basicWarehouseList.add(data);
		}
		// 제품 정보 관리 list set
		List<PRODUCT_INFO_TBL> productlist = new ArrayList<PRODUCT_INFO_TBL>();
		
		  sql = "SELECT \r\n"
		  		+ "			A.PRODUCT_BUSINESS_PLACE,\r\n"
		  		+ "            A.PRODUCT_ITEM_CODE,\r\n"
		  		+ "            A.PRODUCT_OLD_ITEM_CODE,\r\n"
		  		+ "            A.PRODUCT_ITEM_NAME,\r\n"
		  		+ "            A.PRODUCT_INFO_STND_1,\r\n"
		  		+ "            A.PRODUCT_INFO_STND_2,\r\n"
		  		+ "            A.PRODUCT_UNIT,\r\n"
		  		+ "            A.PRODUCT_MATERIAL,\r\n"
		  		+ "            A.PRODUCT_MTRL_CLSFC,\r\n"
		  		+ "            A.PRODUCT_ITEM_CLSFC_1,\r\n"
		  		+ "            A.PRODUCT_ITEM_CLSFC_2,\r\n"
		  		+ "            A.PRODUCT_SUBSID_MATL_MGMT,\r\n"
		  		+ "            A.PRODUCT_ITEM_STTS,\r\n"
		  		+ "            A.PRODUCT_BASIC_WAREHOUSE,\r\n"
		  		+ "            A.PRODUCT_SFTY_STOCK,\r\n"
		  		+ "            A.PRODUCT_MIN_VOL_ORDERS,\r\n"
		  		+ "            A.PRODUCT_MAX_VOL_ORDERS,\r\n"
		  		+ "            A.PRODUCT_BUYER,\r\n"
		  		+ "            A.PRODUCT_WRHSN_INSPC,\r\n"
		  		+ "            A.PRODUCT_USE_STATUS,\r\n"
		  		+ "            A.PRODUCT_MODIFY_D,\r\n"
		  		+ "			t1.USER_NAME PRODUCT_MODIFIER\r\n"
		  		+ "		, 	B.CHILD_TBL_TYPE AS PRODUCT_BUSINESS_PLACE_NAME\r\n"
		  		+ "        , 	C.CHILD_TBL_TYPE AS PRODUCT_UNIT_NAME\r\n"
		  		+ "        , 	D.CHILD_TBL_TYPE AS PRODUCT_MATERIAL_NAME\r\n"
		  		+ "        , 	E.CHILD_TBL_TYPE AS PRODUCT_MTRL_CLSFC_NAME\r\n"
		  		+ "        , 	F.CHILD_TBL_TYPE AS PRODUCT_ITEM_CLSFC_1_NAME\r\n"
		  		+ "        , 	G.CHILD_TBL_TYPE AS PRODUCT_ITEM_CLSFC_2_NAME\r\n"
		  		+ "        , 	H.CHILD_TBL_TYPE AS PRODUCT_ITEM_STTS_NAME\r\n"
		  		+ "        , 	I.CHILD_TBL_TYPE AS PRODUCT_BASIC_WAREHOUSE_NAME \r\n"
		  		+ "FROM PRODUCT_INFO_TBL A \r\n"
		  		+ "INNER JOIN USER_INFO_TBL t1 ON A.PRODUCT_MODIFIER = t1.USER_CODE \r\n"
		  		+ "INNER JOIN DTL_TBL B ON A.PRODUCT_BUSINESS_PLACE = B.CHILD_TBL_NUM \r\n"
		  		+ "INNER JOIN DTL_TBL C ON A.PRODUCT_UNIT = C.CHILD_TBL_NUM \r\n"
		  		+ "INNER JOIN DTL_TBL D ON A.PRODUCT_MATERIAL = D.CHILD_TBL_NUM\r\n"
		  		+ "INNER JOIN DTL_TBL E ON A.PRODUCT_MTRL_CLSFC = E.CHILD_TBL_NUM \r\n"
		  		+ "INNER JOIN DTL_TBL F ON A.PRODUCT_ITEM_CLSFC_1 = F.CHILD_TBL_NUM \r\n"
		  		+ "INNER JOIN DTL_TBL G ON A.PRODUCT_ITEM_CLSFC_2 = G.CHILD_TBL_NUM \r\n"
		  		+ "INNER JOIN DTL_TBL H ON A.PRODUCT_ITEM_STTS = H.CHILD_TBL_NUM \r\n"
		  		+ "INNER JOIN DTL_TBL I ON A.PRODUCT_BASIC_WAREHOUSE = I.CHILD_TBL_NUM \r\n"
		  		+ "WHERE B.NEW_TBL_CODE=2 and  C.NEW_TBL_CODE=4 and D.NEW_TBL_CODE=8 and E.NEW_TBL_CODE=5 and F.NEW_TBL_CODE=6 and G.NEW_TBL_CODE=7 and H.NEW_TBL_CODE=9 and I.NEW_TBL_CODE=10";
	      
		  //System.out.println(sql);
		  
		  conn = dataSource.getConnection();
	      pstmt = conn.prepareStatement(sql);
	      rs = pstmt.executeQuery();
	      
	      while(rs.next()) {
	    	  PRODUCT_INFO_TBL data = new PRODUCT_INFO_TBL();
	    	  data.setPRODUCT_BUSINESS_PLACE(rs.getString("PRODUCT_BUSINESS_PLACE"));
	    	  data.setPRODUCT_BUSINESS_PLACE_NAME(rs.getString("PRODUCT_BUSINESS_PLACE_NAME"));
	    	  data.setPRODUCT_ITEM_CODE(rs.getString("PRODUCT_ITEM_CODE"));
	    	  data.setPRODUCT_OLD_ITEM_CODE(rs.getString("PRODUCT_OLD_ITEM_CODE"));
	    	  data.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
	    	  data.setPRODUCT_INFO_STND_1(rs.getString("PRODUCT_INFO_STND_1"));
	    	  data.setPRODUCT_INFO_STND_2(rs.getString("PRODUCT_INFO_STND_2"));
	    	  data.setPRODUCT_UNIT(rs.getString("PRODUCT_UNIT"));
	    	  data.setPRODUCT_UNIT_NAME(rs.getString("PRODUCT_UNIT_NAME"));
	    	  data.setPRODUCT_MATERIAL(rs.getString("PRODUCT_MATERIAL"));
	    	  data.setPRODUCT_MATERIAL_NAME(rs.getString("PRODUCT_MATERIAL_NAME"));
	    	  data.setPRODUCT_MTRL_CLSFC(rs.getString("PRODUCT_MTRL_CLSFC"));
	    	  data.setPRODUCT_MTRL_CLSFC_NAME(rs.getString("PRODUCT_MTRL_CLSFC_NAME"));
	    	  data.setPRODUCT_ITEM_CLSFC_1(rs.getString("PRODUCT_ITEM_CLSFC_1"));
	    	  data.setPRODUCT_ITEM_CLSFC_1_NAME(rs.getString("PRODUCT_ITEM_CLSFC_1_NAME"));
	    	  data.setPRODUCT_ITEM_CLSFC_2(rs.getString("PRODUCT_ITEM_CLSFC_2"));
	    	  data.setPRODUCT_ITEM_CLSFC_2_NAME(rs.getString("PRODUCT_ITEM_CLSFC_2_NAME"));
	    	  data.setPRODUCT_SUBSID_MATL_MGMT(rs.getString("PRODUCT_SUBSID_MATL_MGMT"));
	    	  data.setPRODUCT_ITEM_STTS(rs.getString("PRODUCT_ITEM_STTS"));
	    	  data.setPRODUCT_ITEM_STTS_NAME(rs.getString("PRODUCT_ITEM_STTS_NAME"));
	    	  data.setPRODUCT_BASIC_WAREHOUSE(rs.getString("PRODUCT_BASIC_WAREHOUSE"));
	    	  data.setPRODUCT_BASIC_WAREHOUSE_NAME(rs.getString("PRODUCT_BASIC_WAREHOUSE_NAME"));
	    	  data.setPRODUCT_SFTY_STOCK(rs.getInt("PRODUCT_SFTY_STOCK"));
	    	  data.setPRODUCT_MIN_VOL_ORDERS(rs.getFloat("PRODUCT_MIN_VOL_ORDERS"));
	    	  data.setPRODUCT_MAX_VOL_ORDERS(rs.getFloat("PRODUCT_MAX_VOL_ORDERS"));
	    	  data.setPRODUCT_BUYER(rs.getString("PRODUCT_BUYER"));
	    	  data.setPRODUCT_WRHSN_INSPC(rs.getString("PRODUCT_WRHSN_INSPC"));
	    	  data.setPRODUCT_USE_STATUS(rs.getString("PRODUCT_USE_STATUS"));
	    	  data.setPRODUCT_MODIFY_D(rs.getString("PRODUCT_MODIFY_D"));
	    	  data.setPRODUCT_MODIFIER(rs.getString("PRODUCT_MODIFIER"));
	    	  productlist.add(data);
	    	  //System.out.println("제품 정보 리스트 : " + data);
	      
	      }
	      
	      model.addAttribute("productlist", productlist);
	      model.addAttribute("companyList", companyList);
	      model.addAttribute("unitList", unitList);
	      model.addAttribute("mtrlClsfcList", mtrlClsfcList);
	      model.addAttribute("itemClsfc1List", itemClsfc1List);
	      model.addAttribute("itemClsfc2List", itemClsfc2List);
	      model.addAttribute("materialList", materialList);
	      model.addAttribute("itemStatusList", itemStatusList);
	      model.addAttribute("basicWarehouseList", basicWarehouseList);
	      
	      rs.close();
	      pstmt.close();
	      conn.close();
		return "Standard/Product";
	   }
	
	@RequestMapping(value = "popup",method = {RequestMethod.GET})
	public String popup()
	{
		return "PopUp/product_popup";
	}
}
