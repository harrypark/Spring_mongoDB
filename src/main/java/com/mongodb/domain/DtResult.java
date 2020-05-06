package com.mongodb.domain;

import java.util.List;

import lombok.Data;

@Data
public class DtResult {
	
	
	
	private Integer draw;
	private Integer recordsTotal;
	private Integer recordsFiltered;
	private List<Conversation> data;
	private String error;
	
	
}
