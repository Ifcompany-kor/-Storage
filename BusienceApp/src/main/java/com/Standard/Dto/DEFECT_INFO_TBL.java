package com.Standard.Dto;

public class DEFECT_INFO_TBL {
	int id;
	String DEFECT_CODE,DEFECT_NAME,DEFECT_ABR,DEFECT_RMRKS,DEFECT_MODIFIER,DEFECT_USE_STATUS,DEFECT_MODIFY_D;
	public DEFECT_INFO_TBL(int id, String dEFECT_CODE, String dEFECT_NAME, String dEFECT_ABR, String dEFECT_RMRKS,
			String dEFECT_MODIFIER, String dEFECT_USE_STATUS, String dEFECT_MODIFY_D) {
		super();
		this.id = id;
		DEFECT_CODE = dEFECT_CODE;
		DEFECT_NAME = dEFECT_NAME;
		DEFECT_ABR = dEFECT_ABR;
		DEFECT_RMRKS = dEFECT_RMRKS;
		DEFECT_MODIFIER = dEFECT_MODIFIER;
		DEFECT_USE_STATUS = dEFECT_USE_STATUS;
		DEFECT_MODIFY_D = dEFECT_MODIFY_D;
	}
	public DEFECT_INFO_TBL() {
		super();
	}
	@Override
	public String toString() {
		return "DEFECT_INFO_TBL [id=" + id + ", DEFECT_CODE=" + DEFECT_CODE + ", DEFECT_NAME=" + DEFECT_NAME
				+ ", DEFECT_ABR=" + DEFECT_ABR + ", DEFECT_RMRKS=" + DEFECT_RMRKS + ", DEFECT_MODIFIER="
				+ DEFECT_MODIFIER + ", DEFECT_USE_STATUS=" + DEFECT_USE_STATUS + ", DEFECT_MODIFY_D=" + DEFECT_MODIFY_D
				+ "]";
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getDEFECT_CODE() {
		return DEFECT_CODE;
	}
	public void setDEFECT_CODE(String dEFECT_CODE) {
		DEFECT_CODE = dEFECT_CODE;
	}
	public String getDEFECT_NAME() {
		return DEFECT_NAME;
	}
	public void setDEFECT_NAME(String dEFECT_NAME) {
		DEFECT_NAME = dEFECT_NAME;
	}
	public String getDEFECT_ABR() {
		return DEFECT_ABR;
	}
	public void setDEFECT_ABR(String dEFECT_ABR) {
		DEFECT_ABR = dEFECT_ABR;
	}
	public String getDEFECT_RMRKS() {
		return DEFECT_RMRKS;
	}
	public void setDEFECT_RMRKS(String dEFECT_RMRKS) {
		DEFECT_RMRKS = dEFECT_RMRKS;
	}
	public String getDEFECT_MODIFIER() {
		return DEFECT_MODIFIER;
	}
	public void setDEFECT_MODIFIER(String dEFECT_MODIFIER) {
		DEFECT_MODIFIER = dEFECT_MODIFIER;
	}
	public String getDEFECT_USE_STATUS() {
		return DEFECT_USE_STATUS;
	}
	public void setDEFECT_USE_STATUS(String dEFECT_USE_STATUS) {
		DEFECT_USE_STATUS = dEFECT_USE_STATUS;
	}
	public String getDEFECT_MODIFY_D() {
		return DEFECT_MODIFY_D;
	}
	public void setDEFECT_MODIFY_D(String dEFECT_MODIFY_D) {
		DEFECT_MODIFY_D = dEFECT_MODIFY_D;
	}
}