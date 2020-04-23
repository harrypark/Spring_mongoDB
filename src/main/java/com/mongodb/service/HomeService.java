package com.mongodb.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mongodb.dao.HomeDao;
import com.mongodb.domain.Entity;
import com.mongodb.domain.Intent;
import com.mongodb.domain.SearchParam;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class HomeService {

	@Autowired
	private HomeDao homeDao;

	public List<Intent> getIntentTop10(SearchParam param) {
		return homeDao.getIntentTop10(param);
	}

	public List<Entity> getEntityTop10(SearchParam param) {
		return homeDao.getEntityTop10(param);
	}

	public HashMap<String, Double> getIntentConfidenceAvg(SearchParam param) {
		// today
		Intent todayAvg =  homeDao.getTodayIntentConfidenceAvg(param);
		// last 7day
		Intent last7dayAvg =  homeDao.getLast7dayIntentConfidenceAvg(param);
		
		HashMap<String, Double> res = new HashMap<String, Double>();
		res.put("today", todayAvg.getConfidenceAvg());
		res.put("last7day", last7dayAvg.getConfidenceAvg());

		return res;
	}

	public List<Intent> getIntentDataList(SearchParam param) {
		// TODO Auto-generated method stub
		return homeDao.getIntentDataList(param);
	}
}
