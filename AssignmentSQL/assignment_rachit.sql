-- Assignment - Stock Market Analysis
-- By Rachit Dev
-- Main sql query file.

-- Lets create a database first.
create database if not exists sql_assignment;
-- Lets use the sql_assignment database for our further exercise.
use sql_assignment;
-- Lets check the tables
-- select * from bajaj1;
-- Lets alter the table bajaj and add a new column new_date which will contain formatted date from the text date.
alter table bajaj add column new_date DATE;
update bajaj
set new_date = str_to_date(`Date`, '%d-%M-%Y');
ALTER TABLE bajaj DROP Date;

-- Lets alter the table eicher and add a new column new_date which will contain formatted date from the text date.
alter table eicher add column new_date DATE;
update eicher
set new_date = str_to_date(`Date`, '%d-%M-%Y');
ALTER TABLE eicher DROP Date;

-- Lets alter the table hero and add a new column new_date which will contain formatted date from the text date.
alter table hero add column new_date DATE;
update hero
set new_date = str_to_date(`Date`, '%d-%M-%Y');
ALTER TABLE hero DROP Date;

-- Lets alter the table infosys and add a new column new_date which will contain formatted date from the text date.
alter table infosys add column new_date DATE;
update infosys
set new_date = str_to_date(`Date`, '%d-%M-%Y');
ALTER TABLE infosys DROP Date;

-- Lets alter the table tcs and add a new column new_date which will contain formatted date from the text date.
alter table tcs add column new_date DATE;
update tcs
set new_date = str_to_date(`Date`, '%d-%M-%Y');
ALTER TABLE tcs DROP Date;

-- Lets alter the table tvs and add a new column new_date which will contain formatted date from the text date.
alter table tvs add column new_date DATE;
update tvs
set new_date = str_to_date(`Date`, '%d-%M-%Y');
ALTER TABLE tvs DROP Date;

-- Assignment's 1st expected results starts from here. 
-- Lets create a window function for MA20 and MA50 and save them in table bajaj1
CREATE TABLE bajaj1
SELECT new_date as `Date`, `Close Price`,
	   ROUND(AVG(close_price) OVER (ORDER BY new_date ASC ROWS 19 PRECEDING), 2) AS `20 Day MA`,
       ROUND(AVG(close_price) OVER (ORDER BY new_date ASC ROWS 49 PRECEDING), 2) AS `50 Day MA`
FROM   bajaj;

-- Test the above window function using the below commented query.
-- select *
-- from bajaj1;

-- Lets create a window function for MA20 and MA50 and save them in table eicher1
CREATE TABLE eicher1
SELECT new_date as `Date`, `Close Price`,
	   ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 19 PRECEDING), 2) AS `20 Day MA`,
       ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 49 PRECEDING), 2) AS `50 Day MA`
FROM   eicher;

-- Test the above window function using the below commented query.
-- select *
-- from eicher1;

-- Lets create a window function for MA20 and MA50 and save them in table hero1
CREATE TABLE hero1
SELECT new_date as `Date`, `Close Price`,
	   ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 19 PRECEDING), 2) AS `20 Day MA`,
       ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 49 PRECEDING), 2) AS `50 Day MA`
FROM   hero;

-- Test the above window function using the below commented query.
-- select *
-- from hero1;

-- Lets create a window function for MA20 and MA50 and save them in table infosys1
CREATE TABLE infosys1
SELECT new_date as `Date`, `Close Price`,
	   ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 19 PRECEDING), 2) AS `20 Day MA`,
       ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 49 PRECEDING), 2) AS `50 Day MA`
FROM   infosys;

-- Test the above window function using the below commented query.
-- select *
-- from infosys1;

-- Lets create a window function for MA20 and MA50 and save them in table tcs1
CREATE TABLE tcs1
SELECT new_date as `Date`, `Close Price`,
	   ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 19 PRECEDING), 2) AS `20 Day MA`,
       ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 49 PRECEDING), 2) AS `50 Day MA`
FROM   tcs;

-- Test the above window function using the below commented query.
-- select *
-- from tcs1;

-- Lets create a window function for MA20 and MA50 and save them in table tvs1
CREATE TABLE tvs1
SELECT new_date as `Date`, `Close Price`,
	   ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 19 PRECEDING), 2) AS `20 Day MA`,
       ROUND(AVG(`Close Price`) OVER (ORDER BY new_date ASC ROWS 49 PRECEDING), 2) AS `50 Day MA`
FROM   tvs;

-- Test the above window function using the below commented query.
-- select *
-- from tvs1;

-- Assignment's 1st expected results ends here.

-- Lets drop the tables which are no more required.
DROP TABLE bajaj, eicher, hero, infosys, tcs, tvs;

-- Assignment's 2nd question expected results starts here.
-- Let's create the window function for creating the master table.
CREATE TABLE `master`
SELECT bajaj1.Date, bajaj1.`Close Price` AS Bajaj, eicher1.`Close Price` AS Eicher, 
		hero1.`Close Price` AS Hero, infosys1.`Close Price` AS Infosys,
        tcs1.`Close Price` AS TCS, tvs1.`Close Price` AS TVS
FROM (((((bajaj1
INNER JOIN eicher1 ON bajaj1.`Date` = eicher1.`Date`)
INNER JOIN hero1 ON bajaj1.`Date` = hero1.`Date`)
INNER JOIN infosys1 ON bajaj1.`Date` = infosys1.`Date`)
INNER JOIN tcs1 ON bajaj1.`Date` = tcs1.`Date`)
INNER JOIN tvs1 ON bajaj1.`Date` = tvs1.`Date`);

-- Test the above window function using the below commented query.
-- SELECT *
-- FROM `master`
-- Assignment's 2nd expected result ends here.


-- Lets create a table from bajaj1 for the 3rd part of assignment to generate signal.
create table bajaj2 as
select `Date`, `Close Price`,
case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then 'Hold'
	 when nth_value(short_term_greater,2) over w = 'Y' then 'Buy'
     when nth_value(short_term_greater,2) over w = 'N' then 'Sell'
     else 'Hold'
     end
As `Signal`
from
(
select `Date`, `Close Price`, 
		if (`20 Day MA` > `50 Day MA`, 'Y', 'N') short_term_greater
	from bajaj1
) temp_table

window w as (order by `Date` rows between 1 preceding and 0 following);

-- Test the above window function using the below commented query.
-- select * from bajaj2 order by `Date`;

-- similarly, lets create the table for eicher2.
create table eicher2 as
select `Date`, `Close Price`,
case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then 'Hold'
	 when nth_value(short_term_greater,2) over w = 'Y' then 'Buy'
     when nth_value(short_term_greater,2) over w = 'N' then 'Sell'
     else 'Hold'
     end
As `Signal`
from
(
select `Date`, `Close Price`, 
		if (`20 Day MA` > `50 Day MA`, 'Y', 'N') short_term_greater
	from eicher1
) temp_table

window w as (order by `Date` rows between 1 preceding and 0 following);

-- Test the above window function using the below commented query.
-- select * from eicher2 order by `Date`;

-- similarly, lets create the table for hero2
create table hero2 as
select `Date`, `Close Price`,
case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then 'Hold'
	 when nth_value(short_term_greater,2) over w = 'Y' then 'Buy'
     when nth_value(short_term_greater,2) over w = 'N' then 'Sell'
     else 'Hold'
     end
As `Signal`
from
(
select `Date`, `Close Price`, 
		if (`20 Day MA` > `50 Day MA`, 'Y', 'N') short_term_greater
	from hero1
) temp_table

window w as (order by `Date` rows between 1 preceding and 0 following);

-- Test the above window function using the below commented query.
-- select * from hero2 order by `Date`;

-- Lets create the table for infosys2
create table infosys2 as
select `Date`, `Close Price`,
case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then 'Hold'
	 when nth_value(short_term_greater,2) over w = 'Y' then 'Buy'
     when nth_value(short_term_greater,2) over w = 'N' then 'Sell'
     else 'Hold'
     end
As `Signal`
from
(
select `Date`, `Close Price`, 
		if (`20 Day MA` > `50 Day MA`, 'Y', 'N') short_term_greater
	from infosys1
) temp_table

window w as (order by `Date` rows between 1 preceding and 0 following);

-- Test the above window function using the below commented query.
-- select * from infosys2 order by `Date`;

-- Lets create the table for tcs2
create table tcs2 as
select `Date`, `Close Price`,
case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then 'Hold'
	 when nth_value(short_term_greater,2) over w = 'Y' then 'Buy'
     when nth_value(short_term_greater,2) over w = 'N' then 'Sell'
     else 'Hold'
     end
As `Signal`
from
(
select `Date`, `Close Price`, 
		if (`20 Day MA` > `50 Day MA`, 'Y', 'N') short_term_greater
	from tcs1
) temp_table

window w as (order by `Date` rows between 1 preceding and 0 following);

-- Test the above window function using the below commented query.
-- select * from tcs2 order by `Date`;

-- Lets create the table for tvs2
create table tvs2 as
select `Date`, `Close Price`,
case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then 'Hold'
	 when nth_value(short_term_greater,2) over w = 'Y' then 'Buy'
     when nth_value(short_term_greater,2) over w = 'N' then 'Sell'
     else 'Hold'
     end
As `Signal`
from
(
select `Date`, `Close Price`, 
		if (`20 Day MA` > `50 Day MA`, 'Y', 'N') short_term_greater
	from tvs1
) temp_table

window w as (order by `Date` rows between 1 preceding and 0 following);

-- Test the above window function using the below commented query.
-- select * from tvs2 order by `Date`;
-- Part 3 ends here.


-- Part 4 starts from here
-- Create a User defined function, that takes the date as input and returns the signal for that 
-- particular day (Buy/Sell/Hold) for the Bajaj stock.
-- The below mentioned function is the stored function that I wrote to return the signal value:
-- This function is stored in the other file signalOfDay.sql
-- CREATE DEFINER=`root`@`localhost` FUNCTION `signalOfDay`(input_date DATE) RETURNS varchar(4) CHARSET utf8mb4
--     DETERMINISTIC
-- begin
-- declare signal_value varchar(4);
-- SELECT 
--     `Signal`
-- INTO signal_value FROM
--     bajaj2
-- WHERE
--     `Date` = input_date;
-- return signal_value;
-- end


-- So we call the above mentioned function from the stored function signalOfDay in the below mentioned query.
Select `signalOfDay`('2015-05-18');
-- The above query returned "Buy".

-- End of Part 4 of the assignment and assignment completed.

























