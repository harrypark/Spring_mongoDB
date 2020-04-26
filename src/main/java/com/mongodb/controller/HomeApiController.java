package com.mongodb.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mongodb.domain.Entity;
import com.mongodb.domain.Intent;
import com.mongodb.domain.SearchParam;
import com.mongodb.service.HomeService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api")
public class HomeApiController {
	@Autowired
	private HomeService homeService;
	
	@GetMapping(value = "/intent/top10")
	public List<Intent> getIntentTop10(SearchParam param) {
		return  homeService.getIntentTop10(param);
	}
	
	@GetMapping(value = "/entity/top10")
	public List<Entity> getEntityTop10(SearchParam param) {
		return homeService.getEntityTop10(param);
	}
	
	@GetMapping(value = "/intent/confidenceAvg")
	public HashMap<String,Double> getIntentConfidenceAvg(SearchParam param) {
		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMdd");
		DateTime endDt = new DateTime();//today
		param.setEndDt(formatter.print(endDt)); 
		param.setStartDt(formatter.print(endDt.minusDays(7)));//today - 7 day (last 7day)
		//param.setSkillUuid("c9d7e581-723f-11ea-bc9b-022e2bbe7be0");
		log.debug(param.toString());
		
		return homeService.getIntentConfidenceAvg(param);
	}
	
	@GetMapping(value = "/intent/data")
	public List<Intent> getIntentDataList(SearchParam param) {
		log.debug(param.toString());
		
		return homeService.getIntentDataList(param);
	}
	
	
	@GetMapping(value = "/intent/daily")
	public HashMap<String,Object> getIntentDailyList(SearchParam param) {
		log.debug(param.toString());
		/*
		 * 시작일과 종료일을 반복문으로 chart에 표시하기위한 일자 배열을 생성하여 param에 추가
		 */
		homeService.getStartEndDateList(param);
		
		//chart 표시용 데이터
		HashMap<String,Object> hm = new HashMap<String,Object>(); 
		List<HashMap<String,Object>> list = homeService.getIntentDailyList(param);
		
		hm.put("categories", param.getCategories());
		hm.put("list", list);
		return hm;
	}
	
	@GetMapping(value = "/entity/daily")
	public HashMap<String,Object> getEntityDailyList(SearchParam param) {
		log.debug(param.toString());
		
		int logCnt = homeService.getLogCount();
		log.debug("Test Log count:{}",logCnt);
		
		/*
		 * 시작일과 종료일을 반복문으로 chart에 표시하기위한 일자 배열을 생성하여 param에 추가
		 */
		homeService.getStartEndDateList(param);
		
		//chart 표시용 데이터
		HashMap<String,Object> hm = new HashMap<String,Object>(); 
		List<HashMap<String,Object>> list = homeService.getEntityDailyList(param);
		
		hm.put("categories", param.getCategories());
		hm.put("list", list);
		return hm;
	}
	
	@GetMapping(value = "/usage")
	public HashMap<String,Object> usage(SearchParam param) {
		log.debug(param.toString());
		
		
		
		HashMap<String,Object> hm = new HashMap<String,Object>();
		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		if("daily".equals(param.getCategoryType())) {
			homeService.getStartEndDateList(param);
			list = homeService.getUsageDateList(param);
		}else {
			//hourly
			homeService.getStartEndDatTimeList(param);
			list = homeService.getUsageDateTimeList(param);
		}
		
		//chart 표시용 데이터
		 
		
		
		hm.put("categories", param.getCategories());
		hm.put("list", list);
		return hm;
		
		
	}
	
	
	
}
