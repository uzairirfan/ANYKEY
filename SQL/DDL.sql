/*This DDL creates all the tables and assigns the primary keys and foreign keys
The tables it creates are address, admin, bank_info, developer, game, genre, orders, publisher, restock_order, users, warehouse, game_ware, game_order, admin_bank, user_bank, game_gen, user_cart, amount_owed and expense*/
CREATE TABLE public.address (
    street_no SMALLINT NOT NULL,
    street character varying(30) NOT NULL,
    city character varying(30) NOT NULL,
    province character varying(30) NOT NULL,
    country character varying(30) NOT NULL
);

CREATE TABLE public.admin (
    email character varying(40) NOT NULL,
    password character varying(15) NOT NULL
);

CREATE TABLE public.bank_info (
    card BIGINT NOT NULL,
    email character varying(40) NOT NULL,
    street_no SMALLINT NOT NULL,
    street character varying(30) NOT NULL,
    city character varying(30) NOT NULL,
    first_name character varying(15) NOT NULL,
    last_name character varying(20) NOT NULL,
    unique(card)
);

CREATE TABLE public.developer (
    dev_id bigint NOT NULL,
    dev_name character varying(100) NOT NULL
);

CREATE TABLE public.game (
    appid BIGINT NOT NULL,
    dev_id bigint NOT NULL,
    pub_email character varying(60) NOT NULL,
    title character varying(100) NOT NULL,
    playtime BIGINT NOT NULL,
    ratings BIGINT NOT NULL,
    sell_price int NOT NULL,
    percentage smallint NOT NULL,
    available boolean NOT NULL,
	unique(appid)
);

CREATE TABLE public.genre (
    genre character varying(30) NOT NULL
);


CREATE TABLE public.orders (
    order_id bigint NOT NULL,
    card bigint NOT NULL,
    email character varying(40) NOT NULL,
    street_no smallint NOT NULL,
    street character varying(30) NOT NULL,
    city character varying(30) NOT NULL,
    tracking_no bigint NOT NULL,
    orderdate bigint NOT NULL,
	unique(order_id)
);

CREATE TABLE public.publisher (
    pub_email character varying(60) NOT NULL,
    pub_name character varying(100) NOT NULL
);

CREATE TABLE public.restock_order (
    order_id bigint NOT NULL,
    pub_email character varying(60) NOT NULL,
    ware_id bigint NOT NULL,
    email character varying(40) NOT NULL,
    appid bigint NOT NULL,
    quantity smallint NOT NULL,
    orderdate bigint NOT NULL
);

CREATE TABLE public.users (
    email character varying(30) NOT NULL,
    password character varying(15) NOT NULL
);

CREATE TABLE public.warehouse (
    ware_id bigint NOT NULL,
    name character varying(30) not null,
	unique(ware_id)
);

CREATE TABLE public.game_ware (
    ware_id bigint NOT NULL,
    appid bigint not null,
    quantity bigint not null
);

CREATE TABLE public.game_order (
    appid bigint NOT NULL,
    order_id bigint NOT NULL,
    quantity bigint NOT NULL
);

CREATE TABLE public.admin_bank (
    email character varying(30) NOT NULL,
    card bigint NOT NULL
);

CREATE TABLE public.user_bank (
    email character varying(30) NOT NULL,
    card bigint NOT NULL
);

CREATE TABLE public.game_gen (
    genre character varying(30) NOT NULL,
    appid bigint NOT NULL
);

create table user_cart(
appid BIGINT NOT NULL,
email character varying (30) NOT NULL,
quantity int NOT NULL
);

create table amount_owed(
pub_email character varying(60) NOT NULL,
email character varying (30) NOT NULL,
amount bigint not null
);

create table expense(
email character varying (30) NOT NULL,
id bigint not null,
date bigint not null,
reason character varying(280),
amount bigint not null
);

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (city, street_no, street);

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (email);
    
ALTER TABLE ONLY public.bank_info
    ADD CONSTRAINT bank_info_pkey PRIMARY KEY (card, email, street_no, street, city);

ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_pkey PRIMARY KEY (dev_id);
    
ALTER TABLE ONLY public.publisher
    ADD CONSTRAINT publisher_pkey PRIMARY KEY (pub_email);

ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_pkey PRIMARY KEY (appid, dev_id, pub_email);

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (genre);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id, card, email, street_no, street, city);

ALTER TABLE ONLY public.restock_order
    ADD CONSTRAINT restock_order_pkey PRIMARY KEY (order_id, pub_email, ware_id, email, appid);

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (email);

ALTER TABLE ONLY public.warehouse
    ADD CONSTRAINT warehouse_pkey PRIMARY KEY (ware_id);
    
ALTER TABLE ONLY public.expense
    ADD CONSTRAINT expense_pkey PRIMARY KEY (id, email);
    
ALTER TABLE ONLY public.amount_owed
    ADD CONSTRAINT amount_owed_pkey PRIMARY KEY (pub_email, email);
    
ALTER TABLE ONLY public.game_gen
    ADD CONSTRAINT game_gen_pkey PRIMARY KEY (genre, appid);
    
ALTER TABLE ONLY public.game_order
    ADD CONSTRAINT game_order_pkey PRIMARY KEY (appid, order_id);
    
ALTER TABLE ONLY public.game_ware
    ADD CONSTRAINT game_ware_pkey PRIMARY KEY (ware_id, appid);
    
ALTER TABLE ONLY public.admin_bank
    ADD CONSTRAINT admin_bank_pkey PRIMARY KEY(email, card);
    
ALTER TABLE ONLY public.user_bank
    ADD CONSTRAINT user_bank_pkey PRIMARY KEY (email, card);
   
ALTER TABLE ONLY public.user_cart
    ADD CONSTRAINT user_bank_pkey PRIMARY KEY (appid, email);

ALTER TABLE ONLY public.bank_info
    ADD CONSTRAINT bank_info_street_no_street_city_fkey FOREIGN KEY (street_no, street, city) REFERENCES public.address(street_no, street, city);

ALTER TABLE ONLY public.bank_info
    ADD CONSTRAINT bank_info_email_fkey FOREIGN KEY (email) REFERENCES public.users(email);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_street_no_street_city_fkey FOREIGN KEY (street_no, street, city) REFERENCES public.address(street_no, street, city);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_card_fkey FOREIGN KEY (card) REFERENCES public.bank_info(card);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_email_fkey FOREIGN KEY (email) REFERENCES public.users(email);

ALTER TABLE ONLY public.restock_order
    ADD CONSTRAINT restock_order_appid_fkey FOREIGN KEY (appid) REFERENCES public.game(appid);

ALTER TABLE ONLY public.restock_order
    ADD CONSTRAINT restock_order_pub_email_fkey FOREIGN KEY (pub_email) REFERENCES public.publisher(pub_email);

ALTER TABLE ONLY public.restock_order
    ADD CONSTRAINT restock_order_ware_id_fkey FOREIGN KEY (ware_id) REFERENCES public.warehouse(ware_id);

ALTER TABLE ONLY public.restock_order
    ADD CONSTRAINT restock_order_email_fkey FOREIGN KEY (email) REFERENCES public.admin(email);

ALTER TABLE ONLY public.game_ware
    ADD CONSTRAINT game_ware_appid_fkey FOREIGN KEY (appid) REFERENCES public.game(appid);
    
ALTER TABLE ONLY public.game_ware
    ADD CONSTRAINT game_ware_ware_id_fkey FOREIGN KEY (ware_id) REFERENCES public.warehouse(ware_id);

ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_dev_id_fkey FOREIGN KEY (dev_id) REFERENCES public.developer(dev_id);

ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_pub_email_fkey FOREIGN KEY (pub_email) REFERENCES public.publisher(pub_email);

ALTER TABLE ONLY public.game_gen
    ADD CONSTRAINT game_gen_genre_fkey FOREIGN KEY (genre) REFERENCES public.genre(genre);

ALTER TABLE ONLY public.game_gen
    ADD CONSTRAINT game_gen_appid_fkey FOREIGN KEY (appid) REFERENCES public.game(appid);

ALTER TABLE ONLY public.game_order
    ADD CONSTRAINT game_order_appid_fkey FOREIGN KEY (appid) REFERENCES public.game(appid);

ALTER TABLE ONLY public.game_order
    ADD CONSTRAINT game_order_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);

ALTER TABLE ONLY public.admin_bank
    ADD CONSTRAINT admin_bank_email_fkey FOREIGN KEY (email) REFERENCES public.admin(email);

ALTER TABLE ONLY public.admin_bank
    ADD CONSTRAINT admin_bank_card_fkey FOREIGN KEY (card) REFERENCES public.bank_info(card);

ALTER TABLE ONLY public.user_bank
    ADD CONSTRAINT user_bank_email_fkey FOREIGN KEY (email) REFERENCES public.users(email);

ALTER TABLE ONLY public.user_bank
    ADD CONSTRAINT user_bank_card_fkey FOREIGN KEY (card) REFERENCES public.bank_info(card);

ALTER TABLE ONLY public.user_cart
    ADD CONSTRAINT user_cart_email_fkey FOREIGN KEY (email) REFERENCES public.users(email);

ALTER TABLE ONLY public.user_cart
    ADD CONSTRAINT user_cart_appid_fkey FOREIGN KEY (appid) REFERENCES public.game(appid);

ALTER TABLE ONLY public.amount_owed
    ADD CONSTRAINT amount_owned_pub_email_fkey FOREIGN KEY (pub_email) REFERENCES public.publisher(pub_email);

ALTER TABLE ONLY public.expense
    ADD CONSTRAINT expense_email_fkey FOREIGN KEY (email) REFERENCES public.admin(email);
