--This function is for a trigger to automatically buy more games and insert the restock order into  the restock_order relation
--If the quantity is less than 10, it will add all the quantities of the game sold and add that back to quantity
--It will also add this order to restock_order relation
create function auto_buy() returns trigger as $$
		#variable_conflict use_column
	begin
		if new.quantity < 10 then
			update game_ware set quantity = quantity + (
			select sum(quantity)
			from game_order
			where game_order.appid = new.appid)
			where game_ware.appid = new.appid;
		insert into restock_order
		values(
			(SELECT Cast(random()*(999999-111111)+1111111 as bigint)),
			(select pub_email from game where new.appid = game.appid),
			new.ware_id,
			'owner@hotmail.com',
			new.appid,
			(select sum(quantity) from game_order where game_order.appid = new.appid),
			(select cast(extract(epoch from current_date) as integer))
			  );
		end if;
		return new;
	end;
	
	$$ language plpgsql;


--This function is for a trigger to automatically remove games from stock
--It subtracts quantity with the new quantity
create function sell_stock() returns trigger as $$
	#variable_conflict use_column
	begin
		update game_ware set quantity = quantity - new.quantity
		where game_ware.appid = new.appid;
		return new;
	end;
	$$ language plpgsql;
