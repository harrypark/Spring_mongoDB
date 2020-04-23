package com.mongodb.domain;

import lombok.Data;

@Data
public class Entity {
	
	private String skillUuid;
	private String entity;
	private String value;
	private double confidenceAvg;
	private double confidenceSum;
	private Integer entityCount;

}
