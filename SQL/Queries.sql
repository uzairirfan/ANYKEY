// adding to cart
insert into user_cart values ($appid, '$email', $quantity)

// getting all games
select * from game natural join publisher natural join developer where available = true

--removing from available games
update game set available = false where appid = ${appid}
 
//get items in user's cart
select * from user_cart natural join game natural join publisher natural join developer where email = '$email'
  
//search for games by title
SELECT  * FROM  game natural join publisher natural join developer WHERE LOWER(title) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game) and available

//search games by genre
SELECT  * FROM  game natural join publisher natural join developer natural join game_gen WHERE LOWER(genre) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game) and available

//search games by developer
SELECT  * FROM  game natural join publisher natural join developer WHERE LOWER(dev_name) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game) and available

//search games by publisher
SELECT  * FROM  game natural join publisher natural join developer WHERE LOWER(pub_name) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game) and available

//checking if publisher exists before creating tuple
select exists (select * from publisher where pub_name = '${pubs[0]}')
insert into publisher values ('$email', '${pubs[0]}') on conflict do nothing

//checking if developer exists before creating tuple
select exists (select * from developer where dev_name = '${devs[0]}')
insert into developer values ($devid, '${devs[0]}')

//inserting into game 
insert into game values ('${gamelist.games[i].appid}', ${devid}, '${pub}','${gamelist.games[i].name}',${gamelist.games[i].averagePlaytime},${gamelist.games[i].positiveRatings},${gamelist.games[i].price}, ${Random().nextInt(50)}, true) on conflict do nothing

//inserting into genre and game_gen
insert into genre values ('$g') on conflict do nothing
insert into game_gen values ('$g', '${gamelist.games[i].appid}') on conflict do nothing

//inserting game into warehouse (there's only one warehouse)
insert into warehouse values ('123456789', '${gamelist.games[i].appid}', 10) on conflict do nothing
      
//for updating an item in the cart's quantity
//if quantity = 0
delete from user_cart where appid = $appid
//else
update user_cart set quantity = $quantity where appid = $appid

//adding user or admin to table
insert into $type values ('$email', '$password')

//checking user credentials
select * from $type where email = '$email'

// to find recommended based off of the most popular genre in the user's orders
with x as (
	WITH agg AS (
		select genre, count(*) from
		game_gen natural join game natural join game_order natural join orders
		where email = 'fake@hotmail.com'
		group by genre
    )
	SELECT genre, count
	FROM agg
	WHERE agg.count = (SELECT MAX(count) FROM agg)
)
select *
from game natural join game_gen natural join x natural join publisher natural join developer
where genre = x.genre;

//get the orders details of a specific user
select * from orders natural join address where email = '$email'

//get the ordered game details of a specific order
select * from orders natural join game_order natural join
game natural join publisher natural join developer  where order_id =${row[3]}

//selecting random game for the featured list
SELECT * FROM game natural join publisher natural join developer OFFSET floor(random()*1000) LIMIT 1;

//finding stats for diff genres
select sum(quantity)::smallint, genre, sum(sell_price), avg(percentage)::smallint from
game_order natural join game natural join game_gen group by genre

//finding stats for diff publishers
select sum(quantity)::smallint, pub_name, sum(sell_price), avg(percentage)::smallint
from game_order natural join game natural join publisher group by pub_name


//finding stats for diff developers
select sum(quantity)::smallint, dev_name, sum(sell_price), avbg(percentage)::smallint
from game_order natural join game natural join developer group by dev_name

//insert new expense
insert into expense values ('$email', ${devid}, ${DateTime.now().millisecondsSinceEpoch}, '${Map['Reason']}', ${Map['Amount']})

//get expenses
select reason, amount from expense

//get amount owed to each publisher
select pub_name, amount from amount_owed right outer join publisher on amount_owed.pub_email = publisher.pub_email
