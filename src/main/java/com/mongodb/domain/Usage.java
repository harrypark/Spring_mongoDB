package com.mongodb.domain;

import lombok.Data;

@Data
public class Usage {
	
	private String dateDay;
	private Integer usage;
	private Integer apiCall;

}
