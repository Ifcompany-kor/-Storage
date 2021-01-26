package com.FinalHistory.Controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.Production.Dto.PRODUCTION_INFO_;

@RestController("FinalRestController")
@RequestMapping("FinalRest")
public class FinalRestController {

   @Autowired
   SimpleDriverDataSource dataSource;

   // 최종 검사(제품별)
   @RequestMapping(value = "/FinalProduct", method = RequestMethod.GET)
   public List<PRODUCTION_INFO_> pviewSearch(HttpServletRequest request)
         throws ParseException, SQLException, org.json.simple.parser.ParseException {
      String data = request.getParameter("data");
      JSONParser parser = new JSONParser();
      JSONObject obj = (JSONObject) parser.parse(data);

      String sql = "";
      Connection conn = dataSource.getConnection();

      HttpSession session = request.getSession();
      String id = (String) session.getAttribute("id");

      // list 조회 쿼리
      List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

      sql = "SELECT \r\n" + "      A.PRODUCTION_INFO_NUM, \r\n" + "      A.PRODUCTION_SERIAL_NUM , \r\n"
              + "      A.PRODUCTION_PRODUCT_CODE,  \r\n" + "      C.PRODUCT_ITEM_NAME,\r\n"
              + "        sum(A.PRODUCTION_VOLUME) AS PRODUCTION_P_Qty ,\r\n"
              + "        sum(A.PRODUCTION_BAD) AS PRODUCTION_B_Qty, \r\n"
              + "        A.PRODUCTION_DEFECT_CODE,     \r\n" + "        B.DEFECT_NAME PRODUCTION_DEFECT_NAME, \r\n"
              + "        round(sum(A.PRODUCTION_BAD)/sum(A.PRODUCTION_VOLUME)*100,2) AS PRODUCTION_DEFECT_RATE, \r\n"
              + "        A.PRODUCTION_EQUIPMENT_CODE ,   \r\n"
              + "        D.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
              + "        A.PRODUCTION_MOLD_INFO_CODE,    \r\n"
              + "        E.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n" + "        A.PRODUCTION_MODIFY_D    \r\n"
              + "FROM PRODUCTION_MGMT_TBL AS A\r\n" + "left outer join \r\n"
              + "     DEFECT_INFO_TBL B ON A.PRODUCTION_DEFECT_CODE = B.DEFECT_CODE\r\n" + "inner join \r\n"
              + "      PRODUCT_INFO_TBL C ON A.PRODUCTION_PRODUCT_CODE = C.PRODUCT_ITEM_CODE \r\n" + "inner join \r\n"
              + "      EQUIPMENT_INFO_TBL D ON A.PRODUCTION_EQUIPMENT_CODE = D.EQUIPMENT_INFO_CODE\r\n"
              + "inner join \r\n" + "      MOLD_INFO_TBL E ON A.PRODUCTION_MOLD_INFO_CODE = E.MOLD_INFO_NO   \r\n"
              + "";

        String where = "";
        
        where = " where PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '" + obj.get("endDate")+" 08:29:59'";
        //where = " where PRODUCTION_MODIFY_D between '" + obj.get("startDate") + "' and date('" + obj.get("endDate")
          //+ "')+1";
      String  PRODUCT_ITEM_CODE = ""; 
      
      if(obj.get("PRODUCT_ITEM_CODE")  == null)
         PRODUCT_ITEM_CODE = "";    
      else
         PRODUCT_ITEM_CODE =  (String) obj.get("PRODUCT_ITEM_CODE");
      
      String  PRODUCT_ITEM_NAME = "";       
      
      if(obj.get("PRODUCT_ITEM_NAME")  == null)
         PRODUCT_ITEM_NAME = "";    
      else
         PRODUCT_ITEM_NAME =  (String) obj.get("PRODUCT_ITEM_NAME");
      
      if (obj.get("PRODUCT_ITEM_CODE") != null)
            if(!obj.get("PRODUCT_ITEM_CODE").equals("")) {
         //if (!obj.get("PRODUCT_ITEM_CODE").equals(""))
         
         where += " and PRODUCTION_PRODUCT_CODE like '%" + PRODUCT_ITEM_CODE + "%'"
               + " and PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%'";
      }
   
      else {   
         where += " and (PRODUCT_ITEM_NAME like '%" + PRODUCT_ITEM_NAME + "%'"
               + " OR PRODUCTION_PRODUCT_CODE like '%" + PRODUCT_ITEM_NAME + "%')";
      }
      
      sql += where;
      sql += " group by  PRODUCTION_SERIAL_NUM WITH ROLLUP";
      System.out.println(sql);
      PreparedStatement pstmt = conn.prepareStatement(sql);

      ResultSet rs = pstmt.executeQuery();

      int i = 1;

      while (rs.next()) {

      
            PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
            // data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
            data1.setPRODUCTION_INFO_NUM(String.valueOf(i));
            i++;
            data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
            data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
            data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
            data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty"));
            data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_B_Qty"));
            // data1.setPRODUCTION_DEFECT_RATE("0");
            data1.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
            data1.setPRODUCTION_DEFECT_NAME(rs.getString("PRODUCTION_DEFECT_NAME"));
            if (rs.getString("PRODUCTION_DEFECT_RATE") == null) {
               data1.setPRODUCTION_DEFECT_RATE("");
            } else
               data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%");
            data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
            data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
            data1.setPRODUCTION_MOLD_INFO_CODE(rs.getString("PRODUCTION_MOLD_INFO_CODE"));
            data1.setPRODUCTION_MOLD_INFO_NAME(rs.getString("PRODUCTION_MOLD_INFO_NAME"));
            data1.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D"));
            data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
            list.add(data1);

         
      }
      if (list.size() > 0) {
         // PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();

         list.get(list.size() - 1).setPRODUCTION_INFO_NUM("");
         list.get(list.size() - 1).setPRODUCTION_SERIAL_NUM("Grand Total");
         list.get(list.size() - 1).setPRODUCTION_PRODUCT_CODE(" ");
         list.get(list.size() - 1).setPRODUCT_ITEM_NAME(" ");
         float pqty = list.get(list.size() - 1).getPRODUCTION_P_Qty();
         float bqty = list.get(list.size() - 1).getPRODUCTION_B_Qty();
         list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_CODE(" ");
         list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_INFO_NAME(" ");
         list.get(list.size() - 1).setPRODUCTION_MOLD_INFO_CODE(" ");
         list.get(list.size() - 1).setPRODUCTION_MOLD_INFO_NAME(" ");
         list.get(list.size() - 1).setPRODUCTION_MODIFY_D(" ");

         float totalrate = bqty/pqty*100;
         list.get(list.size() - 1).setPRODUCTION_DEFECT_RATE(String.format("%.2f", totalrate) + "%");

      }

      pstmt.close();
      conn.close();
      return list;
   }

   // 최종 검사(설비별)
   @RequestMapping(value = "/FinalEquipment", method = RequestMethod.GET)
   public List<PRODUCTION_INFO_> pviewSearch1(HttpServletRequest request)
         throws ParseException, SQLException, org.json.simple.parser.ParseException {
      String data = request.getParameter("data");
      JSONParser parser = new JSONParser();
      JSONObject obj = (JSONObject) parser.parse(data);

      String sql = "";
      Connection conn = dataSource.getConnection();

      HttpSession session = request.getSession();
      String id = (String) session.getAttribute("id");

      // list 조회 쿼리
      List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

      sql = "SELECT \r\n" + "      A.PRODUCTION_INFO_NUM, \r\n" + "      A.PRODUCTION_SERIAL_NUM , \r\n"
            + "      A.PRODUCTION_PRODUCT_CODE,  \r\n" + "      C.PRODUCT_ITEM_NAME,\r\n"
            + "        sum(A.PRODUCTION_VOLUME) AS PRODUCTION_P_Qty ,\r\n"
            + "        sum(A.PRODUCTION_BAD) AS PRODUCTION_B_Qty, \r\n"
            + "        A.PRODUCTION_DEFECT_CODE,     \r\n" + "        B.DEFECT_NAME PRODUCTION_DEFECT_NAME, \r\n"
            + "        round(sum(A.PRODUCTION_BAD)/sum(A.PRODUCTION_VOLUME)*100,2) AS PRODUCTION_DEFECT_RATE, \r\n"
            + "        A.PRODUCTION_EQUIPMENT_CODE ,   \r\n"
            + "        D.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
            + "        A.PRODUCTION_MOLD_INFO_CODE,    \r\n"
            + "        E.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n" + "        A.PRODUCTION_MODIFY_D    \r\n"
            + "FROM PRODUCTION_MGMT_TBL AS A\r\n" + "left outer join \r\n"
            + "     DEFECT_INFO_TBL B ON A.PRODUCTION_DEFECT_CODE = B.DEFECT_CODE\r\n" + "inner join \r\n"
            + "      PRODUCT_INFO_TBL C ON A.PRODUCTION_PRODUCT_CODE = C.PRODUCT_ITEM_CODE \r\n" + "inner join \r\n"
            + "      EQUIPMENT_INFO_TBL D ON A.PRODUCTION_EQUIPMENT_CODE = D.EQUIPMENT_INFO_CODE\r\n"
            + "inner join \r\n" + "      MOLD_INFO_TBL E ON A.PRODUCTION_MOLD_INFO_CODE = E.MOLD_INFO_NO   \r\n"
            + "";

      String where = "";
      where = " where PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '" + obj.get("endDate")+" 08:29:59'";
      //where = " where PRODUCTION_MODIFY_D between '" + obj.get("startDate") + "' and date('" + obj.get("endDate")
        //+ "')+1";
      String  PRODUCTION_EQUIPMENT_CODE = ""; 
      
      if(obj.get("PRODUCT_ITEM_CODE")  == null)
         PRODUCTION_EQUIPMENT_CODE = "";    
      else
         PRODUCTION_EQUIPMENT_CODE =  (String) obj.get("PRODUCTION_EQUIPMENT_CODE");
      
      String  PRODUCTION_EQUIPMENT_INFO_NAME = "";       
      
      if(obj.get("PRODUCTION_EQUIPMENT_INFO_NAME")  == null)
         PRODUCTION_EQUIPMENT_INFO_NAME = "";    
      else
         PRODUCTION_EQUIPMENT_INFO_NAME =  (String) obj.get("PRODUCTION_EQUIPMENT_INFO_NAME");
      
      if (obj.get("PRODUCTION_EQUIPMENT_CODE") != null)
            if(!obj.get("PRODUCTION_EQUIPMENT_CODE").equals("")) {
         
         where += " and PRODUCTION_EQUIPMENT_CODE like '%" + PRODUCTION_EQUIPMENT_CODE + "%'"
               + " and EQUIPMENT_INFO_NAME like '%" + PRODUCTION_EQUIPMENT_INFO_NAME + "%'";
      }
   
      else {   
         where += " and (EQUIPMENT_INFO_NAME like '%" + PRODUCTION_EQUIPMENT_INFO_NAME + "%'"
               + " OR PRODUCTION_EQUIPMENT_CODE like '%" + PRODUCTION_EQUIPMENT_INFO_NAME + "%')";
      }
      
      sql += where;
      sql += " group by  PRODUCTION_SERIAL_NUM WITH ROLLUP";
      //System.out.println(sql);
      PreparedStatement pstmt = conn.prepareStatement(sql);

      ResultSet rs = pstmt.executeQuery();

      int i = 1;

      while (rs.next()) {

            PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
            // data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
            data1.setPRODUCTION_INFO_NUM(String.valueOf(i));
            i++;
            data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
            data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
            data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
            data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty"));
            data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_B_Qty"));
            // data1.setPRODUCTION_DEFECT_RATE("0");
            data1.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
            data1.setPRODUCTION_DEFECT_NAME(rs.getString("PRODUCTION_DEFECT_NAME"));
            if (rs.getString("PRODUCTION_DEFECT_RATE") == null) {
               data1.setPRODUCTION_DEFECT_RATE("");
            } else
               data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%");
            data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
            data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
            data1.setPRODUCTION_MOLD_INFO_CODE(rs.getString("PRODUCTION_MOLD_INFO_CODE"));
            data1.setPRODUCTION_MOLD_INFO_NAME(rs.getString("PRODUCTION_MOLD_INFO_NAME"));
            data1.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D"));
            data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
            list.add(data1);
      }
      if (list.size() > 0) {
         // PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();

         list.get(list.size() - 1).setPRODUCTION_INFO_NUM("");
         list.get(list.size() - 1).setPRODUCTION_SERIAL_NUM("Grand Total");
         list.get(list.size() - 1).setPRODUCTION_PRODUCT_CODE(" ");
         list.get(list.size() - 1).setPRODUCT_ITEM_NAME(" ");
         float pqty = list.get(list.size() - 1).getPRODUCTION_P_Qty();
         float bqty = list.get(list.size() - 1).getPRODUCTION_B_Qty();
         list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_CODE(" ");
         list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_INFO_NAME(" ");
         list.get(list.size() - 1).setPRODUCTION_MOLD_INFO_CODE(" ");
         list.get(list.size() - 1).setPRODUCTION_MOLD_INFO_NAME(" ");
         list.get(list.size() - 1).setPRODUCTION_MODIFY_D(" ");

         float totalrate = bqty/pqty*100;
         list.get(list.size() - 1).setPRODUCTION_DEFECT_RATE(String.format("%.2f", totalrate) + "%");

      }

      pstmt.close();
      conn.close();
      return list;
   }

   // 최종 검사(금형별)
   @RequestMapping(value = "/FinalMold", method = RequestMethod.GET)
   public List<PRODUCTION_INFO_> pviewSearch2(HttpServletRequest request)
         throws ParseException, SQLException, org.json.simple.parser.ParseException {
      String data = request.getParameter("data");
      JSONParser parser = new JSONParser();
      JSONObject obj = (JSONObject) parser.parse(data);

      String sql = "";
      Connection conn = dataSource.getConnection();

      HttpSession session = request.getSession();
      String id = (String) session.getAttribute("id");

      // list 조회 쿼리
      List<PRODUCTION_INFO_> list = new ArrayList<PRODUCTION_INFO_>();

      sql = "SELECT \r\n" + "      A.PRODUCTION_INFO_NUM, \r\n" + "      A.PRODUCTION_SERIAL_NUM , \r\n"
            + "      A.PRODUCTION_PRODUCT_CODE,  \r\n" + "      C.PRODUCT_ITEM_NAME,\r\n"
            + "        sum(A.PRODUCTION_VOLUME) AS PRODUCTION_P_Qty ,\r\n"
            + "        sum(A.PRODUCTION_BAD) AS PRODUCTION_B_Qty, \r\n"
            + "        A.PRODUCTION_DEFECT_CODE,     \r\n" + "        B.DEFECT_NAME PRODUCTION_DEFECT_NAME, \r\n"
            + "        round(sum(A.PRODUCTION_BAD)/sum(A.PRODUCTION_VOLUME)*100,2) AS PRODUCTION_DEFECT_RATE, \r\n"
            + "        A.PRODUCTION_EQUIPMENT_CODE ,   \r\n"
            + "        D.EQUIPMENT_INFO_NAME PRODUCTION_EQUIPMENT_INFO_NAME, \r\n"
            + "        A.PRODUCTION_MOLD_INFO_CODE,    \r\n"
            + "        E.MOLD_INFO_NAME PRODUCTION_MOLD_INFO_NAME, \r\n" + "        A.PRODUCTION_MODIFY_D    \r\n"
            + "FROM PRODUCTION_MGMT_TBL AS A\r\n" + "left outer join \r\n"
            + "     DEFECT_INFO_TBL B ON A.PRODUCTION_DEFECT_CODE = B.DEFECT_CODE\r\n" + "inner join \r\n"
            + "      PRODUCT_INFO_TBL C ON A.PRODUCTION_PRODUCT_CODE = C.PRODUCT_ITEM_CODE \r\n" + "inner join \r\n"
            + "      EQUIPMENT_INFO_TBL D ON A.PRODUCTION_EQUIPMENT_CODE = D.EQUIPMENT_INFO_CODE\r\n"
            + "inner join \r\n" + "      MOLD_INFO_TBL E ON A.PRODUCTION_MOLD_INFO_CODE = E.MOLD_INFO_NO   \r\n"
            + "";

      String where = "";
      where = " where PRODUCTION_MODIFY_D between '" + obj.get("startDate") + " 08:30:00' and '" + obj.get("endDate")+" 08:29:59'";
      
      String  MOLD_INFO_NO = ""; 
      
      if(obj.get("MOLD_INFO_NO")  == null)
         MOLD_INFO_NO = "";    
      else
         MOLD_INFO_NO =  (String) obj.get("MOLD_INFO_NO");
      
      String  MOLD_INFO_NAME = "";       
      
      if(obj.get("MOLD_INFO_NAME")  == null)
         MOLD_INFO_NAME = "";    
      else
         MOLD_INFO_NAME =  (String) obj.get("MOLD_INFO_NAME");
      
      if (obj.get("MOLD_INFO_NO") != null)
            if(!obj.get("MOLD_INFO_NO").equals("")) {
         
         where += " and MOLD_INFO_NO like '%" + MOLD_INFO_NO + "%'"
               + " and MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%'";
      }
   
      else {   
         where += " and (MOLD_INFO_NAME like '%" + MOLD_INFO_NAME + "%'"
               + " OR MOLD_INFO_NO like '%" + MOLD_INFO_NAME + "%')";
      }
      sql += where;
      sql += " group by  PRODUCTION_SERIAL_NUM WITH ROLLUP";

      PreparedStatement pstmt = conn.prepareStatement(sql);

      ResultSet rs = pstmt.executeQuery();

      int i = 1;

      while (rs.next()) {

            PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();
            // data1.setPRODUCTION_INFO_NUM(rs.getString("PRODUCTION_INFO_NUM"));
            data1.setPRODUCTION_INFO_NUM(String.valueOf(i));
            i++;
            data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
            data1.setPRODUCTION_PRODUCT_CODE(rs.getString("PRODUCTION_PRODUCT_CODE"));
            data1.setPRODUCT_ITEM_NAME(rs.getString("PRODUCT_ITEM_NAME"));
            data1.setPRODUCTION_P_Qty(rs.getInt("PRODUCTION_P_Qty"));
            data1.setPRODUCTION_B_Qty(rs.getInt("PRODUCTION_B_Qty"));
            // data1.setPRODUCTION_DEFECT_RATE("0");
            data1.setPRODUCTION_DEFECT_CODE(rs.getString("PRODUCTION_DEFECT_CODE"));
            data1.setPRODUCTION_DEFECT_NAME(rs.getString("PRODUCTION_DEFECT_NAME"));
            if (rs.getString("PRODUCTION_DEFECT_RATE") == null) {
               data1.setPRODUCTION_DEFECT_RATE("");
            } else
               data1.setPRODUCTION_DEFECT_RATE(rs.getString("PRODUCTION_DEFECT_RATE") + "%");
            data1.setPRODUCTION_EQUIPMENT_CODE(rs.getString("PRODUCTION_EQUIPMENT_CODE"));
            data1.setPRODUCTION_EQUIPMENT_INFO_NAME(rs.getString("PRODUCTION_EQUIPMENT_INFO_NAME"));
            data1.setPRODUCTION_MOLD_INFO_CODE(rs.getString("PRODUCTION_MOLD_INFO_CODE"));
            data1.setPRODUCTION_MOLD_INFO_NAME(rs.getString("PRODUCTION_MOLD_INFO_NAME"));
            data1.setPRODUCTION_MODIFY_D(rs.getString("PRODUCTION_MODIFY_D"));
            data1.setPRODUCTION_SERIAL_NUM(rs.getString("PRODUCTION_SERIAL_NUM"));
            list.add(data1);

      }
      if (list.size() > 0) {
         // PRODUCTION_INFO_ data1 = new PRODUCTION_INFO_();

         list.get(list.size() - 1).setPRODUCTION_INFO_NUM("");
         list.get(list.size() - 1).setPRODUCTION_SERIAL_NUM("Grand Total");
         list.get(list.size() - 1).setPRODUCTION_PRODUCT_CODE(" ");
         list.get(list.size() - 1).setPRODUCT_ITEM_NAME(" ");
         float pqty = list.get(list.size() - 1).getPRODUCTION_P_Qty();
         float bqty = list.get(list.size() - 1).getPRODUCTION_B_Qty();
         list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_CODE(" ");
         list.get(list.size() - 1).setPRODUCTION_EQUIPMENT_INFO_NAME(" ");
         list.get(list.size() - 1).setPRODUCTION_MOLD_INFO_CODE(" ");
         list.get(list.size() - 1).setPRODUCTION_MOLD_INFO_NAME(" ");
         list.get(list.size() - 1).setPRODUCTION_MODIFY_D(" ");

         float totalrate = bqty/pqty*100;
         list.get(list.size() - 1).setPRODUCTION_DEFECT_RATE(String.format("%.2f", totalrate) + "%");

      }

      pstmt.close();
      conn.close();
      return list;
   }

}