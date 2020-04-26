package com.mongodb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mongodb.domain.SearchParam;
import com.mongodb.domain.Usage;

@Mapper
public interface HomeMapper {

	int getLogCount();

	List<Usage> getUsageDailyList(SearchParam param);

	List<Usage> getUsageDateHourlyList(SearchParam param);

}
