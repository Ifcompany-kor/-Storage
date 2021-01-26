package com.Production.Controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("PerformanceController")
public class PerformanceController {

	// 생산 실적 (제품) 페이지
	@RequestMapping(value = "product1", method = { RequestMethod.GET })
	public String list4(Model model, HttpServletRequest request) throws SQLException {
		
		return "Production/Performance/product";
	}

	// 생산 실적 (설비) 페이지
	@RequestMapping(value = "equipment1", method = { RequestMethod.GET })
	public String list5(Model model, HttpServletRequest request) throws SQLException {
		return "Production/Performance/equipment";
	}

	// 생산 실적 (금형) 페이지
	@RequestMapping(value = "mold1", method = { RequestMethod.GET })
	public String list6(Model model, HttpServletRequest request) throws SQLException {
		return "Production/Performance/mold";
	}
	
	// 생산 실적 (월별) 페이지
	@RequestMapping(value = "month", method = { RequestMethod.GET })
	public String month(Model model, HttpServletRequest request) throws SQLException {
		return "Production/Performance/month";
	}
	
	// 생산 실적 (연별) 페이지
	@RequestMapping(value = "years", method = { RequestMethod.GET })
		public String years(Model model, HttpServletRequest request) throws SQLException {
			return "Production/Performance/years";
	}

}
