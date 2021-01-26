package com.Control.Controller;

import java.net.UnknownHostException;
import java.sql.SQLException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.Common.Controller.HomeController;

@Controller("DefectStateController")
@RequestMapping("defectstate")
public class DefectStateController {

	@RequestMapping(value = "",method = {RequestMethod.GET})
	public String list(Model model) throws UnknownHostException, ClassNotFoundException, SQLException
	{
		return "Control/DefectState";
	}
	
}
