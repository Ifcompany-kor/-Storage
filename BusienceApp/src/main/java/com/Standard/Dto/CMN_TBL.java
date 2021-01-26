package com.Standard.Dto;

public class CMN_TBL {
	String NEW_TBL_CODE,NEW_TBL_NAME,NEW_TBL_INDEX;

	public CMN_TBL(String nEW_TBL_CODE, String nEW_TBL_NAME, String nEW_TBL_INDEX) {
		super();
		NEW_TBL_CODE = nEW_TBL_CODE;
		NEW_TBL_NAME = nEW_TBL_NAME;
		NEW_TBL_INDEX = nEW_TBL_INDEX;
	}

	public CMN_TBL() {
		super();
	}

	@Override
	public String toString() {
		return "CMN_TBL [NEW_TBL_CODE=" + NEW_TBL_CODE + ", NEW_TBL_NAME=" + NEW_TBL_NAME + ", NEW_TBL_INDEX="
				+ NEW_TBL_INDEX + "]";
	}

	public String getNEW_TBL_CODE() {
		return NEW_TBL_CODE;
	}

	public void setNEW_TBL_CODE(String nEW_TBL_CODE) {
		NEW_TBL_CODE = nEW_TBL_CODE;
	}

	public String getNEW_TBL_NAME() {
		return NEW_TBL_NAME;
	}

	public void setNEW_TBL_NAME(String nEW_TBL_NAME) {
		NEW_TBL_NAME = nEW_TBL_NAME;
	}

	public String getNEW_TBL_INDEX() {
		return NEW_TBL_INDEX;
	}

	public void setNEW_TBL_INDEX(String nEW_TBL_INDEX) {
		NEW_TBL_INDEX = nEW_TBL_INDEX;
	}
}
