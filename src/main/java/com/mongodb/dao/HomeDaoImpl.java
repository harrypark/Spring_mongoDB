package com.mongodb.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import com.mongodb.domain.Entity;
import com.mongodb.domain.Intent;
import com.mongodb.domain.SearchParam;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class HomeDaoImpl implements HomeDao {

	@Autowired
    private MongoTemplate mongoTemplate;
    //mongodb의 컬렉션(테이블에 해당)
    String COLLECTION_NAME="sample"; //테이블 이름
	
    @Override
	public List<Intent> getIntentTop10(SearchParam param) {
		// Intent Top 10.
		Aggregation agg = Aggregation.newAggregation(
				Aggregation.match(Criteria.where("skill_uuid").is(param.getSkillUuid()).and("date_day").gte(param.getStartDt()).lte(param.getEndDt())),
				Aggregation.unwind("output.intents"),
				Aggregation.group("output.intents.intent").sum("output.intents.confidence").as("confidenceSum")
				.avg("output.intents.confidence").as("confidenceAvg").count().as("intentCount"),
				Aggregation.project().and("_id").as("intent").and("confidenceSum").as("confidenceSum").and("confidenceAvg").as("confidenceAvg").and("intentCount").as("intentCount"),
				Aggregation.sort(Sort.Direction.DESC, "intentCount"),
				Aggregation.limit(10)
				);
		
		AggregationResults<Intent> results = mongoTemplate.aggregate(agg, "sample", Intent.class);  
		//System.out.println(results);
		
		List<Intent> list = results.getMappedResults();  //결과
		//System.out.println(list);
		return list;
	}

	@Override
	public List<Entity> getEntityTop10(SearchParam param) {
		// Intent Top 10.
		Aggregation agg = Aggregation.newAggregation(
				Aggregation.match(Criteria.where("skill_uuid").is(param.getSkillUuid()).and("date_day").gte(param.getStartDt()).lte(param.getEndDt())),
				Aggregation.unwind("output.entities"),
				Aggregation.group("output.entities.value").sum("output.entities.confidence").as("confidenceSum")
				.avg("output.entities.confidence").as("confidenceAvg").count().as("entityCount"),
				Aggregation.project().and("_id").as("value").and("confidenceSum").as("confidenceSum").and("confidenceAvg").as("confidenceAvg").and("entityCount").as("entityCount"),
				Aggregation.sort(Sort.Direction.DESC, "entityCount"),
				Aggregation.limit(10)
				);
		
		AggregationResults<Entity> results = mongoTemplate.aggregate(agg, "sample", Entity.class);  
		//System.out.println(results);
		
		List<Entity> list = results.getMappedResults();  //결과
		//System.out.println(list);
		return list;
	}

	@Override
	public Intent getTodayIntentConfidenceAvg(SearchParam param) {
		// TodayIntentConfidenceAvg.
		Aggregation agg = Aggregation.newAggregation(
				Aggregation.match(Criteria.where("skill_uuid").is(param.getSkillUuid()).and("date_day").is(param.getEndDt())),
				Aggregation.unwind("output.intents"),
				Aggregation.group("skill_uuid").avg("output.intents.confidence").as("confidenceAvg"),
				Aggregation.project().and("_id").as("skillUuid").and("confidenceAvg").multiply(100).as("confidenceAvg")
				);
		
		
		AggregationResults<Intent> result = mongoTemplate.aggregate(agg, "sample", Intent.class);
		//log.debug("result1:"+result);
		Intent intent = result.getUniqueMappedResult();
		
		return intent != null ? intent :  new Intent(param.getSkillUuid(),0.0,0.0,0);
		
	}

	@Override
	public Intent getLast7dayIntentConfidenceAvg(SearchParam param) {
		// Last7dayIntentConfidenceAvg.
		Aggregation agg = Aggregation.newAggregation(
				Aggregation.match(Criteria.where("skill_uuid").is(param.getSkillUuid()).and("date_day").gte(param.getStartDt()).lte(param.getEndDt())),
				Aggregation.unwind("output.intents"),
				Aggregation.group("skill_uuid").avg("output.intents.confidence").as("confidenceAvg"),
				Aggregation.project().and("_id").as("skillUuid").and("confidenceAvg").multiply(100).as("confidenceAvg")
				);
		
		
		AggregationResults<Intent> result = mongoTemplate.aggregate(agg, "sample", Intent.class);
		//log.debug("result1:"+result);
		Intent intent = result.getUniqueMappedResult();
		
		return intent != null ? intent :  new Intent(param.getSkillUuid(),0.0,0.0,0);
	}

	@Override
	public List<Intent> getIntentDataList(SearchParam param) {
		// Intent Top 10.
		Aggregation agg = Aggregation.newAggregation(
				Aggregation.match(Criteria.where("skill_uuid").is(param.getSkillUuid()).and("date_day").gte(param.getStartDt()).lte(param.getEndDt())),
				Aggregation.unwind("output.intents"),
				Aggregation.group("output.intents.intent").sum("output.intents.confidence").as("confidenceSum")
				.avg("output.intents.confidence").as("confidenceAvg").count().as("intentCount"),
				Aggregation.project().and("_id").as("intent").and("confidenceSum").as("confidenceSum").and("confidenceAvg").as("confidenceAvg").and("intentCount").as("intentCount"),
				Aggregation.sort(Sort.Direction.DESC, "intentCount")
				);
		
		AggregationResults<Intent> results = mongoTemplate.aggregate(agg, "sample", Intent.class);  
		//System.out.println(results);
		
		List<Intent> list = results.getMappedResults();  //결과
		//System.out.println(list);
		return list;
	}

	@Override
	public List<Intent> getIntentTop10DailyCount(SearchParam param) {
//		Fields fs = Aggregation.fields("date_day","output.intents.intent");//.field("item", "item");
//		fs.field("output.intents.intent","intent" );
		
		Aggregation agg = Aggregation.newAggregation(
				Aggregation.match(Criteria.where("skill_uuid").is(param.getSkillUuid()).and("date_day").gte(param.getStartDt()).lte(param.getEndDt()).and("output.intents.intent").in(param.getNames())),
				Aggregation.unwind("output.intents"),
				Aggregation.project().and("date_day").as("date_day").and("output.intents.intent").as("intent"),
				Aggregation.group("date_day","intent").count().as("intentCount"),
				Aggregation.project().and("date_day").as("dateDay").and("intent").as("intent").and("intentCount").as("intentCount"),
				Aggregation.sort(Sort.Direction.ASC, "dateDay")
				);
		
		AggregationResults<Intent> results = mongoTemplate.aggregate(agg, "sample", Intent.class);  
		//System.out.println(results);
		
		List<Intent> list = results.getMappedResults();  //결과
		return list;
	}

	@Override
	public List<Entity> getEntityTop10DailyCount(SearchParam param) {
		// Entity Top 10.
		Aggregation agg = Aggregation.newAggregation(
				
				Aggregation.match(Criteria.where("skill_uuid").is(param.getSkillUuid()).and("date_day").gte(param.getStartDt()).lte(param.getEndDt()).and("output.entities.value").in(param.getNames())),
				Aggregation.unwind("output.entities"),
				Aggregation.project().and("date_day").as("date_day").and("output.entities.value").as("value"),
				Aggregation.group("date_day","value").count().as("entityCount"),
				Aggregation.project().and("date_day").as("dateDay").and("value").as("value").and("entityCount").as("entityCount"),
				Aggregation.sort(Sort.Direction.ASC, "dateDay")
				);
		
		AggregationResults<Entity> results = mongoTemplate.aggregate(agg, "sample", Entity.class);  
		//System.out.println("re:"+results);
		
		List<Entity> list = results.getMappedResults();  //결과
		//System.out.println("list:"+list);
		return list;
	}

	
    
}
