package com.mongodb.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mongodb.domain.ResponseTypeCode;

@Controller
public class HomeController {

	
	
	
	@RequestMapping("/index")
	public String findAll() {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		return "index";
	}
	
	
	@RequestMapping("/intent/top10")
	public String intentTop10() {
		
		return "intent/top10";
	}
	
	@RequestMapping("/intent/daily")
	public String intentDaily() {
		
		return "intent/daily";
	}
	
	@RequestMapping("/dashboard")
	public String dashboard() {
		
		return "dashboard";
	}
	
	
	@RequestMapping("/conversation")
	public String conversation() {
		
		return "conversation";
	}
	
	@RequestMapping("/confidence")
	public String confidence() {
		
		return "confidence";
	}
	
	@RequestMapping("/conversation/serverSide")
	public String conversationServerSide(Model model) {
		
		//List<ResponseTypeCode> tutorTypes = tutorTypes = new ArrayList<ResponseTypeCode (Arrays.asList(ResponseTypeCode.values()));
	    model.addAttribute("inputType", ResponseTypeCode.values());
		
		return "conversation_server_side";
	}
	
	
}
