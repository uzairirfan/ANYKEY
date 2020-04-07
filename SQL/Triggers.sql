--Creates a trigger to auto buy a game every time there is an update on game_ware (such as quantity being removed)
create trigger buy_from_publisher
	after update
	on game_ware
	for each row
	execute procedure auto_buy()
	
--Creates a trigger to sell stock after there is an order made
create trigger sell_stock_warhouse
	after insert
	on game_order
	for each statement
	execute procedure sell_stock()
