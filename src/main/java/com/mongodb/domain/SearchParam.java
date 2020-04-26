package com.mongodb.domain;

import java.util.List;

import lombok.Data;

@Data
public class SearchParam {

	private String startDt;
	private String endDt;
	private String skillUuid;
	private String schDate;
	private String categoryType;//daily, hourly
	
	private List<String> days;
	private List<String> categories;
	private List<String> names;
	
}
