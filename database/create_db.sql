drop database if exists finance;
create database finance;

grant all privileges on finance.* to finance@'localhost' identified by 'finance_fb3efc4';

use finance;

drop table if exists stocks;
create table stocks (
	id int primary key auto_increment,
	stockCode nchar(6),
	stockName varchar(16),
	market varchar(4),
	updateTime timestamp default now(),
	constraint uk_stocks_stockcode_market unique(stockCode, market)
)engine=innodb charset=utf8;

drop table if exists stocks_daily;
create table stocks_daily (
	id bigint primary key auto_increment,
	stockId int,
	openPrice decimal(10, 4),
	yesterdayClosePrice decimal(10, 4),
	curPrice decimal(10, 4),
	averagePrice decimal(10, 4),
	high decimal(10, 4),
	low decimal(10, 4),
	tradeVolume bigint,
	tradeValue decimal(20, 4),
	turnoverRate decimal(10,4),
	marketValue decimal(20, 4),
	circulationValue decimal(20, 4),
	pb decimal(10, 4),
	pe decimal(10, 4),
	buyVolume bigint,
	sellVolume bigint,
	amountRatio decimal(10, 4),
	entrustRatio decimal(10, 4),
	superFlowIn decimal(20, 4),
	superFlowOut decimal(20, 4),
	bigFlowIn decimal(20, 4),
	bigFlowOut decimal(20, 4),
	middleFlowIn decimal(20, 4),
	middleFlowOut decimal(20, 4),
	littleFlowIn decimal(20, 4),
	littleFlowOut decimal(20, 4),
	tradeDate date,
	updateTime timestamp default now(),
	constraint fk_stocks_daily_stockId foreign key (stockId) references stocks(id),
	constraint uk_stocks_daily_stockId_tradeDate unique(stockId, tradeDate)
)engine=innodb charset=utf8;

drop table if exists stock_categories;
create table stock_categories (
	id int(11) primary key auto_increment,
	categoryName varchar(16),
	categoryBy int,
	updateTime timestamp default now()
)engine=innodb charset=utf8;

drop table if exists stock_category_relationships;
create table stock_category_relationships (
	id int(11) primary key auto_increment,
	stockId int(11),
	categoryId int(11),
	updateTime timestamp default now(),
	constraint fk_stock_category_relationships_stockId foreign key (stockId) references stocks(id),
	constraint fk_stock_category_relationships_categoryId foreign key (categoryId) references stock_categories(id),
	constraint uk_stock_category_relationships_stockId_categoryId unique(stockId, categoryId)
)engine=innodb charset=utf8;

drop table if exists stock_trades;
create table stock_trades (
	stockId int(11),
	tradeTime timestamp,
	tradePrice decimal(10, 4),
	tradeVolume int(11),
	trend tinyint,
	updateTime timestamp default now()
)engine=innodb charset=utf8
partition by range(unix_timestamp(tradeTime)) (
	partition p0 values less than (unix_timestamp('2017-11-06 00:00:00')),
	partition p1 values less than (unix_timestamp('2017-11-13 00:00:00')),
	partition p2 values less than (unix_timestamp('2017-11-20 00:00:00')),
	partition p4 values less than (unix_timestamp('2017-11-27 00:00:00')),
	partition p5 values less than (unix_timestamp('2017-12-04 00:00:00')),
	partition p6 values less than (unix_timestamp('2017-12-11 00:00:00')),
	partition p7 values less than (unix_timestamp('2017-12-18 00:00:00')),
	partition p8 values less than (unix_timestamp('2017-12-25 00:00:00')),
	partition p9 values less than (unix_timestamp('2018-01-01 00:00:00')),
	partition p10 values less than (unix_timestamp('2018-01-08 00:00:00'))
);
