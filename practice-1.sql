-- Creating Practice DB
create database practicedb;

-- use practicedb
use practicedb;

#1.  Query all columns for all American cities in theCITY table with populations larger than 100000. The CountryCode for America is USA.
CREATE TABLE CITY (
    ID INT PRIMARY KEY,
    NAME VARCHAR(17),
    COUNTRYCODE CHAR(3),
    DISTRICT VARCHAR(20),
    POPULATION INT
);

INSERT INTO CITY VALUES (1, 'New York', 'USA', 'New York', 8405837);
INSERT INTO CITY VALUES (2, 'Los Angeles', 'USA', 'California', 3884307);
INSERT INTO CITY VALUES (3, 'Chicago', 'USA', 'Illinois', 2718782);
INSERT INTO CITY VALUES (4, 'Houston', 'USA', 'Texas', 2195914);
INSERT INTO CITY VALUES (7, 'Austin', 'USA', 'Texas', 885400);
INSERT INTO CITY VALUES (8, 'Orlando', 'USA', 'Florida', 238300);
INSERT INTO CITY VALUES (9, 'Paris', 'FRA', 'Île-de-France', 2140526);
INSERT INTO CITY VALUES (10, 'London', 'GBR', 'England', 8787892);

select * from city where population > 100000 and countrycode = 'USA';

# 2. Query the NAME field for all American cities inthe CITY table with populations larger than 120000. The CountryCode for America is USA
select name from city where population > 120000 and countrycode = 'USA';

# 3. Query all columns (attributes) for every row in the CITY table.
select * from city;

# 4. Query all columns for a city in CITY with theID 1661
select * from city where ID = 1661

# 5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN
select name from city where countrycode = 'JPN';

# 6. Query a list of CITY names from city  for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer
select distinct(name),id  from city where id%2 = 0 order by id ;

# 7. Query the two cities in city  with the shortestand longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically
( SELECT NAME, LENGTH(NAME) AS LEN FROM CITY ORDER BY LENGTH(NAME) ASC, NAME DESC LIMIT 1)
UNION
( SELECT NAME, LENGTH(NAME) AS LEN FROM CITY ORDER BY LENGTH(NAME) DESC, NAME DESC LIMIT 1);

# 8. Query the list of CITY names starting with vowels(i.e., a, e, i, o, or u) . Your result cannot contain duplicates.
select distinct name from city where name regexp  '^[AEIOUaeiou]'

# 9. Query the list of CITY names ending with vowels(a, e, i, o, u) . Your result cannot contain duplicates.
select distinct name from city where name regexp  '[AEIOUaeiou]$'

# 10. Query the list of CITY that does not start and end with vowel (a, e, i, o, u) . Your result cannot contain duplicates.
select distinct name from city where name not regexp  '[AEIOUaeiou]$' and name not regexp '^[AEIOUaeiou]';