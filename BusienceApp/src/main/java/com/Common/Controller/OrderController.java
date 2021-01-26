package com.Common.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("OrderController")
public class OrderController {

	@Autowired
	SimpleDriverDataSource dataSource;
	
	@RequestMapping(value = "/orderfrm", method = RequestMethod.GET)
	public String orderfrm() {
		return "Order/orderfrm";
	}
	
	@RequestMapping(value = "/order", method = RequestMethod.GET)
	public String order() {
		return "Order/order";
	}
	
}
