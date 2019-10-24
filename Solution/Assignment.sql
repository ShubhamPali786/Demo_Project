
#1.Create a new table named 'bajaj1' containing the date, 
#close price, 20 Day MA and 50 Day MA. (This has to be done for all 6 stocks)

#Convert String Date to Date Format
UPDATE bajajauto
SET `Date`=str_to_date(`Date`,'%d-%M-%Y');

#Table Creation
CREATE TABLE
 bajaj1 as (
 SELECT `Date`, `Close Price`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 19 PRECEDING ) as `20 Day MA`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 49 PRECEDING ) as `50 Day MA`
	FROM bajajauto where `Date` is not null and `Close Price` is not null 
 );
 
#Changing Data Type of column
 ALTER TABLE bajaj1
 MODIFY `20 Day MA` FLOAT(10,4),
 MODIFY `50 Day MA` FLOAT(10,4);

#Defining Primary Key
 ALTER TABLE bajaj1
 MODIFY `Date` date PRIMARY KEY;

 #Convert String Date to Date Format
 UPDATE eichermotors
 SET Date=str_to_date(`Date`,'%d-%M-%Y');

 #Table Creation
 CREATE TABLE eichermotors1 as(
 SELECT `Date`, `Close Price`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 19 PRECEDING ) as `20 Day MA`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 49 PRECEDING ) as `50 Day MA`
	FROM eichermotors where `Date` is not null and `Close Price` is not null 
 );
 
 #Updating Data type of Date column 
 ALTER TABLE eichermotors1
 MODIFY `Date` date PRIMARY KEY;
 
 #Changing Data Type of column
 ALTER TABLE eichermotors1
 MODIFY `20 Day MA` FLOAT(10,4),
 MODIFY `50 Day MA` FLOAT(10,4);
 
 #Convert String Date to Date Format
 UPDATE heromotocorp
 SET Date=str_to_date(`Date`,'%d-%M-%Y');
 
 #Table Creation
 CREATE TABLE heromotocorp1 as(
 SELECT `Date`, `Close Price`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 19 PRECEDING ) as `20 Day MA`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 49 PRECEDING ) as `50 Day MA`
	FROM heromotocorp where `Date` is not null and `Close Price` is not null 
 );

 #Defining Primary Key
 ALTER TABLE heromotocorp1
 MODIFY `Date` date PRIMARY KEY;
 
 #Changing Data Type of column
 ALTER TABLE heromotocorp1
 MODIFY `20 Day MA` FLOAT(10,4),
 MODIFY `50 Day MA` FLOAT(10,4);
 
 
 #Convert String Date to Date Format
 UPDATE infosys
 SET Date=str_to_date(`Date`,'%d-%M-%Y');
 
 #Table Creation
 CREATE TABLE infosys1 as(
 SELECT `Date`, `Close Price`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 19 PRECEDING ) as `20 Day MA`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 49 PRECEDING ) as `50 Day MA`
	FROM infosys where `Date` is not null and `Close Price` is not null 
 );
 
 #Defining Primary Key
 ALTER TABLE infosys1
 MODIFY `Date` date PRIMARY KEY;
 
 #Changing Data Type of column
 ALTER TABLE infosys1
 MODIFY `20 Day MA` FLOAT(10,4),
 MODIFY `50 Day MA` FLOAT(10,4);
 
 #Convert String Date to Date Format
 UPDATE tcs
 SET Date=str_to_date(`Date`,'%d-%M-%Y');
 
 #Table Creation
 CREATE TABLE tcs1 as(
 SELECT `Date`, `Close Price`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 19 PRECEDING ) as `20 Day MA`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 49 PRECEDING ) as `50 Day MA`
	FROM tcs where `Date` is not null and `Close Price` is not null 
 );
 
 #Defining Primary Key
 ALTER TABLE tcs1
 MODIFY `Date` date PRIMARY KEY;
 
 #Changing Data Type of column
 ALTER TABLE tcs1
 MODIFY `20 Day MA` FLOAT(10,4),
 MODIFY `50 Day MA` FLOAT(10,4);
 
 #Converting String Date to Date Format
 UPDATE tvsmotors
 SET Date=str_to_date(`Date`,'%d-%M-%Y');
 
 #Table Creation
 CREATE TABLE tvsmotors1 as(
 SELECT `Date`, `Close Price`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 19 PRECEDING ) as `20 Day MA`,
	AVG(`Close Price`) over(ORDER BY `Date` ROWS 49 PRECEDING ) as `50 Day MA`
	FROM tvsmotors where `Date` is not null and `Close Price` is not null 
 );
 
 #Defining Primary Key
 ALTER TABLE tvsmotors1
 MODIFY `Date` date PRIMARY KEY;
 
 #Changing Data Type of column
 ALTER TABLE tvsmotors1
 MODIFY `20 Day MA` FLOAT(10,4),
 MODIFY `50 Day MA` FLOAT(10,4);
 
##------------------------------------------------End Question 1------------------------------------------------## 

#2.Create a master table containing the date 
#and close price of all the six stocks. (Column header for the price is the name of the stock)

 DROP TABLE IF EXISTS `Master`;
 CREATE TABLE `Master` as (
 SELECT bajaj.`Date`,
 bajaj.`Close Price` as Bajaj,
 tcs.`Close Price` as TCS,
 tvsmotors.`Close Price` as TVS,
 infosys.`Close Price` as Infosys,
 eichermotors.`Close Price` as  Eicher,
 heromotocorp.`Close Price` as Hero         
 from 
 bajaj1 as bajaj INNER JOIN heromotocorp1 as heromotocorp on bajaj.Date = heromotocorp.Date
 INNER JOIN eichermotors1 as eichermotors on heromotocorp.Date = eichermotors.Date
 INNER JOIN infosys1 as infosys on eichermotors.Date = infosys.Date
 INNER JOIN tcs1 as tcs on infosys.Date = tcs.Date
 INNER JOIN tvsmotors1 as tvsmotors on tcs.Date = tvsmotors.Date
 );
 
##------------------------------------------------End Question 2------------------------------------------------## 

#3.Use the table created in Part(1) to generate buy and sell signal. 
#Store this in another table named 'bajaj2'. Perform this operation for all stocks.

 #Table Creation
 CREATE TABLE bajaj2(
 SELECT `Date`,`Close Price`,
 CASE
	WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`,1) over w  <  LAG(`50 Day MA`,1)  over w  THEN 'BUY'
    WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`,1) over w  >  LAG(`50 Day MA`,1)  over w  THEN 'SELL'
    ELSE 'HOLD' 
 END as `Signal`
 from bajaj1 
 WINDOW w AS(ORDER BY `Date`)
 );
 
 #Table Creation
 CREATE TABLE eichermotors2(
 SELECT `Date`,`Close Price`,`20 Day MA`,`50 Day MA`,
 CASE
	WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`,1) over w <  LAG(`50 Day MA`,1)  over w  THEN 'BUY'
    WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`,1) over w >  LAG(`50 Day MA`,1)  over w  THEN 'SELL'
    ELSE 'HOLD' 
 END as `Signal`
 FROM eichermotors1 
 WINDOW w AS(ORDER BY `Date`)
 );
 
 #Table Creation
 CREATE TABLE heromotocorp2(
 SELECT `Date`,`Close Price`,
 CASE
	WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`,1) over w <  LAG(`50 Day MA`,1) over w  THEN 'BUY'
    WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`,1) over w >  LAG(`50 Day MA`,1) over w  THEN 'SELL'
    ELSE 'HOLD' 
 END as `Signal`
 FROM heromotocorp1
 WINDOW w AS(ORDER BY `Date`)
 );
 
 #Table Creation
 CREATE TABLE infosys2(
 SELECT `Date`,`Close Price`,
 CASE
	WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`,1) over w <  LAG(`50 Day MA`,1) over w  THEN 'BUY'
    WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`,1) over w >  LAG(`50 Day MA`,1) over w  THEN 'SELL'
    ELSE 'HOLD' 
 END as `Signal`
 FROM infosys1
 WINDOW w AS(ORDER BY `Date`)
 );
 
 #Table Creation
 CREATE TABLE tcs2(
 SELECT `Date`,`Close Price`,
 CASE
	WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`,1) over w <  LAG(`50 Day MA`,1) over w  THEN 'BUY'
    WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`,1) over w >  LAG(`50 Day MA`,1) over w  THEN 'SELL'
    ELSE 'HOLD' 
 END as `Signal`
 FROM tcs1 
 WINDOW w AS(ORDER BY `Date`)
 );
 
 #Table Creation
 CREATE TABLE tvsmotors2(
 SELECT `Date`,`Close Price`,
 CASE
	WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`,1) over w <  LAG(`50 Day MA`,1) OVER w  THEN 'BUY'
    WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`,1) over w >  LAG(`50 Day MA`,1) OVER w  THEN 'SELL'
    ELSE 'HOLD' 
 END as `Signal`
 FROM tvsmotors1 
 WINDOW w AS(ORDER BY `Date`)
 );
 
##------------------------------------------------End Question 3------------------------------------------------## 

#4.Create a User defined function, that takes the date as input and
# returns the signal for that particular day (Buy/Sell/Hold) for the Bajaj stock.

 DROP FUNCTION IF EXISTS SignalForDate;

 DELIMITER $$

 CREATE FUNCTION SignalForDate(userDate VARCHAR(200)) 
  RETURNS VARCHAR(4) 
  DETERMINISTIC
 BEGIN
 RETURN (SELECT `Signal` FROM bajaj2 WHERE `Date`= userDate);
 END
 $$
 DELIMITER ;

 #Call UDF :
 SELECT SignalForDate('2015-01-01') as `Signal`

##------------------------------------------------End Question 4------------------------------------------------## 

