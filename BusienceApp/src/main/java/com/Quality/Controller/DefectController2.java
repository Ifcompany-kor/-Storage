package com.Quality.Controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("DefectController2")
@RequestMapping("defect2")
public class DefectController2 {

	@RequestMapping(value = "",method = {RequestMethod.GET})
	public String defect2(Model model,HttpServletRequest request) throws SQLException
	{
		return "Quality/defect2";
	}
	
}
