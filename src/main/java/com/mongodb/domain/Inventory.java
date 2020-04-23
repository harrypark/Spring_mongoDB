package com.mongodb.domain;

import java.util.Date;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

import lombok.Data;

@Data
@Document(collection = "inventory")
public class Inventory {

	@Id
	 private String id;
	 private String item;
	 private Double qty;
	 private Size size;
	 private String status;
	 
	 private String time_milliseconds;
	 //private Date time;
	 private String date_str;
	
	 @DateTimeFormat(iso=ISO.DATE_TIME)
	 private Date birth;
	 
	 
	 
	
	 
	 public Inventory() {}
	public Inventory(String id, String item, Double qty, Size size, String status, String time_milliseconds,
			String date_str) {
		super();
		this.id = id;
		this.item = item;
		this.qty = qty;
		this.size = size;
		this.status = status;
		this.time_milliseconds = time_milliseconds;
		this.date_str = date_str;
	};
	 
	
	
	
	 
	 
}
