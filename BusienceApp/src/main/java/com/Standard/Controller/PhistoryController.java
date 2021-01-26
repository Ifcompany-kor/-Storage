package com.Standard.Controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("PhistoryController")
public class PhistoryController {

	// 생산 실적 페이지
	@RequestMapping(value = "phistory", method = { RequestMethod.GET })
	public String list7(Model model, HttpServletRequest request) throws SQLException {

		return "Standard/phistory";
	}
}
