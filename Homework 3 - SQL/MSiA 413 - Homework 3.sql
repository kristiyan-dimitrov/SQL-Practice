 -- Q1 How many students are majoring in English or Mathematics?
 SELECT COUNT(StudentID)
   FROM Students 
  WHERE StudMajor = (SELECT MajorID
   FROM Majors
  WHERE Major IN ("Mathematics", "English"))

ANSWER: 3

-- Q2 What is the percentage of students with majors in English or Mathematics? - CHECK
SELECT 100.00 * (SELECT COUNT(StudentID)
            FROM Students 
          WHERE StudMajor = (SELECT MajorID
                          FROM Majors
                          WHERE Major IN ("Mathematics", "English"))) / COUNT (StudentID)
FROM Students

ANSWER: 16.66666

-- Q3 How many unique last names does the staff have?
SELECT COUNT(DISTINCT StfLastName)
  FROM Staff  

ANSWER: 19

-- Q4 What is the minimum value of the average proficiency rating of the staff?
  SELECT MIN(Avg)
    FROM (SELECT AVG(ProficiencyRating) AS Avg
          FROM Faculty_Subjects
          GROUP BY StaffID);

ANSWER: 8.33333333

-- Q5 In the Staff table, which last names have a length longer than 9 characters?
 SELECT StfLastname
   FROM Staff
  WHERE StfLastname LIKE ("%__________%") -- There are 10 underscores

ANSWER: Bonnicksen, Rosales III

-- Q6 How many customers live in TX?

SELECT COUNT(*)
  FROM Customers
 WHERE CustState == "TX"

 ANSWER: 6

 -- Q7 What are the top 5 highest revenue amounts that product number 3 has ever generated in a sale? 
 -- MODIFY not to ttake order total(which incldues revenue from all products in a order), but to take only quantity * price quoted of product 3
 -- Do we take only distinct values or identical also count 

 
-- VERSION 1 (Don't care about Distinct revenue values)
SELECT QuotedPrice*QuantityOrdered AS Product_Revenue
  FROM Orders AS O
  JOIN Order_Details AS O_D
    ON O.OrderNumber = O_D.OrderNumber
 WHERE O_D.ProductNumber = 3
 ORDER BY Product_Revenue DESC
 LIMIT 5

  ANSWER:
        363.75
        225
        225
        225
        225

-- VERSION 2 (Care about Distinct revenue values)
SELECT DISTINCT QuotedPrice*QuantityOrdered AS Product_Revenue
  FROM Orders AS O
  JOIN Order_Details AS O_D
    ON O.OrderNumber = O_D.OrderNumber
 WHERE O_D.ProductNumber = 3
 ORDER BY Product_Revenue DESC
 LIMIT 5

  ANSWER:
         363.75
         225
         150
          75

  -- Q8 How many orders has a customer named Angel Kennedy placed so far?

SELECT COUNT(*)
  FROM Orders
 WHERE CustomerID = (SELECT CustomerID
                       FROM Customers
                      WHERE CustFirstName = "Angel" AND CustLastName = "Kennedy")

 ANSWER: 32

 -- Q9 What is the total revenue that a customer named Angel Kennedy has brought through product sales?

SELECT SUM(OrderTotal)
  FROM Orders
 WHERE CustomerID = (SELECT CustomerID
                       FROM Customers
                      WHERE CustFirstName = "Angel" AND CustLastName = "Kennedy")

 ANSWER: 186217.65

 -- Q10 In which state do most customers live? Report both the state name and the number of customers living in that state.

SELECT CustState, COUNT(CustomerID) AS Number
  FROM Customers
 GROUP BY CustState
 ORDER BY Number DESC
 LIMIT 1

 ANSWER: WA  11
















