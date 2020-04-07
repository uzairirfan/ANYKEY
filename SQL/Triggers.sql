
create trigger buy_from_publisher
	after update
	on game_ware
	for each row
	execute procedure auto_buy()
	


create trigger sell_stock_warhouse
	after insert
	on game_order
	for each statement
	execute procedure sell_stock()
