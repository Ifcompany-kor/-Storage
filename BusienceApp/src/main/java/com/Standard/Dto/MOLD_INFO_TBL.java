package com.Standard.Dto;

public class MOLD_INFO_TBL {
	int id;
	String	BUSINESS_PLACE_CODE;
	String	BUSINESS_PLACE;
	String    MOLD_INFO_NO;
	String    MOLD_INFO_NAME;
	String    MOLD_INFO_RANK_CODE;
	String    MOLD_INFO_RANK;
	String    MOLD_INFO_STND;
	String    MOLD_ITEM_CODE;
	String    MOLD_ITEM_NAME;
	String    MANUFACTURER;
	String    BUSINESS_PERSON;
	String    MOLD_RECEIVED_D;
	String    USER_MODIFIER;
	String    USER_MODIFY_D;
	String    MOLD_USE_STATUS;
	String	  MOLD_CUBIT;
	public MOLD_INFO_TBL(int id, String bUSINESS_PLACE_CODE, String bUSINESS_PLACE, String mOLD_INFO_NO,
			String mOLD_INFO_NAME, String mOLD_INFO_RANK_CODE, String mOLD_INFO_RANK, String mOLD_INFO_STND,
			String mOLD_ITEM_CODE, String mOLD_ITEM_NAME, String mANUFACTURER, String bUSINESS_PERSON,
			String mOLD_RECEIVED_D, String uSER_MODIFIER, String uSER_MODIFY_D, String mOLD_USE_STATUS) {
		super();
		this.id = id;
		BUSINESS_PLACE_CODE = bUSINESS_PLACE_CODE;
		BUSINESS_PLACE = bUSINESS_PLACE;
		MOLD_INFO_NO = mOLD_INFO_NO;
		MOLD_INFO_NAME = mOLD_INFO_NAME;
		MOLD_INFO_RANK_CODE = mOLD_INFO_RANK_CODE;
		MOLD_INFO_RANK = mOLD_INFO_RANK;
		MOLD_INFO_STND = mOLD_INFO_STND;
		MOLD_ITEM_CODE = mOLD_ITEM_CODE;
		MOLD_ITEM_NAME = mOLD_ITEM_NAME;
		MANUFACTURER = mANUFACTURER;
		BUSINESS_PERSON = bUSINESS_PERSON;
		MOLD_RECEIVED_D = mOLD_RECEIVED_D;
		USER_MODIFIER = uSER_MODIFIER;
		USER_MODIFY_D = uSER_MODIFY_D;
		MOLD_USE_STATUS = mOLD_USE_STATUS;
	}
	public MOLD_INFO_TBL() {
		super();
	}
	@Override
	public String toString() {
		return "MOLD_INFO_TBL [id=" + id + ", BUSINESS_PLACE_CODE=" + BUSINESS_PLACE_CODE + ", BUSINESS_PLACE="
				+ BUSINESS_PLACE + ", MOLD_INFO_NO=" + MOLD_INFO_NO + ", MOLD_INFO_NAME=" + MOLD_INFO_NAME
				+ ", MOLD_INFO_RANK_CODE=" + MOLD_INFO_RANK_CODE + ", MOLD_INFO_RANK=" + MOLD_INFO_RANK
				+ ", MOLD_INFO_STND=" + MOLD_INFO_STND + ", MOLD_ITEM_CODE=" + MOLD_ITEM_CODE + ", MOLD_ITEM_NAME="
				+ MOLD_ITEM_NAME + ", MANUFACTURER=" + MANUFACTURER + ", BUSINESS_PERSON=" + BUSINESS_PERSON
				+ ", MOLD_RECEIVED_D=" + MOLD_RECEIVED_D + ", USER_MODIFIER=" + USER_MODIFIER + ", USER_MODIFY_D="
				+ USER_MODIFY_D + ", MOLD_USE_STATUS=" + MOLD_USE_STATUS + "]";
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getBUSINESS_PLACE_CODE() {
		return BUSINESS_PLACE_CODE;
	}
	public void setBUSINESS_PLACE_CODE(String bUSINESS_PLACE_CODE) {
		BUSINESS_PLACE_CODE = bUSINESS_PLACE_CODE;
	}
	public String getBUSINESS_PLACE() {
		return BUSINESS_PLACE;
	}
	public void setBUSINESS_PLACE(String bUSINESS_PLACE) {
		BUSINESS_PLACE = bUSINESS_PLACE;
	}
	public String getMOLD_INFO_NO() {
		return MOLD_INFO_NO;
	}
	public void setMOLD_INFO_NO(String mOLD_INFO_NO) {
		MOLD_INFO_NO = mOLD_INFO_NO;
	}
	public String getMOLD_INFO_NAME() {
		return MOLD_INFO_NAME;
	}
	public void setMOLD_INFO_NAME(String mOLD_INFO_NAME) {
		MOLD_INFO_NAME = mOLD_INFO_NAME;
	}
	public String getMOLD_INFO_RANK_CODE() {
		return MOLD_INFO_RANK_CODE;
	}
	public void setMOLD_INFO_RANK_CODE(String mOLD_INFO_RANK_CODE) {
		MOLD_INFO_RANK_CODE = mOLD_INFO_RANK_CODE;
	}
	public String getMOLD_INFO_RANK() {
		return MOLD_INFO_RANK;
	}
	public void setMOLD_INFO_RANK(String mOLD_INFO_RANK) {
		MOLD_INFO_RANK = mOLD_INFO_RANK;
	}
	public String getMOLD_INFO_STND() {
		return MOLD_INFO_STND;
	}
	public void setMOLD_INFO_STND(String mOLD_INFO_STND) {
		MOLD_INFO_STND = mOLD_INFO_STND;
	}
	public String getMOLD_ITEM_CODE() {
		return MOLD_ITEM_CODE;
	}
	public void setMOLD_ITEM_CODE(String mOLD_ITEM_CODE) {
		MOLD_ITEM_CODE = mOLD_ITEM_CODE;
	}
	public String getMOLD_ITEM_NAME() {
		return MOLD_ITEM_NAME;
	}
	public void setMOLD_ITEM_NAME(String mOLD_ITEM_NAME) {
		MOLD_ITEM_NAME = mOLD_ITEM_NAME;
	}
	public String getMANUFACTURER() {
		return MANUFACTURER;
	}
	public void setMANUFACTURER(String mANUFACTURER) {
		MANUFACTURER = mANUFACTURER;
	}
	public String getBUSINESS_PERSON() {
		return BUSINESS_PERSON;
	}
	public void setBUSINESS_PERSON(String bUSINESS_PERSON) {
		BUSINESS_PERSON = bUSINESS_PERSON;
	}
	public String getMOLD_RECEIVED_D() {
		return MOLD_RECEIVED_D;
	}
	public void setMOLD_RECEIVED_D(String mOLD_RECEIVED_D) {
		MOLD_RECEIVED_D = mOLD_RECEIVED_D;
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
	public String getMOLD_USE_STATUS() {
		return MOLD_USE_STATUS;
	}
	public void setMOLD_USE_STATUS(String mOLD_USE_STATUS) {
		MOLD_USE_STATUS = mOLD_USE_STATUS;
	}
	public String getMOLD_CUBIT() {
		return MOLD_CUBIT;
	}
	public void setMOLD_CUBIT(String mOLD_CUBIT) {
		MOLD_CUBIT = mOLD_CUBIT;
	}
	
}