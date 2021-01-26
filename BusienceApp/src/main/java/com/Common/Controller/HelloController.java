package com.Common.Controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("HelloController")
public class HelloController {

	@RequestMapping(value = "/bsapp", method = {RequestMethod.GET,RequestMethod.POST})
	public String bsapp(HttpServletRequest request) throws ClassNotFoundException, SQLException
	{
		return "bsapp";
	}
	
}