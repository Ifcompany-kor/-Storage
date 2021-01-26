package com.InspectHistory.Controller;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("InspectionController")
public class InspectionController {

	private ResultSet rs, rs2;

	@Autowired
	SimpleDriverDataSource dataSource;

	// 생산 품질(제품) 페이지
	@RequestMapping(value = "/thproduct", method = { RequestMethod.GET })
	public String list(Model model, HttpServletRequest request) throws SQLException {

		return "Quality/Inspect/product";
	}

	// 생산 품질(설비) 페이지
	@RequestMapping(value = "/thequipment", method = { RequestMethod.GET })
	public String list4(Model model, HttpServletRequest request) throws SQLException {

		return "Quality/Inspect/equipment";
	}

	// 생산 품질(금형) 페이지
	@RequestMapping(value = "/thmold", method = { RequestMethod.GET })
	public String list5(Model model, HttpServletRequest request) throws SQLException {

		return "Quality/Inspect/mold";
	}

}