package com.mongodb.domain;

import java.util.List;

import lombok.Data;
import lombok.ToString;

@Data
@ToString(callSuper = true)
public class SearchParam extends DtSearchParam{

	private String schStartDt;
	private String schEndDt;
	private String schSkillUuid;
	private String schDate;
	private String schCategoryType;//daily, hourly
	private String schConfidence;
	private String schInputType;
	private String schIntent;
	private String schUser;
	
	
	private List<String> schDays;
	private List<String> schCategories;
	private List<String> schNames;
	
}
