NOTES:
- Q4 - 2 versions, think we need 2nd - Can we use Case WHEN and is there a way (please give hint) for not using case when
#  - It;s ok to use Case when but you don't necessarily need to; You can just use boolean expression; Also you have an excessive Join (you don't need the Entertainers table)
- Q10 - Different Answer (6, not 5) - What is the correct way to interpret problem, we assume you mean people with same family name, but different bowler ID on the same team (not across teams)
  # Laurie's way of interpreting things is the proper way.


- Q1 - Format
- Q6 - I have 1 redundant JOIN



# Query 1 - How many students are majoring in English or Mathematics? To receive credit you must not use subqueries
# anywhere (i.e., no nested SELECT clauses at all).
SELECT COUNT(*)
  FROM Majors AS M
  JOIN Students AS S
    ON M.MajorID == S.StudMajor
 WHERE M.Major IN ("English", "Mathematics")

ANSWER: 6

/* Query 2 - What is the full name of the instructor of the class that has the highest average students’ grade? Your output
should list the full name of the instructor, the Class ID, and the average students’ grade of that class. The full
name of the instructor can be formed by concatenating the last name, a comma, a space, and the first name.
For example, the full name of the professor in this MSiA-413 class is the string “Hardavellas, Nikos”. */

SELECT S.StfLastName || ", " || S.StfFirstName,  Student_Schedules.ClassID, AVG(Grade)
  FROM Faculty_Classes
  JOIN Staff AS S
    ON S.StaffID == Faculty_Classes.StaffID
  JOIN Student_Schedules
    ON Student_Schedules.ClassID == Faculty_Classes.ClassID
 GROUP BY Student_Schedules.ClassID
 ORDER BY AVG(Grade) DESC
 LIMIT 1

 ANSWER: 
 'StfLastName , StfFirstName, ClassID, AVG(Grade)'
     Waldal,         Deb        2410    93.6433333333333

/* Query 3
What is the percentage of students with majors in English or Mathematics? To receive full credit for this
question you must not use subqueries anywhere (i.e., no nested SELECT clauses at all). To receive partial
credit you must use the JOIN operator and you must not use subqueries in the WHERE clause (subqueries
elsewhere are fine).
*/
SELECT 100.0*AVG(M.Major == "English" OR M.Major == "Mathematics")
  FROM Students AS S
  JOIN Majors AS M
    ON S.StudMajor == M.MajorID

ANSWER: 33.3333

/* Query 4
What percentage of all entertainer members are male entertainer members whose musical style is Jazz, and
what percentage of all entertainer members are female entertainer members whose musical style is Jazz? You
should provide a single query that outputs the percentages of each gender separately and indicates which is
which. To receive full credit you must not use subqueries anywhere (i.e., no nested SELECT clauses at all).
To receive partial credit you must use the JOIN operator and you must not use subqueries in the FROM
and WHERE clauses (subqueries elsewhere are fine).
*/


-- !! NOTE !! many to many relationship exists between Entertainers & Members, as well as between Entertainers & Styles
-- !! NOTE !! There is one Member whose Gender is NULL - How is that affecting the mean calculation? His name is Jim Glynn

SELECT
100.0*AVG(CASE WHEN  M_S.StyleName == "Jazz"
		THEN 1
		ELSE 0
		END) AS Percent_Entertainer_Members_With_Jazz_Musical_Style

FROM Entertainers AS E
  JOIN Entertainer_Members AS E_M
    ON E.EntertainerID == E_M.EntertainerID
  JOIN Members AS M
    ON E_M.MemberID == M.MemberID
  JOIN Entertainer_Styles AS E_S
    ON E_S.EntertainerID == E.EntertainerID
  JOIN Musical_Styles AS M_S
    ON M_S.StyleID == E_S.StyleID
GROUP BY M.Gender

ANSWER:
NULL	0.0
F	5.76923076923077
M	9.09090909090909

-- I think, however, this is percent of all Men (not all members) with preference Jazz and percent of all Women with preference Jazz.
-- Maybe the below solves for this:
SELECT
100.0*AVG(M.Gender == "M" AND M_S.StyleName == "Jazz") AS Percent_Male_Entertainer_Members_With_Jazz_Musical_Style,
100.0*AVG(M.Gender == "F" AND M_S.StyleName == "Jazz") AS Percent_Female_Entertainer_Members_With_Jazz_Musical_Style

  FROM Entertainer_Members AS E_M
  JOIN Members AS M
    ON E_M.MemberID == M.MemberID
  JOIN Entertainer_Styles AS E_S
    ON E_S.EntertainerID == E_M.EntertainerID
  JOIN Musical_Styles AS M_S
    ON M_S.StyleID == E_S.StyleID

 ANSWER: 
Percent_Male_Entertainer_Members_With_Jazz_Musical_Style, Percent_Female_Entertainer_Members_With_Jazz_Musical_Style
 					4.12371134020619						                    3.09278350515464

 /*
Query 5
What is the full name (in the form “LastName, FirstName”) of the top 3 agents who have the highest average
commission per engagement? The commission can be calculated by multiplying the contract price with the
agent’s commission rate. To receive credit you must not use subqueries anywhere (i.e., no nested SELECT
clauses at all).
 */
SELECT A.AgtLastName || " " || A.AgtFirstName --AVG(A.CommissionRate*E.ContractPrice) AS Avg_Commission_per_Engagement
  FROM Agents AS A
  JOIN Engagements AS E
    ON A.AgentID == E.AgentID
 GROUP BY  A.AgtLastName, A.AgtFirstName
 ORDER BY Avg_Commission_per_Engagement DESC
 LIMIT 3

 ANSWER:
Kennedy	John
Viescas	Carol
Smith	Karen


/*
Query 6
What is the total income of the Jazz entertainers (i.e., the sum of all Jazz entertainers’ income across all of
their engagements) and the total income of the Salsa entertainers? The income of each entertainer for each
engagement is the ContractPrice of the engagement minus the agent’s commission. To receive credit you
must not use subqueries anywhere (i.e., no nested SELECT clauses at all).
*/

SELECT M_S.StyleName,  SUM(Eng.ContractPrice*(1-A.CommissionRate)) AS Total_Income
  FROM Entertainer_Styles AS E_S
  JOIN Musical_Styles AS M_S
    ON E_S.StyleID == M_S.StyleID
  JOIN Engagements AS Eng
    ON Eng.EntertainerID == Ent.EntertainerID
  JOIN Agents AS A
    ON A.AgentID = Eng.AgentID
 GROUP BY M_S.StyleName
HAVING M_S.StyleName == "Salsa" OR M_S.StyleName == "Jazz"

ANSWER:
Jazz	19623.3
Salsa	19115.7

/*
Query 7
What are the top 5 musical styles that have the highest number of unique customers, and how many customers
each of these styles has? To receive credit you must not use subqueries anywhere (i.e., no nested SELECT
clauses at all).
*/

SELECT COUNT(DISTINCT P.CustomerID) AS Number_Of_Unique_Customers, S.StyleName
  FROM Musical_Preferences AS P
  JOIN Musical_Styles AS S
    ON P.StyleID == S.StyleID
 GROUP BY S.StyleName
 ORDER BY 1 DESC
 LIMIT 5

 ANSWER:
-- #   Style Name
-- 4	Standards
-- 3	Contemporary
-- 3	Jazz
-- 3	Rhythm and Blues
-- 2	40's Ballroom Music

-- I think, however there are multiple styles tied with 2 customers so this is not representative

/*
Query 8
Which teams have captains with the same last name? Each such team must be listed exactly once, along with
the team captain’s full name (in the form “LastName, FirstName”). To receive full credit you must not use
subqueries anywhere (i.e., no nested SELECT clauses at all).
*/

SELECT T.TeamName, B.BowlerLastName || " " || B.BowlerFirstName AS Captain_Full_Name
  FROM Teams AS T
  JOIN Bowlers AS B
    ON T.TeamID == B.TeamID
  JOIN Teams AS T2
    ON T2.TeamID == B2.TeamID
  JOIN Bowlers AS B2
    ON B2.BowlerLastName == B.BowlerLastName
 WHERE T.CaptainID == B.BowlerID AND T2.CaptainID == B2.BowlerID AND T.TeamName != T2.TeamName

 ANSWER:
Dolphins	Viescas Suzanne
Manatees	Viescas Michael

/*
Query 9
In question #8 you identified the bowling teams that have captains with the same last name. List all the games
in which any of these teams participates. The output should provide the TourneyDate, TourneyLocation, odd
and even Team Names, and Lanes. You can use the team names identified in question #8 here to make the
query easier. To receive credit you must not use subqueries anywhere (i.e., no nested SELECT clauses at all).
*/

-- Writing in Team names literally:
SELECT TS.TourneyDate, TS.TourneyLocation, T_Odd.TeamName AS OddTeam, T_Even.TeamName AS EvenTeam, TM.Lanes 
  FROM Tourney_Matches AS TM 
  JOIN Tournaments AS TS 
    ON TS.TourneyID = TM.TourneyID 
  JOIN Teams AS  T_Odd 
    ON TM.OddLaneTeamID = T_Odd.TeamID 
  JOIN Teams AS T_Even 
    ON TM.EvenLaneTeamID = T_Even.TeamID 
 WHERE ((T_Odd.TeamName IN ("Dolphins", "Manatees")) OR (T_Even.TeamName IN ("Dolphins", "Manatees"))) 

/*
Query 10
How many teams have different players with the same last name? To receive credit you must not use
subqueries anywhere (i.e., no nested SELECT clauses at all).
*/

SELECT COUNT(DISTINCT(T.TeamName))
  FROM Teams as T 
  JOIN Bowlers as B 
    ON T.TeamID = B.TeamID
  JOIN Bowlers as B2 
    ON ((B2.BowlerLastName = B.BowlerLastName) AND (B2.TeamID = T.TeamID))
 WHERE NOT B.BowlerID  = B2.BowlerID

ANSWER: 5

-- WRONG INTERPRETATION OF QUESTION
-- Only 2 teams not present: Terrapins w/ the Morgensterns family name and the Marlins (not sure with which family name)

SELECT COUNT(DISTINCT T1.TeamID) -- ,T1.TeamID, T1.TeamName, B1.BowlerID, B1.BowlerLastName, B1.BowlerFirstName, T2.TeamID, T2.TeamName, B2.BowlerID, B2.BowlerLastName, B2.BowlerFirstName
  FROM Teams AS T1
  JOIN Bowlers AS B1
    ON T1.TeamID == B1.TeamID
  JOIN Teams AS T2
    ON T2.TeamID == B2.TeamID
  JOIN Bowlers AS B2
    ON B2.BowlerLastName == B1.BowlerLastName
WHERE B1.BowlerID != B2.BowlerID AND T1.TeamID != T2.TeamID

ANSWER:
6

Last Name: Patterson --> Sharks, Barracudas, Manatees, Swordfish (Unique 4)
Last Name: Viescas --> Dolphins, Sharks (+1 Unique = 5)
Last Name: Hallmark --> Barracudas, Orcas, Swordfish (+1 Unique = 6)

