package com.mongodb.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

import com.mongodb.domain.Inventory;
import com.mongodb.domain.Item;

@Repository
public class InventoryDAOImpl implements InventoryDAO {
	
	@Autowired
    private MongoTemplate mongoTemplate;
    //mongodb의 컬렉션(테이블에 해당)
    String COLLECTION_NAME="inventory"; //테이블 이름
    
	@Override
	public List<Inventory> findAll() {
		Query query=new Query();
		
		
		List<Inventory> list=mongoTemplate.findAll(Inventory.class,COLLECTION_NAME);
				
				

		return list;
	}

	@Override
	public Inventory findByItem(String item) {
		Query query = new Query();
		query.addCriteria(Criteria.where("item").is(item));
		
		return mongoTemplate.findOne(query, Inventory.class, COLLECTION_NAME);
	}

	@Override
	public List<Item> getItems(int qty) {
		
		
		
//		MatchOperation where = null;  //조건절
//		where  = Aggregation.match(
//				 Criteria.where("qty").gt(qty)
//				);
//		
//		GroupOperation groupBy = null;  //그룹핑
//		groupBy = Aggregation.group("item").sum("size.w").as("size");
//		//groupBy = Aggregation.group("item").sum("size.w").as("size");
//		
//		ProjectionOperation dateProjection = Aggregation.project("item")
//				//.and("date").dateAsFormattedString("%Y-%m-%d").as("conv_date")
//				.and("size").previousOperation()
//				;	
//		
//		SortOperation sort = null; //정렬
//		sort = Aggregation.sort(Sort.Direction.DESC, "item");
//		
//		Aggregation agg = Aggregation.newAggregation(  //집계함수 내용 조립
//				where,
//				dateProjection,
//				groupBy,
//				sort
//		);
		
		Criteria criteria = new Criteria("qty");
		criteria.gt(50);
		// Intent Top 10.
		Aggregation agg = Aggregation.newAggregation(
				Aggregation.match(criteria),
				Aggregation.group("item")
				.sum("size.w").as("size")
				,
				Aggregation.project().and("_id").as("item").and("size").as("size"),
				Aggregation.limit(10)
				);
		
		AggregationResults<Item> results = mongoTemplate.aggregate(agg, "inventory", Item.class);  //HashMap으로 매핑
		System.out.println(results);
		
		
		List<Item> ress = results.getMappedResults();  //결과
		System.out.println(ress);
		ress.forEach(System.out::println);	//결과 출력
		
		
		return null;
	}

}
