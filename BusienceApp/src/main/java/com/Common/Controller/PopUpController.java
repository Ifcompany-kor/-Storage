package com.Common.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class PopUpController {

	@RequestMapping(value = "/defect_popup", method = { RequestMethod.GET })
	public String defect_popup() {
		return "PopUp/defect_popup";
	}

	@RequestMapping(value = "/product_popup", method = { RequestMethod.GET })
	public String product_popup() {
		return "PopUp/product_popup";
	}

	@RequestMapping(value = "/mold_popup", method = { RequestMethod.GET })
	public String Mold_ItemCode(Model model) {
		return "PopUp/mold_popup";
	}

	@RequestMapping(value = "/equipment_popup", method = { RequestMethod.GET })
	public String Equipment_ItemCode2(Model model) {
		return "PopUp/equipment_popup";
	}
	// 금형별 이력 팝업
	@RequestMapping(value = "/mold_ItemCode", method = { RequestMethod.GET })
	public String Mold_ItemCode2(Model model) {
		return "PopUp/youjin/Mold_ItemCode";
	}

	// 장비별 이력 팝업
	@RequestMapping(value = "/Equipment_ItemCode", method = { RequestMethod.GET })
	public String Equipment_ItemCode(Model model) {
		return "PopUp/youjin/Equipment_ItemCode";
	}

	// 금형별 실적 팝업
	@RequestMapping(value = "/MoldPerformance_ItemCode", method = { RequestMethod.GET })
	public String MoldPerformance_ItemCode(Model model) {
		return "PopUp/youjin/MoldPerformance_ItemCode";
	}

	// 품질 제품별(품목코드) 팝업
	@RequestMapping(value = "/ProductQuality_ItemCode", method = { RequestMethod.GET })
	public String ProductQuailty_ItemCode(Model model) {
		return "PopUp/youjin/ProductQuality_ItemCode";
	}

	// 품질 (불량코드) 팝업
	@RequestMapping(value = "/DefectQuality_ItemCode", method = { RequestMethod.GET })
	public String ProductDQuailty_ItemCode(Model model) {
		return "PopUp/youjin/DefectQuality_ItemCode";
	}

	// 품질 제품별(설비코드) 팝업
	@RequestMapping(value = "/EquipmentQuality_ItemCode", method = { RequestMethod.GET })
	public String EquipmentQuailty_ItemCode(Model model) {
		return "PopUp/youjin/EquipmentQuality_ItemCode";
	}

	// 품질 제품별(금형No) 팝업
	@RequestMapping(value = "/MoldQuality_ItemCode", method = { RequestMethod.GET })
	public String MoldQuality_ItemCode(Model model) {
		return "PopUp/youjin/MoldQuality_ItemCode";
	}

	// 금형별 이력 팝업
	@RequestMapping(value = "/Mold_ItemCode_je", method = { RequestMethod.GET })
	public String Mold_ItemCode_je(Model model) {
		return "PopUp/je/Mold_ItemCode";
	}

	// 장비별 이력 팝업
	@RequestMapping(value = "/Equipment_ItemCode_je", method = { RequestMethod.GET })
	public String Equipment_ItemCode_je(Model model) {
		return "PopUp/je/Equipment_ItemCode";
	}

	// 제품별 이력 팝업
	@RequestMapping(value = "/Product_ItemCode_je", method = { RequestMethod.GET })
	public String MoldPerformance_ItemCode_je(Model model) {
		return "PopUp/je/Product_ItemCode";
	}
}
