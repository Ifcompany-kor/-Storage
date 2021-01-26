package com.System.Controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("CodeController")
@RequestMapping("code")
public class CodeController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "",method = {RequestMethod.GET})
	public String list(Model model,HttpServletRequest request) throws SQLException
	{
		return "System/Code";
	}
	
}
