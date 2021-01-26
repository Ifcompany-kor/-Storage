package com.Standard.Dto;

public class DTL_TBL {
	String NEW_TBL_CODE,CHILD_TBL_NUM,CHILD_TBL_TYPE,CHILD_TBL_RMARK,CHILD_TBL_USE_STATUS;
	String URL,PARENT;
	
	@Override
	public String toString() {
		return "DTL_TBL [NEW_TBL_CODE=" + NEW_TBL_CODE + ", CHILD_TBL_NUM=" + CHILD_TBL_NUM + ", CHILD_TBL_TYPE="
				+ CHILD_TBL_TYPE + ", CHILD_TBL_RMARK=" + CHILD_TBL_RMARK + ", CHILD_TBL_USE_STATUS="
				+ CHILD_TBL_USE_STATUS + ", URL=" + URL + ", PARENT=" + PARENT + "]";
	}

	public DTL_TBL(String nEW_TBL_CODE, String cHILD_TBL_NUM, String cHILD_TBL_TYPE, String cHILD_TBL_RMARK,
			String cHILD_TBL_USE_STATUS, String uRL, String pARENT) {
		super();
		NEW_TBL_CODE = nEW_TBL_CODE;
		CHILD_TBL_NUM = cHILD_TBL_NUM;
		CHILD_TBL_TYPE = cHILD_TBL_TYPE;
		CHILD_TBL_RMARK = cHILD_TBL_RMARK;
		CHILD_TBL_USE_STATUS = cHILD_TBL_USE_STATUS;
		URL = uRL;
		PARENT = pARENT;
	}

	public DTL_TBL() {
		super();
	}
	
	public String getNEW_TBL_CODE() {
		return NEW_TBL_CODE;
	}

	public void setNEW_TBL_CODE(String nEW_TBL_CODE) {
		NEW_TBL_CODE = nEW_TBL_CODE;
	}

	public String getCHILD_TBL_NUM() {
		return CHILD_TBL_NUM;
	}

	public void setCHILD_TBL_NUM(String cHILD_TBL_NUM) {
		CHILD_TBL_NUM = cHILD_TBL_NUM;
	}

	public String getCHILD_TBL_TYPE() {
		return CHILD_TBL_TYPE;
	}

	public void setCHILD_TBL_TYPE(String cHILD_TBL_TYPE) {
		CHILD_TBL_TYPE = cHILD_TBL_TYPE;
	}

	public String getCHILD_TBL_RMARK() {
		return CHILD_TBL_RMARK;
	}

	public void setCHILD_TBL_RMARK(String cHILD_TBL_RMARK) {
		CHILD_TBL_RMARK = cHILD_TBL_RMARK;
	}

	public String getCHILD_TBL_USE_STATUS() {
		return CHILD_TBL_USE_STATUS;
	}

	public void setCHILD_TBL_USE_STATUS(String cHILD_TBL_USE_STATUS) {
		CHILD_TBL_USE_STATUS = cHILD_TBL_USE_STATUS;
	}

	public String getURL() {
		return URL;
	}

	public void setURL(String uRL) {
		URL = uRL;
	}

	public String getPARENT() {
		return PARENT;
	}

	public void setPARENT(String pARENT) {
		PARENT = pARENT;
	}
	
}

