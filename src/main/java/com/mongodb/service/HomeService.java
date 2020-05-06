package com.mongodb.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mongodb.dao.HomeDao;
import com.mongodb.domain.Conversation;
import com.mongodb.domain.Entity;
import com.mongodb.domain.Intent;
import com.mongodb.domain.SearchParam;
import com.mongodb.domain.Usage;
import com.mongodb.mapper.HomeMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class HomeService {

	@Autowired
	private HomeDao homeDao;
	
	@Autowired
	private HomeMapper homeMapper;

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

	public List<HashMap<String,Object>> getIntentDailyList(SearchParam param) {
		//해당기간 전체 intent 종류의 count
		List<Intent> top10List = homeDao.getIntentTop10(param);
		
		//top10의 intent로 배열을 만든다.(mongoDB query용)
		List<String> intents = new ArrayList<>();
		for(Intent i : top10List) {
			intents.add(i.getIntent());
		}
		param.setSchNames(intents);
		
		//일별 top10별 intent count 목록을 가져온다. 
		List<Intent> dailyList = homeDao.getIntentTop10DailyCount(param);
		
		//dailyList.forEach(System.out::println);
		/*
		 * 아래 구조의 데이터 목록을 만든다.
		 * serise data : {[name:"인텐트명1",data:[0,1,1,0 ....], ...]}
		 */
		List<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
		List<String> days = param.getSchDays();
		
		for(String name: intents) {
			HashMap<String,Object> hm = new HashMap<String,Object>();
			int[] i_array = new int[days.size()];   
			for(int i=0 ; i<days.size(); i++) {
				for(Intent in : dailyList ) {
					if(days.get(i).equals(in.getDateDay()) && name.equals(in.getIntent())) {
						i_array[i]=in.getIntentCount();
					}
				}
			}
			/*
			for(int j=0; j<i_array.length ;j++) {
				System.out.println(i_array[j]);
			}
			*/
			hm.put("name", name);
			hm.put("data", i_array);
			
			list.add(hm);
		}
//		list.forEach(System.out::println);
		return list;
	}

	/**
	 * @param param
	 * 시작일과 종료일을 반복문으로 chart에 표시하기위한 일자 배열을 생성하여 SearchParam에 추가
	 * categories : chart x축 표시용 (fmt2)
	 * days : 날짜별 집계 값을 구하기 위한 배열 (fmt1)
	 */
	public void getStartEndDateList(SearchParam param) {
		DateTimeFormatter fmt1 = DateTimeFormat.forPattern("yyyyMMdd");
		DateTimeFormatter fmt2 = DateTimeFormat.forPattern("yyyy-MM-dd");
		
		List<String> categories = new ArrayList<>();
		List<String> days = new ArrayList<>();
		
		DateTime startDt = fmt1.parseDateTime(param.getSchStartDt());
		DateTime endDt = fmt1.parseDateTime(param.getSchEndDt());
		//System.out.println("startDt:"+startDt +" endDt:"+endDt);
		
		DateTime currDt = startDt;
		do {
			days.add(currDt.toString(fmt1));
			categories.add(currDt.toString(fmt2));
			currDt = currDt.plusDays(1);
			//System.out.println(currDt);
			
		} while (!currDt.isAfter(endDt));
		
		param.setSchDays(days);
		param.setSchCategories(categories);
		
	}

	public List<HashMap<String, Object>> getEntityDailyList(SearchParam param) {
		//해당기간 전체 Entity 종류의 count
		List<Entity> top10List = homeDao.getEntityTop10(param);
		
		//top10의 intent로 배열을 만든다.(mongoDB query용)
		List<String> values = new ArrayList<>();
		for(Entity i : top10List) {
			values.add(i.getValue());
		}
		param.setSchNames(values);
		
		//일별 top10별 Entity count 목록을 가져온다. 
		List<Entity> dailyList = homeDao.getEntityTop10DailyCount(param);
		
		//dailyList.forEach(System.out::println);
		/*
		 * 아래 구조의 데이터 목록을 만든다.
		 * serise data : {[name:"인텐트명1",data:[0,1,1,0 ....], ...]}
		 */
		List<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
		List<String> days = param.getSchDays();
		
		for(String name: values) {
			HashMap<String,Object> hm = new HashMap<String,Object>();
			int[] i_array = new int[days.size()];   
			for(int i=0 ; i<days.size(); i++) {
				for(Entity en : dailyList ) {
					if(days.get(i).equals(en.getDateDay()) && name.equals(en.getValue())) {
						i_array[i]=en.getEntityCount();
					}
				}
			}
			/*
			for(int j=0; j<i_array.length ;j++) {
				System.out.println(i_array[j]);
			}
			*/
			hm.put("name", name);
			hm.put("data", i_array);
			
			list.add(hm);
		}
//				list.forEach(System.out::println);
		return list;
	}

	public int getLogCount() {

		return homeMapper.getLogCount();
	}

	public List<HashMap<String, Object>> getUsageDateList(SearchParam param) {
		// MariaDB에서 시간별 통계데이터를 가져와 날짜를 key로 하는 HashMap List 생성
		List<Usage> list = homeMapper.getUsageDailyList(param);
		HashMap<String,Usage> listhm = new HashMap<String,Usage>();
		if(list != null) {
			for(Usage u : list) {
				listhm.put(u.getDateDay(), u);
			}
		}
		//log.debug(listhm.toString());
		
		List<String> dayTimes = param.getSchDays();
		int[] usage_array = new int[dayTimes.size()];
		int[] api_call_array = new int[dayTimes.size()];
		
		
		for(int i=0; i < dayTimes.size() ; i++) {
			Usage usg = listhm.get(dayTimes.get(i));
			if(usg == null) {
				usage_array[i] = 0; 
				api_call_array[i] = 0;
			}else {
				//log.debug(dayTimes.get(i) + " " +usg.toString());
				usage_array[i] = usg.getUsage();
				api_call_array[i] = usg.getApiCall(); 
			}
		}
		List<HashMap<String, Object>> rlist = new ArrayList<HashMap<String, Object>>();
		HashMap<String, Object> hm1 = new HashMap<String, Object>();
		/*
		[{
	        type: 'column',
	        name: 'Jane',
	        data: [3, 2, 1, 3, 4]
	    }, {
	        type: 'spline',
	        name: 'Average',
	        data: [3, 2.67, 3, 6.33, 3.33]
	    
	    }]
		*/
		
		hm1.put("type", "column");
		hm1.put("name", "Usage");
		hm1.put("data", usage_array);
		rlist.add(hm1);
		
		HashMap<String, Object> hm2 = new HashMap<String, Object>();
		hm2.put("type", "spline");
		hm2.put("name", "API Call");
		hm2.put("data", api_call_array);
		rlist.add(hm2);
		
		return rlist;
		
		
	}

	public void getStartEndDatTimeList(SearchParam param) {
		DateTimeFormatter fmt1 = DateTimeFormat.forPattern("yyyyMMddHHmm");
		DateTimeFormatter fmt2 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm");
		
		List<String> categories = new ArrayList<>();
		List<String> daytimes = new ArrayList<>();
		
		DateTime startDt = fmt1.parseDateTime(param.getSchStartDt()+"0000");
		DateTime endDt = fmt1.parseDateTime(param.getSchEndDt()+"2300");
		//System.out.println("startDt:"+startDt +" endDt:"+endDt);
		
		DateTime currDt = startDt;
		do {
			daytimes.add(currDt.toString(fmt1));
			categories.add(currDt.toString(fmt2));
			currDt = currDt.plusHours(1);
			//System.out.println(currDt);
			
		} while (!currDt.isAfter(endDt));
		
		param.setSchDays(daytimes);
		param.setSchCategories(categories);
		
		//categories.forEach(System.out::println);
		
		
		
	}

	public List<HashMap<String, Object>> getUsageDateTimeList(SearchParam param) {
		// MariaDB에서 시간별 통계데이터를 가져와 날짜시가을 key로 하는 HashMap List 생성
		List<Usage> list = homeMapper.getUsageDateHourlyList(param);
		HashMap<String,Usage> listhm = new HashMap<String,Usage>();
		if(list != null) {
			for(Usage u : list) {
				listhm.put(u.getDateDay(), u);
			}
		}
		//log.debug(listhm.toString());
		
		List<String> dayTimes = param.getSchDays();
		int[] usage_array = new int[dayTimes.size()];
		int[] api_call_array = new int[dayTimes.size()];
		
		
		for(int i=0; i < dayTimes.size() ; i++) {
			Usage usg = listhm.get(dayTimes.get(i));
			if(usg == null) {
				usage_array[i] = 0; 
				api_call_array[i] = 0;
			}else {
				//log.debug(dayTimes.get(i) + " " +usg.toString());
				usage_array[i] = usg.getUsage();
				api_call_array[i] = usg.getApiCall(); 
			}
		}
		List<HashMap<String, Object>> rlist = new ArrayList<HashMap<String, Object>>();
		HashMap<String, Object> hm1 = new HashMap<String, Object>();
		/*
		[{
	        type: 'column',
	        name: 'Jane',
	        data: [3, 2, 1, 3, 4]
	    }, {
	        type: 'spline',
	        name: 'Average',
	        data: [3, 2.67, 3, 6.33, 3.33]
	    
	    }]
		*/
		
		hm1.put("type", "column");
		hm1.put("name", "Usage");
		hm1.put("data", usage_array);
		rlist.add(hm1);
		
		HashMap<String, Object> hm2 = new HashMap<String, Object>();
		hm2.put("type", "spline");
		hm2.put("name", "API Call");
		hm2.put("data", api_call_array);
		rlist.add(hm2);
		
		return rlist;
	}

	public List<Conversation> getConversationDataList(SearchParam param) {
		// TODO Auto-generated method stub
		return homeDao.getConversationDataList(param);
	}

	public Integer getConversationDataTotalCount(SearchParam param) {
		
		return homeDao.getConversationDataTotalCount(param);
	}

	public Integer getConversationDataFilteredCount(SearchParam param) {
		// TODO Auto-generated method stub
		return homeDao.getConversationDataFilteredCount(param);
	}
}
