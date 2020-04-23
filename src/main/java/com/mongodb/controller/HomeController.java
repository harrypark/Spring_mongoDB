package com.mongodb.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mongodb.dao.InventoryDAO;
import com.mongodb.service.HomeService;

@Controller
public class HomeController {

	
	@Autowired
	private InventoryDAO inventoryDAO;
	
	@Autowired
	private HomeService homeService;
	
	
	@RequestMapping("/index")
	public String findAll() {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		/*
		System.out.println("test1 ==============================================================");
		List<Inventory> list = inventoryDAO.findAll();
		for(Inventory i : list) {
			System.out.println(i.toString());
			System.out.println(format.format(i.getBirth()));
		}
		System.out.println("test2 ==============================================================");
		Inventory in = inventoryDAO.findByItem("notebook");
		System.out.println(in.toString());
		
		System.out.println("test3 ==============================================================");
		
		List<Item> list2 = inventoryDAO.getItems(50);
		
		*/
		return "/test";
	}
	
	
	@RequestMapping("/intent/top10")
	public String entity() {
		
		return "intent/top10";
	}
}
