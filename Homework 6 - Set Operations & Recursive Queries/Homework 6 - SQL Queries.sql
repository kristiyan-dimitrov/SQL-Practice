 -- Query 1 - How many rows are in the friend table and how long (in seconds or ms) does it take to count them?

 SELECT COUNT(*)
  FROM friend;

ANSWER: "39846890"

Successfully run. Total query runtime: 1 secs 366 msec.

-- Query 2 - Find the name of the businesses for which there is a review that contains the case-insensitive text string “wing”
-- at least 25 times in the same review.
SELECT b.name, r.text
  FROM review AS r
  JOIN business AS b
    ON b.id = r.business_id
 WHERE LOWER(r.text) SIMILAR TO '(%wing%){25,}'

ANSWER:
"Wingstop"
"The Firehall Cool Bar Hot Grill"
"Buffalo Wild Wings"
"Puck'n Wings"
"Wing Time"

Successfully run. Total query runtime: 19 secs 449 msec.
5 rows affected.

-- Query 3 - Find the top 3 users that have provided the largest number of reviews of businesses within a range of 0.1 degrees
-- from latitude 36.0 and longitude -115.0. For each one of these users, provide in your answer the name and the
-- number of reviews that user provided for businesses within that range.							  
SELECT u.name, COUNT(r.id)
  FROM public.user AS u
  JOIN review AS r
    ON u.id = r.user_id
  JOIN business AS b
    ON b.id = r.business_id
 WHERE SQRT(POWER(36 - b.latitude,2) + POWER(-115 - b.longitude,2)) <= 0.1
 GROUP BY r.user_id, 1
 ORDER BY 2 DESC
 LIMIT 3;
	
ANSWER:
"Bonnie"	"227"
"Shirley"	"213"
"Bethany"	"209"

Successfully run. Total query runtime: 1 secs 383 msec.

-- Query 4 - What is the name, address (including city, state, postal code), and average rating of the highest-rated restaurant
-- with “McDonald” in its name?
SELECT b.name, b.address, b.city, b.state, b.postal_code, ROUND(AVG(r.stars),3) AS Avg_Rating
  FROM business AS b
  JOIN category AS c
    ON b.id = c.business_id
  JOIN review AS r
    ON r.business_id = b.id
 WHERE c.category = 'Restaurants' AND b.name LIKE '%McDonald%' -- AND b.id = 'x6LzkLGffOjnqTVPTWao-Q'
 GROUP BY 1,2,3,4,5
 ORDER BY 6 DESC
 LIMIT 1;

ANSWER:
"McDonald's McCafe"	"100 King Street W, Exchange Tower"	"Toronto"	"ON"	"M5X 2A2"	"4.833"

Successfully run. Total query runtime: 902 msec.

-- Query 5 - What are the names of the businesses for which there are at least 5 reviews where each one of these reviews
-- contains the text “barf”?

SELECT b.name, COUNT(r.id) AS numberOfReviews
  FROM business AS b
  JOIN review AS r
    ON r.business_id = b.id
 WHERE r.text LIKE '%barf%'
 GROUP BY b.id
HAVING COUNT(r.id) > 4;

ANSWER:
--name 			    Number of reviews with barf
"Spirit Airlines"	"5"
"Wicked Spoon"		"5"

-- Query 6 - With execution timing on, find the name of the user with id 'CxDOIDnH8gp9KXzpBHJYXw'.
SELECT name
  FROM public.user
 WHERE id = 'CxDOIDnH8gp9KXzpBHJYXw'

 ANSWER: "Jennifer"

 Successfully run. Total query runtime: 92 msec.

-- Query 7 - With execution timing on, find the name of the user with 3336 compliment_plain compliments.

SELECT name
  FROM public.user
 WHERE compliment_plain = 3336

ANSWER:
"Jennifer"	3336

Successfully run. Total query runtime: 159 msec.

-- Query 8 - Which query is faster, query 6 or query 7, and by how much? Also, please explain why it is faster.

-- ## Query 6 is faster by more than 50%. This is because there is an index on it, which speeds up the probe query!

-- Query 9 - Find the name of the user that has given the largest number of useful reviews to closed businesses. Print both the
-- user name and the number of such reviews the user has given.

SELECT u.name, COUNT(r.id)
  FROM public.user AS u
  JOIN review AS r
    ON u.id = r.user_id
  JOIN business AS b
    ON b.id = r.business_id
 WHERE b.is_open = 0 AND r.useful > 0
 GROUP BY u.id
 ORDER BY 2 DESC
 LIMIT 1;

ANSWER: "Jennifer"	"716"

Successfully run. Total query runtime: 2 secs 311 msec.

-- -- Query 10 - You are tasked with doing some city planning, which requires that you find clusters of businesses that are
-- physically located very close to each other. Your first task is to find the IDs, names and GPS coordinates (latitude,
-- longitude) of businesses that are clustered around McDonald’s at address Av. Maip 2779. A business is considered
-- part of the cluster if it is within 0.005 degrees away from any other business in the cluster.

-- VERSION 1 - Didn't run due to syntax error at SOME
WITH RECURSIVE 
	cluster(id, name, latitude, longitude) AS
	(
		VALUES (SELECT id, name, latitude, longitude FROM business WHERE name = 'McDonald''s' AND address = 'Av. Maip 2779')
		
		 UNION
		
		SELECT b.id, b.name, b.latitude, b.longitude 
		  FROM business AS b
		 WHERE SQRT(POWER(SOME(SELECT latitude FROM cluster) - b.latitude,2) + POWER(SOME(SELECT longitude FROM cluster) - b.longitude,2)) <= 0.005
	)
	
	SELECT *
	  FROM cluster;


-- VERSION 2 - Ran with outout
WITH RECURSIVE 
	myCluster(id, name, latitude, longitude) AS
	(
		SELECT id, name, latitude, longitude 
		  FROM business 
		 WHERE name = 'McDonald''s' AND address = 'Av. Maip 2779'
		
		UNION
		
		SELECT b.id, b.name, b.latitude, b.longitude 
		  FROM business AS b, myCluster AS c
		 WHERE SQRT(POWER(c.latitude - b.latitude,2) + POWER(c.longitude - b.longitude,2)) <= 0.005
	)
	
	SELECT *
	  FROM myCluster;

ANSWER:
"softZjpREG65wpAns2FaWA"	"McDonald's"					"-34.51"	"-58.4911"
"bGxzQDGOTpab_6hdqsqv9g"	"Burger King"					"-34.5089"	"-58.4919"
"i1e8KsIy1ELvI7G6mvvZkw"	"Havanna"						"-34.5133"	"-58.4894"
"m-SUr48X9gMHtwvraM-KmA"	"Compaa del Sol"				"-34.5134"	"-58.4896"
"WNsimvxr-0NimM57I5gj4A"	"Arnaldo"						"-34.5137"	"-58.4888"
"yadScsa2pShYsQAVXbNivw"	"La Farola de Olivos"			"-34.5108"	"-58.4908"
"YBaWP2r64BPJazkmyf1fig"	"Almacn de Pizzas"				"-34.5089"	"-58.4916"
"zMAiU0s8ScUYHwAESCB8Qg"	"Prosciutto"					"-34.5122"	"-58.4898"
"4-xLjGavuWFqEfNuznxL3A"	"D' Lucky"						"-34.516"	"-58.4884"
"AwpX8mheEmMhaIuIqEhMkA"	"Estacin Mitre - Lnea Mitre"	"-34.515"	"-58.4897"
"Ss6J7HFhMCxoq7M8wXqc8A"	"Salve Bruna"					"-34.5159"	"-58.488"

-- VERSION 3 (Laurie's) - Runs with output

"softZjpREG65wpAns2FaWA"	"McDonald's"					"-34.51"	"-58.4911"
"bGxzQDGOTpab_6hdqsqv9g"	"Burger King"					"-34.5089"	"-58.4919"
"i1e8KsIy1ELvI7G6mvvZkw"	"Havanna"						"-34.5133"	"-58.4894"
"m-SUr48X9gMHtwvraM-KmA"	"Compaa del Sol"				"-34.5134"	"-58.4896"
"WNsimvxr-0NimM57I5gj4A"	"Arnaldo"						"-34.5137"	"-58.4888"
"yadScsa2pShYsQAVXbNivw"	"La Farola de Olivos"			"-34.5108"	"-58.4908"
"YBaWP2r64BPJazkmyf1fig"	"Almacn de Pizzas"				"-34.5089"	"-58.4916"
"zMAiU0s8ScUYHwAESCB8Qg"	"Prosciutto"					"-34.5122"	"-58.4898"
"4-xLjGavuWFqEfNuznxL3A"	"D' Lucky"						"-34.516"	"-58.4884"
"AwpX8mheEmMhaIuIqEhMkA"	"Estacin Mitre - Lnea Mitre"	"-34.515"	"-58.4897"
"Ss6J7HFhMCxoq7M8wXqc8A"	"Salve Bruna"					"-34.5159"	"-58.488"
