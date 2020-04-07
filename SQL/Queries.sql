-- This query inserts the given values for appid, email and quantity into the user_cart relation.
insert into user_cart values ($appid, '$email', $quantity)

-- This query gets all the currently available games in the store, as well as joins with publisher and
-- developer in order to obtain the dev_name and pub_name.

select * from game natural join publisher natural join developer where available = true

-- setting the availability to false for a given game that the admin picks to remove from the store
update game set available = false where appid = ${appid}
 
-- get all of the items in a user's cart as well as joins with publisher and developer in order to obtain the dev_name and pub_name.
select * from user_cart natural join game natural join publisher natural join developer where email = '$email'

-- the following queries are for searching the game relation for all games that match a given string
-- utilizing ‘%’ in a query. The ‘%’ matches any string of zero or more characters,
-- so if I had it on either side of the search string, it would find any string that includes it.
-- For searching, we send in the string the user searches as ‘s’,
-- and available means only look at the games currently available in the store:
-- search for games by title
SELECT  * FROM  game natural join publisher natural join developer WHERE LOWER(title) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game) and available
-- search games by genre
SELECT  * FROM  game natural join publisher natural join developer natural join game_gen WHERE LOWER(genre) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game) and available
-- search games by developer
SELECT  * FROM  game natural join publisher natural join developer WHERE LOWER(dev_name) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game) and available
-- search games by publisher
SELECT  * FROM  game natural join publisher natural join developer WHERE LOWER(pub_name) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game) and available

-- checking if publisher exists before creating tuple
select exists (select * from publisher where pub_name = '${pubs[0]}')
insert into publisher values ('$email', '${pubs[0]}') on conflict do nothing

-- checking if developer exists before creating tuple
select exists (select * from developer where dev_name = '${devs[0]}')
insert into developer values ($devid, '${devs[0]}')

-- inserting into game, the given values, add on conflict due to duplicate games in data bank
insert into game values ('${gamelist.games[i].appid}', ${devid}, '${pub}','${gamelist.games[i].name}',
${gamelist.games[i].averagePlaytime},${gamelist.games[i].positiveRatings},${gamelist.games[i].price}, ${Random().nextInt(50)}, true) on conflict do nothing

-- inserting into genre and game_gen for each genre of a game
insert into genre values ('$g') on conflict do nothing
insert into game_gen values ('$g', '${gamelist.games[i].appid}') on conflict do nothing

-- inserting game into warehouse (there's only one warehouse)
insert into warehouse values ('123456789', '${gamelist.games[i].appid}', 10) on conflict do nothing
      
-- for updating an item in the cart's quantity
-- if quantity = 0
delete from user_cart where appid = $appid
-- else
update user_cart set quantity = $quantity where appid = $appid

-- adding user or admin to table
insert into $type values ('$email', '$password')

-- checking user credentials
select * from $type where email = '$email'

-- to find recommended based off of the most popular genre in the user's orders
-- in this query, we have subqueries to group the user’s genres in their orders,
-- then find the one with the max amount,
-- and then find other games with the same genre as the genre that has the max amount in the user’s past orders.
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

-- get the orders details of a specific user
select * from orders natural join address where email = '$email'

-- get the games in a specific order
select * from orders natural join game_order natural join
game natural join publisher natural join developer  where order_id =${row[3]}

-- selecting random game for the featured list
-- This query selects a random row from the 1000 rows we have in our game relation (which is signified by the random()*1000)
-- It takes the floor, because we want to avoid fractions. Offset means to skip that many rows and then take one row.
SELECT * FROM game natural join publisher natural join developer OFFSET floor(random()*1000) LIMIT 1;

-- finding stats for different genres, such as the quantity sold, the genre, the sum of the sell_price,
-- and the average percent to the publisher
select sum(quantity)::smallint, genre, sum(sell_price), avg(percentage)::smallint from
game_order natural join game natural join game_gen group by genre

-- finding stats for different publishers, such as the quantity sold, the genre, the sum of the sell_price,
-- and the average percent to the publisher
select sum(quantity)::smallint, pub_name, sum(sell_price), avg(percentage)::smallint
from game_order natural join game natural join publisher group by pub_name

-- finding stats for different developers, such as the quantity sold, the genre, the sum of the sell_price,
-- and the average percent to the publisher
select sum(quantity)::smallint, dev_name, sum(sell_price), avbg(percentage)::smallint
from game_order natural join game natural join developer group by dev_name

-- adding a new expense to the table
insert into expense values ('$email', ${devid}, ${DateTime.now().millisecondsSinceEpoch}, '${Map['Reason']}', ${Map['Amount']})

-- get all of the expenses from the table
select reason, amount from expense

-- getting the amount owed to each publisher
select pub_name, amount fcrom amount_owed right outer join publisher on amount_owed.pub_email = publisher.pub_email