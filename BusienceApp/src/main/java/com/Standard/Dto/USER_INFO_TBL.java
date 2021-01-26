package com.Standard.Dto;

public class USER_INFO_TBL {
	String USER_CODE,USER_PASSWORD,USER_NAME
	,USER_TYPE,USER_TYPE_NAME,COMPANY,COMPANY_NAME
	,DEPT_CODE,DEPT_NAME,USER_MODIFIER,USER_MODIFY_D,USER_USE_STATUS;

	public String getUSER_CODE() {
		return USER_CODE;
	}

	public void setUSER_CODE(String uSER_CODE) {
		USER_CODE = uSER_CODE;
	}

	public String getUSER_PASSWORD() {
		return USER_PASSWORD;
	}

	public void setUSER_PASSWORD(String uSER_PASSWORD) {
		USER_PASSWORD = uSER_PASSWORD;
	}

	public String getUSER_NAME() {
		return USER_NAME;
	}

	public void setUSER_NAME(String uSER_NAME) {
		USER_NAME = uSER_NAME;
	}

	public String getUSER_TYPE() {
		return USER_TYPE;
	}

	public void setUSER_TYPE(String uSER_TYPE) {
		USER_TYPE = uSER_TYPE;
	}

	public String getUSER_TYPE_NAME() {
		return USER_TYPE_NAME;
	}

	public void setUSER_TYPE_NAME(String uSER_TYPE_NAME) {
		USER_TYPE_NAME = uSER_TYPE_NAME;
	}

	public String getCOMPANY() {
		return COMPANY;
	}

	public void setCOMPANY(String cOMPANY) {
		COMPANY = cOMPANY;
	}

	public String getCOMPANY_NAME() {
		return COMPANY_NAME;
	}

	public void setCOMPANY_NAME(String cOMPANY_NAME) {
		COMPANY_NAME = cOMPANY_NAME;
	}

	public String getDEPT_CODE() {
		return DEPT_CODE;
	}

	public void setDEPT_CODE(String dEPT_CODE) {
		DEPT_CODE = dEPT_CODE;
	}

	public String getDEPT_NAME() {
		return DEPT_NAME;
	}

	public void setDEPT_NAME(String dEPT_NAME) {
		DEPT_NAME = dEPT_NAME;
	}

	public String getUSER_MODIFIER() {
		return USER_MODIFIER;
	}

	public void setUSER_MODIFIER(String uSER_MODIFIER) {
		USER_MODIFIER = uSER_MODIFIER;
	}

	public String getUSER_MODIFY_D() {
		return USER_MODIFY_D;
	}

	public void setUSER_MODIFY_D(String uSER_MODIFY_D) {
		USER_MODIFY_D = uSER_MODIFY_D;
	}

	public String getUSER_USE_STATUS() {
		return USER_USE_STATUS;
	}

	public void setUSER_USE_STATUS(String uSER_USE_STATUS) {
		USER_USE_STATUS = uSER_USE_STATUS;
	}

	@Override
	public String toString() {
		return "USER_INFO_TBL [USER_CODE=" + USER_CODE + ", USER_PASSWORD=" + USER_PASSWORD + ", USER_NAME=" + USER_NAME
				+ ", USER_TYPE=" + USER_TYPE + ", USER_TYPE_NAME=" + USER_TYPE_NAME + ", COMPANY=" + COMPANY
				+ ", COMPANY_NAME=" + COMPANY_NAME + ", DEPT_CODE=" + DEPT_CODE + ", DEPT_NAME=" + DEPT_NAME
				+ ", USER_MODIFIER=" + USER_MODIFIER + ", USER_MODIFY_D=" + USER_MODIFY_D + ", USER_USE_STATUS="
				+ USER_USE_STATUS + "]";
	}

	public USER_INFO_TBL() {
		super();
	}

	public USER_INFO_TBL(String uSER_CODE, String uSER_PASSWORD, String uSER_NAME, String uSER_TYPE,
			String uSER_TYPE_NAME, String cOMPANY, String cOMPANY_NAME, String dEPT_CODE, String dEPT_NAME,
			String uSER_MODIFIER, String uSER_MODIFY_D, String uSER_USE_STATUS) {
		super();
		USER_CODE = uSER_CODE;
		USER_PASSWORD = uSER_PASSWORD;
		USER_NAME = uSER_NAME;
		USER_TYPE = uSER_TYPE;
		USER_TYPE_NAME = uSER_TYPE_NAME;
		COMPANY = cOMPANY;
		COMPANY_NAME = cOMPANY_NAME;
		DEPT_CODE = dEPT_CODE;
		DEPT_NAME = dEPT_NAME;
		USER_MODIFIER = uSER_MODIFIER;
		USER_MODIFY_D = uSER_MODIFY_D;
		USER_USE_STATUS = uSER_USE_STATUS;
	}

	
}
