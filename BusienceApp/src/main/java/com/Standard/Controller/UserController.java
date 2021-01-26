package com.Standard.Controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
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
import com.Standard.Dto.USER_INFO_TBL;
@Controller("UserController")
@RequestMapping("user")
public class UserController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "",method = {RequestMethod.GET})
	public String list(Model model) throws SQLException
	{
		String sql = "select * from DTL_TBL where NEW_TBL_CODE = '1' and CHILD_TBL_USE_STATUS='true'";
		Connection conn = dataSource.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		List<DTL_TBL> userTypeList = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data =new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println(data.toString());
			userTypeList.add(data);
		}
		
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '2' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> companyList = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data =new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println(data.toString());
			companyList.add(data);
		}
		
		sql = "select * from DTL_TBL where NEW_TBL_CODE = '3' and CHILD_TBL_USE_STATUS='true'";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		List<DTL_TBL> deptList = new ArrayList<DTL_TBL>();
		
		while (rs.next()) {
			DTL_TBL data =new DTL_TBL();
			data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
			data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
			data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
			//System.out.println(data.toString());
			deptList.add(data);
		}
		
		List<USER_INFO_TBL> userlist = new ArrayList<USER_INFO_TBL>();
		sql = "SELECT A.*,B.CHILD_TBL_TYPE AS COMPANY_NAME,C.CHILD_TBL_TYPE AS USER_TYPE_NAME,D.CHILD_TBL_TYPE AS DEPT_CODE_NAME FROM USER_INFO_TBL A INNER JOIN DTL_TBL B ON A.COMPANY = B.CHILD_TBL_NUM INNER JOIN DTL_TBL C ON A.USER_TYPE = C.CHILD_TBL_NUM INNER JOIN DTL_TBL D ON A.DEPT_CODE = D.CHILD_TBL_NUM WHERE B.NEW_TBL_CODE=2 and C.NEW_TBL_CODE=1 and D.NEW_TBL_CODE=3";
		conn = dataSource.getConnection();
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCnt = rsmd.getColumnCount(); //컬럼의 수
		while (rs.next()) {
			//for(int j=1 ; j<=columnCnt ; j++){
    		// 컬럼명                                   //데이터
				//System.out.println(rsmd.getColumnName(j)+","+rs.getString(rsmd.getColumnName(j)));  
			//}
			USER_INFO_TBL data = new USER_INFO_TBL();
			data.setUSER_CODE(rs.getString("USER_CODE"));
			data.setUSER_PASSWORD(rs.getString("USER_PASSWORD"));
			data.setUSER_NAME(rs.getString("USER_NAME"));
			data.setUSER_TYPE(rs.getString("USER_TYPE"));
			data.setCOMPANY(rs.getString("COMPANY"));
			data.setDEPT_CODE(rs.getString("DEPT_CODE"));
			data.setUSER_MODIFIER(rs.getString("USER_MODIFIER"));
			data.setUSER_MODIFY_D(rs.getString("USER_MODIFY_D"));
			data.setUSER_USE_STATUS(rs.getString("USER_USE_STATUS"));
			data.setCOMPANY_NAME(rs.getString("COMPANY_NAME"));
			data.setUSER_TYPE_NAME(rs.getString("USER_TYPE_NAME"));
			data.setDEPT_NAME(rs.getString("DEPT_CODE_NAME"));
			userlist.add(data);
			//System.out.println(data);
		}
		model.addAttribute("userlist", userlist);
		model.addAttribute("userTypeList", userTypeList);
		model.addAttribute("companyList", companyList);
		model.addAttribute("deptList", deptList);
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return "Standard/User";
	}
	
}
