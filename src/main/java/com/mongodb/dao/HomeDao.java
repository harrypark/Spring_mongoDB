package com.mongodb.dao;

import java.util.List;

import com.mongodb.domain.Entity;
import com.mongodb.domain.Intent;
import com.mongodb.domain.SearchParam;

public interface HomeDao {

	List<Intent> getIntentTop10(SearchParam param);

	List<Entity> getEntityTop10(SearchParam param);

	Intent getTodayIntentConfidenceAvg(SearchParam param);

	Intent getLast7dayIntentConfidenceAvg(SearchParam param);

	List<Intent> getIntentDataList(SearchParam param);

}
