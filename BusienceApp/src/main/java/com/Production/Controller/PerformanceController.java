package com.Production.Controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("PerformanceController")
public class PerformanceController {

	// ���� ���� (��ǰ) ������
	@RequestMapping(value = "product1", method = { RequestMethod.GET })
	public String list4(Model model, HttpServletRequest request) throws SQLException {
		
		return "Production/Performance/product";
	}

	// ���� ���� (����) ������
	@RequestMapping(value = "equipment1", method = { RequestMethod.GET })
	public String list5(Model model, HttpServletRequest request) throws SQLException {
		return "Production/Performance/equipment";
	}

	// ���� ���� (����) ������
	@RequestMapping(value = "mold1", method = { RequestMethod.GET })
	public String list6(Model model, HttpServletRequest request) throws SQLException {
		return "Production/Performance/mold";
	}
	
	// ���� ���� (����) ������
	@RequestMapping(value = "month", method = { RequestMethod.GET })
	public String month(Model model, HttpServletRequest request) throws SQLException {
		return "Production/Performance/month";
	}
	
	// ���� ���� (����) ������
	@RequestMapping(value = "years", method = { RequestMethod.GET })
		public String years(Model model, HttpServletRequest request) throws SQLException {
			return "Production/Performance/years";
	}

}
