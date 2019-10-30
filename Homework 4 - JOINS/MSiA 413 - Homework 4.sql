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

SELECT S.StaffID, S.StfLastName || ", " || S.StfFirstName,  Student_Schedules.ClassID, AVG(Grade)
  FROM Faculty_Classes
  JOIN Staff AS S
    ON S.StaffID == Faculty_Classes.StaffID
  JOIN Student_Schedules
    ON Student_Schedules.ClassID == Faculty_Classes.ClassID
 GROUP BY Student_Schedules.ClassID
 ORDER BY AVG(Grade) DESC
 LIMIT 1

 ANSWER: 
 'StaffID, StfLastName , StfFirstName, ClassID, AVG(Grade)'
   98013     Waldal,         Deb        2410    93.6433333333333
