package com.mongodb.domain;

import lombok.Data;

@Data
public class Conversation {

	private String id;
	private String date;
	private String dateDay;
	private String inputType;
	private String inputText;
	private String intent;
	private double intentConfidence;
	private String user;
}
