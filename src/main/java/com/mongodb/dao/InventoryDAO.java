package com.mongodb.dao;

import java.util.List;

import com.mongodb.domain.Inventory;
import com.mongodb.domain.Item;

public interface InventoryDAO {

	List<Inventory> findAll();

	Inventory findByItem(String string);

	List<Item> getItems(int i); 
}
