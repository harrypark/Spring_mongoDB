package com.mongodb.domain;

import lombok.Data;

@Data
public class Intent {

	private String dateDay;
	private String skillUuid;
	private String intent;
	private double confidenceAvg;
	private double confidenceSum;
	private Integer intentCount;
	private Integer example;
	
	public Intent() {};
	
	public Intent(String skillUuid, double confidenceAvg, double confidenceSum, Integer intentCount) {
		this.skillUuid = skillUuid;
		this.confidenceAvg = confidenceAvg;
		this.confidenceSum = confidenceSum;
		this.intentCount = intentCount;
	}
	
	
	
	
	
}
