create function auto_buy() returns trigger as $$
	#variable_conflict use_column
	begin
		if new.quantity < 10 then
			update game_ware set quantity = quantity + (
			select sum(quantity)
			from game_order
			where game_order.appid = new.appid)
			where game_ware.appid = new.appid;
		end if;
		return new;
	end;
	$$ language plpgsql;



create function sell_stock() returns trigger as $$
	#variable_conflict use_column
	begin
		update game_ware set quantity = quantity - new.quantity
		where game_ware.appid = new.appid;
		return new;
	end;
	$$ language plpgsql;
