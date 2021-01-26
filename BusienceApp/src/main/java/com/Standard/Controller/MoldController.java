package com.Standard.Controller;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.Common.Controller.HomeController;
import com.Standard.Dto.DTL_TBL;

@Controller("MoldController")
@RequestMapping("mold")
public class MoldController {

   @Autowired
   SimpleDriverDataSource dataSource;
   
   String BUSINESS_PLACE_CODE_LIST_Output = "",MOLD_INFO_RANK_LIST_Output = "";
   
   @RequestMapping(value = "",method = {RequestMethod.GET})
   public String list(Model model,HttpServletRequest request) throws SQLException
   {
      model.addAttribute("BUSINESS_PLACE_CODE_LIST", list_output("'2'",request));
      //MOLD_INFO_RANK_LIST
      model.addAttribute("MOLD_INFO_RANK_LIST", list_output("'11'",request));
      model.addAttribute("BUSINESS_PLACE_CODE_LIST_Output", BUSINESS_PLACE_CODE_LIST_Output);
      model.addAttribute("MOLD_INFO_RANK_LIST_Output", MOLD_INFO_RANK_LIST_Output);

      return "Standard/Mold";
   }
   
   @RequestMapping(value = "/version2",method = {RequestMethod.GET})
   public String list2(Model model,HttpServletRequest request) throws SQLException
   {
      model.addAttribute("BUSINESS_PLACE_CODE_LIST", list_output("'2'",request));
      //MOLD_INFO_RANK_LIST
      model.addAttribute("MOLD_INFO_RANK_LIST", list_output("'11'",request));
      model.addAttribute("BUSINESS_PLACE_CODE_LIST_Output", BUSINESS_PLACE_CODE_LIST_Output);
      model.addAttribute("MOLD_INFO_RANK_LIST_Output", MOLD_INFO_RANK_LIST_Output);

      return "Standard/Mold2";
   }
   
   // 세부 코드 테이블 값 가져오기
   public List<DTL_TBL> list_output(String codevalue,HttpServletRequest request) throws SQLException
   {
      String sql = "select * from DTL_TBL where NEW_TBL_CODE = "+codevalue+" and CHILD_TBL_USE_STATUS='true' order by CHILD_TBL_NUM+0";
      Connection conn = dataSource.getConnection();
      PreparedStatement pstmt = conn.prepareStatement(sql);
      ResultSet rs = pstmt.executeQuery();
      
      List<DTL_TBL> list = new ArrayList<DTL_TBL>();
      
      String output = "";
      while (rs.next()) {
         DTL_TBL data =new DTL_TBL();
         data.setNEW_TBL_CODE(rs.getString("NEW_TBL_CODE"));
         data.setCHILD_TBL_TYPE(rs.getString("CHILD_TBL_TYPE"));
         data.setCHILD_TBL_NUM(rs.getString("CHILD_TBL_NUM"));
         output += "\""+rs.getString("CHILD_TBL_NUM")+":"+rs.getString("CHILD_TBL_TYPE")+"\":\""+rs.getString("CHILD_TBL_NUM")+":"+rs.getString("CHILD_TBL_TYPE")+"\",";
         list.add(data);
      }
      
      if (output.endsWith(",")) {
         output = output.substring(0, output.length() - 1);
      }
      if(codevalue=="'2'")
         BUSINESS_PLACE_CODE_LIST_Output = output;
      else
         MOLD_INFO_RANK_LIST_Output = output;
      
      rs.close();
      pstmt.close();
      conn.close();
      
      return list;
   }
   
   @RequestMapping(value = "update",method = {RequestMethod.POST})
   public String update(HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException
   {
      String data = request.getParameter("dataList");
      HttpSession httpSession = request.getSession();
      String modifier = (String) httpSession.getAttribute("id");
      //System.out.println(modifier);
      
      JSONParser parser = new JSONParser();
      JSONObject obj  = (JSONObject)parser.parse(data);
      JSONArray dataList = (JSONArray) obj.get("data");
      
      java.util.Date date = new java.util.Date();
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
      String datestr = sdf.format(date.getTime());
      
      if(dataList.size() > 0)
      {
         for (int i = 0; i < dataList.size(); i++)
         {
            JSONObject datas = (JSONObject) dataList.get(i);
            //System.out.println(datas.toJSONString());
            
            String sql = "UPDATE MOLD_INFO_TBL set ";
            //sql += "'BUSINESS_PLACE'="+(String)datas.get("business_PLACE");
            String business_PLACE_Origin = (String)datas.get("business_PLACE_CODE");
            String[] business_PLACE_Convert = business_PLACE_Origin.split(":");
            String business_PLACE = business_PLACE_Convert[0];
            sql += "BUSINESS_PLACE='"+business_PLACE+"'";
            
            sql += ",MOLD_INFO_NAME='"+(String)datas.get("mold_INFO_NAME")+"'";
            
            String mold_INFO_RANK_Origin = (String)datas.get("mold_INFO_RANK");
            String[] mold_INFO_RANK_Origin_Convert = mold_INFO_RANK_Origin.split(":");
            String mold_INFO_RANK = mold_INFO_RANK_Origin_Convert[0];
            //int mold_INFO_RANK_Covert = Integer.parseInt(mold_INFO_RANK);
            //mold_INFO_RANK_Covert = mold_INFO_RANK_Covert+1;
            sql += ",MOLD_INFO_RANK='"+mold_INFO_RANK+"'";
            
            sql += ",MOLD_INFO_STND='"+(String)datas.get("mold_INFO_STND")+"'";
            sql += ",MOLD_ITEM_CODE='"+(String)datas.get("mold_ITEM_CODE")+"'";
            sql += ",MANUFACTURER='"+(String)datas.get("manufacturer")+"'";
            sql += ",BUSINESS_PERSON='"+(String)datas.get("business_PERSON")+"'";
            
            if((String)datas.get("mold_RECEIVED_D") == "Invalid date" || (String)datas.get("mold_RECEIVED_D") == "")
               sql += ",BUSINESS_PERSON='"+datestr+"'";
            else
               sql += ",BUSINESS_PERSON='"+datas.get("mold_RECEIVED_D")+"'";
            sql += ",MOLD_USE_STATUS='"+(String)datas.get("mold_USE_STATUS")+"'";
            
            HttpSession session = request.getSession();
            sql += ",USER_MODIFIER='"+session.getAttribute("name")+"'";
            sql += ",USER_MODIFY_D='"+datestr+"'";
            
            sql += " where MOLD_INFO_NO='"+(String)datas.get("mold_INFO_NO")+"'";
            
            //System.out.println(sql);
            HomeController.LogInsert("", "2. Update", sql, request);
            
            Connection conn = dataSource.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
         }
      }
      
      return "redirect:/mold";
   }
   
   @RequestMapping(value = "update2",method = {RequestMethod.POST})
   public String update2(HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException
   {
      String data = request.getParameter("dataList");
      //System.out.println(data);
      HttpSession httpSession = request.getSession();
      String modifier = (String) httpSession.getAttribute("id");
      System.out.println("수정자 =" +modifier);
      
      JSONParser parser = new JSONParser();
      JSONObject obj  = (JSONObject)parser.parse(data);
      
      java.util.Date date = new java.util.Date();
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
      String datestr = sdf.format(date.getTime());
      
      String sql = "UPDATE MOLD_INFO_TBL set ";
      //sql += "'BUSINESS_PLACE'="+(String)datas.get("business_PLACE");
      sql += "BUSINESS_PLACE='"+String.valueOf(obj.get("BUSINESS_PLACE_CODE"))+"'";
      
      sql += ",MOLD_INFO_NAME='"+obj.get("MOLD_INFO_NAME")+"'";
      
      sql += ",MOLD_INFO_RANK='"+obj.get("MOLD_INFO_RANK")+"'";
      
      sql += ",MOLD_INFO_STND='"+obj.get("MOLD_INFO_STND")+"'";
      sql += ",MOLD_ITEM_CODE='"+obj.get("MOLD_ITEM_CODE")+"'";
      sql += ",MANUFACTURER='"+obj.get("MANUFACTURER")+"'";
      sql += ",BUSINESS_PERSON='"+obj.get("BUSINESS_PERSON")+"'";
      
      if(obj.get("MOLD_RECEIVED_D") == "Invalid date" || obj.get("MOLD_RECEIVED_D") == "")
         sql += ",MOLD_RECEIVED_D='"+datestr+"'";
      else
         sql += ",MOLD_RECEIVED_D='"+obj.get("MOLD_RECEIVED_D")+"'";
      sql += ",MOLD_USE_STATUS='"+(String)obj.get("MOLD_USE_STATUS")+"'";
      
      sql += ",USER_MODIFIER='"+modifier+"'";
      sql += ",USER_MODIFY_D='"+datestr+"'";
      
      if(obj.get("MOLD_CUBIT").equals(""))
         sql += ",MOLD_CUBIT='"+1+"'";
      else
         sql += ",MOLD_CUBIT='"+obj.get("MOLD_CUBIT")+"'";
      
      sql += " where MOLD_INFO_NO='"+(String)obj.get("MOLD_INFO_NO")+"'";
      
      //System.out.println(sql);
      HomeController.LogInsert("", "2. Update", sql, request);
      
      Connection conn = dataSource.getConnection();
      PreparedStatement pstmt = conn.prepareStatement(sql);
      pstmt.executeUpdate();
      pstmt.close();
      conn.close();
      return "redirect:/mold";
   }
   
   @RequestMapping(value = "delete",method = {RequestMethod.POST})
   public String delete(HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException
   {
      String data = request.getParameter("dataList");
      
      JSONParser parser = new JSONParser();
      JSONObject obj  = (JSONObject)parser.parse(data);
      JSONArray dataList = (JSONArray) obj.get("data");
      
      String no = "(";
      if(dataList.size() > 0)
      {
         for (int i = 0; i < dataList.size(); i++)
         {
            JSONObject datas = (JSONObject) dataList.get(i);
            //System.out.println(datas.toJSONString());
            
            no+="'"+(String)datas.get("mold_INFO_NO")+"',";
         }
      }
      
      if (no.endsWith(",")) {
         no = no.substring(0, no.length() - 1);
      }
      no += ")";
      
      String sql = "delete from MOLD_INFO_TBL where MOLD_INFO_NO in "+no;
      
      //System.out.println(sql);
      HomeController.LogInsert("", "3. Delete", sql, request);
      
      Connection conn = dataSource.getConnection();
      PreparedStatement pstmt = conn.prepareStatement(sql);
      pstmt.executeUpdate();
      pstmt.close();
      conn.close();
      
      
      return "redirect:/mold";
   }
   
   @RequestMapping(value = "delete2",method = {RequestMethod.POST})
   public String delete2(HttpServletRequest request) throws ParseException, SQLException, UnknownHostException, ClassNotFoundException
   {
      String sql = "delete from MOLD_INFO_TBL where MOLD_INFO_NO ="+request.getParameter("MOLD_INFO_NO");
      
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
      }finally {
         pstmt.close();
         conn.close();
      }
      return "redirect:/mold";
   }
   
   @RequestMapping(value = "/mold_ItemCode",method = {RequestMethod.GET})
   public String Mold_ItemCode(Model model)
   {
      return "PopUp/Standard/Mold_ItemCode";
   }
   
   @RequestMapping(value = "/mold_ItemCode2",method = {RequestMethod.GET})
   public String Mold_ItemCode2(Model model)
   {
      return "PopUp/Standard/Mold_ItemCode2";
   }
   
   @RequestMapping(value = "/mold_ItemCode3",method = {RequestMethod.GET})
   public String Mold_ItemCode3(Model model)
   {
      return "PopUp/Standard/Mold_ItemCode3";
   }
   
}