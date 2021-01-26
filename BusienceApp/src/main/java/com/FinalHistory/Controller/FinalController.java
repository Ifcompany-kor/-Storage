package com.FinalHistory.Controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("FinalController")
public class FinalController {

	@Autowired
	SimpleDriverDataSource dataSource;

	// 최종 검사(제품)페이지
	@RequestMapping(value = "ftproduct", method = { RequestMethod.GET })
	public String finalList(Model model, HttpServletRequest request) throws SQLException {
		return "Quality/Final/product";
	}

	// 최종 검사(설비)페이지
	@RequestMapping(value = "ftequipment", method = { RequestMethod.GET })
	public String finalList1(Model model, HttpServletRequest request) throws SQLException {
		return "Quality/Final/equipment";
	}

	// 최종 검사(금형)페이지
	@RequestMapping(value = "ftmold", method = { RequestMethod.GET })
	public String finalList2(Model model, HttpServletRequest request) throws SQLException {
		return "Quality/Final/mold";
	}
}
