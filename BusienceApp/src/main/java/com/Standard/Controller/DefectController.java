package com.Standard.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("DefectController")
@RequestMapping("defect")
public class DefectController {

	@RequestMapping(value = "", method = RequestMethod.GET)
	public String defect()
	{
		return "Standard/defect";
	}
	
}
