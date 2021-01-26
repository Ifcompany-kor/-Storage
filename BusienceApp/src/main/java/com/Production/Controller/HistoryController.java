package com.Production.Controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("HistoryController")
public class HistoryController {

	// ���� �̷� (��ǰ)
	@RequestMapping(value = "product2",method = {RequestMethod.GET})
	public String list(Model model,HttpServletRequest request) throws SQLException
	{
		return "Production/History/product";
	}
	
	// ���� �̷� (����)
	@RequestMapping(value = "equipment2",method = {RequestMethod.GET})
	public String list2(Model model,HttpServletRequest request) throws SQLException
	{
		return "Production/History/equipment";
	}
	
	// ���� �̷� (����)
	@RequestMapping(value = "mold2",method = {RequestMethod.GET})
	public String list3(Model model,HttpServletRequest request) throws SQLException
	{
		return "Production/History/mold";
	}
	
}
