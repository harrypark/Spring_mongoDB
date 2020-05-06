package com.mongodb.domain;

public enum ResponseTypeCode {
	TEXT(0),BUTTON(1), LINK(2), CARD(3), TABLE(4), SELECT(5), IMAGE(6), VIDEO(7), DOWNLOAD(8), PHONE(9);

	private final int value;

	ResponseTypeCode(int value) {
		this.value = value;
	}

	public int getValue() {
		return value;
	}

	public static ResponseTypeCode valueOf(int value) {
		switch (value) {
		case 0:
			return TEXT;
		case 1:
			return BUTTON;
		case 2:
			return LINK;
		case 3:
			return CARD;
		case 4:
			return TABLE;
		case 5:
			return SELECT;
		case 6:
			return IMAGE;
		case 7:
			return VIDEO;
		case 8:
			return DOWNLOAD;
		case 9:
			return PHONE;
		default:
			throw new AssertionError("Unknown VerificationResult : " + value);
		}
	}
}
