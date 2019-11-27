 -- Query 1 - Find the EntertainerID of the entertainers that have no engagements. You must use EXCEPT for full credit.
 SELECT Ent.EntertainerID
   FROM Entertainers AS Ent
   LEFT JOIN Engagements AS Eng
     ON Ent.EntertainerID = Eng.EntertainerID
 EXCEPT
 SELECT Ent.EntertainerID
   FROM Entertainers AS Ent
   LEFT JOIN Engagements AS Eng
     ON Ent.EntertainerID = Eng.EntertainerID
  WHERE Eng.EngagementNumber IS NOT NULL

ANSWER:
1009
 
 -- Query 2 - Find the EntertainerID and stage name of the entertainers that have no engagements. 
 -- Your answer must be a single query with no subqueries. You must not directly use the result of question (1) above

 SELECT Ent.EntertainerID, Ent.EntStageName
   FROM Entertainers AS Ent
   LEFT JOIN Engagements AS Eng
     ON Ent.EntertainerID = Eng.EntertainerID
  WHERE EngagementNumber IS NULL

ANSWER:
1009	Katherine Ehrlich

-- Query 3 - For all customers that have less than 10 engagements, list the customer ID, full name (i.e., a string
-- containing the customer’s first name followed by the last name with a space in between), and number of
-- engagements, in ascending order of number of engagements. Your answer must be a single query with no
-- subqueries.							  

 SELECT C.CustomerID, C.CustFirstName || " " || C.CustLastName AS Customer_Full_Name, COUNT(*) AS Number_of_Engagements
   FROM Customers AS C
NATURAL JOIN Engagements AS E
  GROUP BY C.CustomerID
 HAVING COUNT(*) < 10
  ORDER BY 3

ANSWER:
10013	Estella Pundt		6
10003	Peter Brehm			7
10007	Liz Keyser			7
10012	Kerry Patterson		7
10015	Carol Viescas		7
10001	Doris Hartwig		8
10005	Elizabeth Hallmark	8
10009	Sarah Thompson		8
10006	Matt Berg			9		

-- Query 4 - Using a single query, identify the members that have not been assigned a gender and update their
-- gender to male. The updated table will be used to answer later questions in this homework

 UPDATE Members
    SET Gender = "M"
  WHERE Gender IS NULL

  ANSWER:
  Member ID 125, Jim Glynn has now been updated with Gender = "M"

-- Query 5 - Using the updated database/table from question (4), find the number of male and female members
-- (separate counts for each gender) for each entertainer. The output table should have the columns
-- EntertainerID, Gender, and GenderCount. The query must use the UNION operator.

-- VERSION 1
SELECT E.EntertainerID, M.Gender, Count(M.MemberID) AS GenderCount
  FROM Entertainers AS E
 NATURAL JOIN Entertainer_Members AS E_M
 NATURAL JOIN Members AS M
 WHERE M.Gender = "M"
 GROUP BY E.EntertainerID

 UNION
 
 SELECT E.EntertainerID, M.Gender, Count(M.MemberID) AS GenderCount
  FROM Entertainers AS E
 NATURAL JOIN Entertainer_Members AS E_M
 NATURAL JOIN Members AS M
 WHERE M.Gender = "F"
 GROUP BY E.EntertainerID

 ANSWER 1:
1001	F	3
1002	F	1
1002	M	1
1003	F	1
1003	M	5
1004	M	1
1005	F	1
1005	M	2
1006	F	1
1006	M	3
1007	F	3
1007	M	2
1008	F	1
1008	M	4
1009	F	1
1010	F	4
1011	F	1
1012	F	1
1013	F	2
1013	M	2

-- VERSION 2 - NOT CORRECT
-- SELECT E.EntertainerID, M.Gender, SUM(M.Gender = "M") AS GenderCount
--   FROM Entertainers AS E
--  NATURAL JOIN Entertainer_Members AS E_M
--  NATURAL JOIN Members AS M
--  GROUP BY E.EntertainerID

--  UNION
 
--  SELECT E.EntertainerID, M.Gender, SUM(M.Gender = "F") AS GenderCount
--   FROM Entertainers AS E
--  NATURAL JOIN Entertainer_Members AS E_M
--  NATURAL JOIN Members AS M
--  GROUP BY E.EntertainerID

-- ANSWER 2:
-- 1001	F	0
-- 1001	F	3
-- 1002	M	1
-- 1003	F	1
-- 1003	F	5
-- 1004	M	0
-- 1004	M	1
-- 1005	M	1
-- 1005	M	2
-- 1006	M	1
-- 1006	M	3
-- 1007	M	2
-- 1007	M	3
-- 1008	M	1
-- 1008	M	4
-- 1009	F	0
-- 1009	F	1
-- 1010	F	0
-- 1010	F	4
-- 1011	F	0
-- 1011	F	1
-- 1012	F	0
-- 1012	F	1
-- 1013	F	2

-- Query 6 - Write a query to answer question (5) above, but this time the query must not use a set operation
-- and it must use a natural join. Hint: GROUP BY can take multiple columns as arguments.

SELECT E.EntertainerID, M.Gender, Count(*) AS GenderCount
  FROM Entertainers AS E
 NATURAL JOIN Entertainer_Members AS E_M
 NATURAL JOIN Members AS M
 GROUP BY E.EntertainerID, M.Gender

 ANSWER:
1001	F	3
1002	F	1
1002	M	1
1003	F	1
1003	M	5
1004	M	1
1005	F	1
1005	M	2
1006	F	1
1006	M	3
1007	F	3
1007	M	2
1008	F	1
1008	M	4
1009	F	1
1010	F	4
1011	F	1
1012	F	1
1013	F	2
1013	M	2

-- Query 7 - You want to classify each entertainer as follows:
-- • Super Band (if it has more than 10 engagements)
-- • Regular Band (if it has more than 7 but no more than 10 engagements)
-- • Support Band (if it has at least one engagement, but no more than 7), and
-- • Amateur Band (if it has no engagements)
-- Write the query that makes this classification and returns the class of the entertainer, the entertainer’s stage
-- name, and the number of engagements, with the entertainers appearing in descending rank (i.e., super bands
-- first, followed by regular bands, then support bands, and amateurs at the bottom). Your answer must be a
-- single query with no subqueries.

SELECT 	Ent.EntStageName, 
		(CASE WHEN COUNT(Eng.EngagementNumber) > 10 THEN "Super Band"
			  WHEN COUNT(Eng.EngagementNumber) > 7 THEN "Regular Band"
			  WHEN COUNT(Eng.EngagementNumber) > 0 THEN "SupportBand"
			  ELSE "Amateur Band" END) AS EntertainerClass,
		COUNT(Eng.EngagementNumber)
  FROM Entertainers AS Ent
  NATURAL LEFT JOIN Engagements AS Eng
  GROUP BY Ent.EntertainerID
  ORDER BY 3 DESC

ANSWER:
Country Feeling	Super Band					15
Carol Peacock Trio	Super Band				11
Caroline Coie Cuartet	Super Band			11
JV & the Deep Six	Regular Band			10
Modern Dance	Regular Band				10
Jim Glynn	Regular Band					9
Saturday Revue	Regular Band				9
Coldwater Cattle Company	Regular Band	8
Julia Schnebly	Regular Band				8
Topazz	SupportBand							7
Jazz Persuasion	SupportBand					7
Susan McLain	SupportBand					6
Katherine Ehrlich	Amateur Band			0

-- Part B
-- Creating Tables
DROP TABLE media_types, genre, artist, Customer, Invoice, album, tracks, Invoice_items;


CREATE TABLE media_types ( mediaTypeId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
					   mediaName nvarchar(20));

CREATE TABLE genre ( genreId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
					genreName nvarchar(25));

CREATE TABLE artist ( artistId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
					artistName nvarchar(90) UNIQUE);

CREATE TABLE Customer (customerId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
						firstName nvarchar(20) NOT NULL,
						lastName nvarchar (20) NOT NULL UNIQUE,
						address nvarchar(50),
						city nvarchar(25),
						state nvarchar(10),
						country nvarchar(20),
						postalCode nvarchar(20),
						phoneNumber nvarchar(40),
						faxNumber nvarchar(40),
						email nvarchar(40) NOT NULL);


CREATE TABLE Invoice (InvoiceId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
						Date nvarchar(50) NOT NULL,
						billingAddress nvarchar(50),
						billingCity nvarchar(30),
						billingState nvarchar(20),
						billingCountry nvarchar(30),
						billingPostalCode nvarchar(20),
						customerId INTEGER NOT NULL REFERENCES Customer(customerId));


CREATE TABLE album (albumId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
				albumTitle nvarchar(100) NOT NULL,
				artistId INTEGER NOT NULL REFERENCES artist(artistId),
				);


CREATE TABLE tracks (trackId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
					trackName nvarchar(130) NOT NULL,
					composer nvarchar(200),
					trackSizeByte INTEGER,
					trackLength INTEGER NOT NULL,
					trackprice REAL NOT NULL,
					genreId INTEGER NOT NULL REFERENCES genre(genreId),
					mediaTypeId INTEGER NOT NULL REFERENCES media_types(mediaTypeId),
					albumId INTEGER NOT NULL REFERENCES album(albumId),
					UNIQUE (trackName, trackLength)
					);



CREATE TABLE Invoice_items (InvoiceItemId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
						InvoiceId INTEGER REFERENCES Invoice(InvoiceId),
						trackId INTEGER NOT NULL REFERENCES tracks(trackId),
						quantity INTEGER NOT NULL,
						unitPrice REAL NOT NULL
						);


-- ^^^^^^^^^^ INSERTING VALUES ^^^^^^^^^
INSERT INTO media_Types (mediaName) 
SELECT DISTINCT MediaType FROM hw5_original;

INSERT INTO genre (genreName) 
SELECT DISTINCT Genre FROM hw5_original;

INSERT INTO artist(artistName) 
SELECT DISTINCT ArtistName FROM hw5_original;

INSERT INTO Customer(firstName, lastName, address, city, state, country,postalCode, phoneNumber, faxNumber,email) 
SELECT DISTINCT CustomerFirstName, CustomerLastName, CustomerAddress, CustomerCity, CustomerState, CustomerCountry, CustomerPostalCode, CustomerPhone, CustomerFax, CustomerEmail 
FROM hw5_original WHERE CustomerFirstName IS NOT NULL;

INSERT INTO album(albumTitle, artistId) 
SELECT DISTINCT HW.AlbumTitle, A.artistId 
FROM hw5_original AS HW JOIN artist AS A ON A.artistName = HW.ArtistName;

INSERT INTO Invoice(Date, billingAddress, billingCity, billingState, billingCountry, billingPostalCode, customerId) 
SELECT DISTINCT HW.InvoiceDate, HW.InvoiceBillingAddress, HW.InvoiceBillingCity, HW.InvoiceBillingState, HW.InvoiceBillingCountry, HW.InvoiceBillingPostalCode, C.customerId 
FROM Customer AS C JOIN hw5_original AS HW ON C.lastName = HW.CustomerLastName;

INSERT INTO tracks(trackName, composer,trackSizeByte, trackLength, trackprice, genreId, mediaTypeId, albumId) 
SELECT DISTINCT HW.TrackName, HW.Composer, HW.TrackSizeBytes, HW.TrackLength, HW.TrackPrice , genre.genreId, media_types.mediaTypeId, album.albumId 
FROM hw5_original AS HW JOIN album ON album.albumTitle = HW.AlbumTitle JOIN genre ON genre.genreName = HW.Genre JOIN media_types ON media_types.mediaName = HW.MediaType 
;

 INSERT INTO Invoice_items(InvoiceId,trackId,quantity,unitPrice) 
SELECT DISTINCT I.InvoiceId, T.TrackId, H.InvoiceItemQuantity, H.InvoiceItemUnitPrice
FROM hw5_original AS H
JOIN Customer as C
ON (H.CustomerLastName = C.lastName)
JOIN Invoice as I
ON (H.InvoiceDate = I.date) AND (H.InvoiceBillingAddress = I.billingAddress) AND (I.customerId = C.CustomerId)
JOIN Tracks as T
ON (H.trackName = T.trackName) AND (H.trackLength = T.trackLength);

-- Query 9 - Find the best-selling artist and 
-- how much customers spent in buying this artist’s songs, based on
-- the normalized database that you created and populated in the previous question

SELECT artist.artistName, SUM(IT.quantity * IT.unitPrice) AS Sales
FROM  Invoice_items AS IT
NATURAL JOIN tracks
NATURAL JOIN album
NATURAL JOIN artist
GROUP BY artist.artistId
ORDER BY Sales DESC
LIMIT 1

ANSWER:
Iron Maiden	138.6




















