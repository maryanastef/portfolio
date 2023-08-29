--SQL BASEBALL DATABASE WRITING QUERIES

use Summer_2022_BaseBall;
go

--1. Using the Pitching table, write a query that select the playerid, teamid, Wins (W), Loss (L) and Earned Run Average (ERA) for every player. 
SELECT playerid, teamid, w, l, era
FROM Pitching

--2. Modify the query you wrote in #1 to be sorted by playerid in descending order and the teamid in ascending order. 
SELECT playerid, teamid, w, l, era
FROM Pitching
ORDER BY playerid ASC, teamid DESC

--3. You decide you want to know the name of every team and the park they played in. Using the TEAMS table write a query that returns the team name (name) and the park name (park) sorted by the team name in ascending order. Your query should return only 1 row for each team name and park combination. 
SELECT DISTINCT name, park
FROM Teams
ORDER BY name ASC

--4. A friend wonders how many bases a player “touches” in a given year. Write a query using the BATTING that calculates the bases touched for each player and team they played for each year they played. Rename the calculated column Total_Bases_Touched. Your output should include the playerid, yearid and teamid in addition to the Total_Bases_Touched column. 
SELECT playerid, yearid, teamid, ((B2*2)+(B3*3)+(HR*4)+BB+H) as Total_Bases_Touched
FROM Batting

--5. Since we are in the New York area, we’re only interested in the NY teams, Modify the query you wrote for #4 by adding a where statement that only select the 2 NY teams, the Yankees and the Mets. Your results must be sorted by Total_Bases_Touched in descending order then by the playerid in ascending order.
SELECT playerid, yearid, teamid, ((B2*2)+(B3*3)+(HR*4)+BB+H) as Total_Bases_Touched
FROM Batting
WHERE teamid in ('NYA', 'NYN')
ORDER BY Total_Bases_Touched DESC, playerid ASC

--6. Your curious how a player’s “bases touched “compares to the teams for a given year. You do this by adding the Teams table to the query and calculating a Teams_Bases_Touched columns using the same formula for the H, HR, BB, B2 and B3 columns in the teams table. You also want to know the percentage of the teams touched bases each payer was responsible for. Calculated the Touched_% column and use the FORMAT statement for show the results as a % and with commas. Only select the 2 NY teams, the Yankees and the Mets so that only the information for the NY teams is returned. Write your query with a FROM statement that uses the format FROM BATTING, TEAMS. The FROM parameter should be in the format FROM table1, table2 and the join parameters need to be in the WHERE parameter. Your results should be sorted by Touched_% in descending order then by playerid in ascending order. 
SELECT B.playerID, B.yearid , B.teamid, ((B.B2*2)+(B.B3*3)+(B.HR*4)+B.BB+B.H) as Total_Bases_Touched, ((T.B2*2)+(T.B3*3)+(T.HR*4)+T.BB+T.H) as Teams_Total_Bases_Touched,
FORMAT((CONVERT(DECIMAL(7,2),(B.B2*2)+(B.B3*3)+(B.HR*4)+(B.BB+B.H))/CONVERT(DECIMAL(7,2),((T.B2*2)+(T.B3*3)+(T.HR*4)+T.BB+T.H))),'P' ) as Percent_Teams_Touched
FROM Batting B, Teams T
WHERE B.yearid = T.yearid AND B.teamid= T.teamid AND B.teamid IN ('NYA', 'NYN')
ORDER BY Percent_Teams_Touched DESC, B.playerid ASC;

--7. Rewrite the query in #6 using a JOIN parameter in the from statement. The results will be the same. 
SELECT B.playerID, B.yearid , T.teamid, ((B.B2*2)+(B.B3*3)+(B.HR*4)+B.BB+B.H) as Total_Bases_Touched, ((T.B2*2)+(T.B3*3)+(T.HR*4)+T.BB+T.H) as Teams_Total_Bases_Touched,
FORMAT((CONVERT(DECIMAL(7,2),(B.B2*2)+(B.B3*3)+(B.HR*4)+(B.BB+B.H))/CONVERT(DECIMAL(7,2),((T.B2*2)+(T.B3*3)+(T.HR*4)+T.BB+T.H))),'P' ) as Percent_Teams_Touched
FROM Batting B 
JOIN Teams T ON B.teamid = T.teamid
WHERE B.yearid = T.yearid and B.teamid IN ('NYA', 'NYN')
ORDER BY Total_Bases_Touched DESC, B.playerid ASC

--8. Using the PEOPLE table, write a query lists the playerid, the first, last and given names for all players that use their initials as their first name. Examples would be Thomas J. ( Tom ) Doran and David Jonathan ( J. D. ) Drew. Also, concatenate the nameGiven, nameFirst and nameLast into an additional single column called Full Name putting the nameFirst in parenthesis. For example: James (Jim) Markulic (Slide 35) and their batting average for each year. Batting Average is calculated using H/AB from the batting table. The batting_average needs to be formatted with 4 digits behind the decimal point.  Only select the Boston Red Sox and the NY Giants (teamids BOS and NY1). 
SELECT B.playerid, B.yearid, P.nameGiven + ' ( ' + P.nameFirst + ' ) ' + P.nameLast as [Full Name], CONVERT(decimal(5,4),(B.H*1.0/B.AB)) as [Batting Average]
FROM People P, Batting B
WHERE P.playerid = B.playerid and B.AB>0 and B.teamid IN ('BOS' , 'NY1')

--9. Using a Between clause in the where statement to return the same data as #8, but only where the batting averages that are between .2 and .4999. The results need also the teamid and yearid added and are to be sorted by batting_average in descending order and then playerid and yearid in ascending order. 
SELECT B.playerid, P.nameGiven + ' ( ' + P.nameFirst + ' ) ' + P.nameLast as [Full Name], t.yearid, t.teamid , convert(decimal(5,4),(B.H*1.0/B.AB)) as [Batting Average]
FROM People P, Batting B, Teams T
WHERE B.teamID = T.teamid and B.playerid = P.playerid and B.yearid = t.yearid and (B.H*1.0/B.AB) between .2 and .4999 and B.AB>0 and T.AB > 0 and T.teamid IN ('BOS', 'NY1') 
ORDER BY [Batting Average] DESC, P.playerid ASC, t.yearid ASC

--10. Now you decide to pull all the information you’ve developed together. Write a query that shows the player’s Total_bases_touched from question #5, the batting_averages from #9 (between .2and .4999) and the player’s name as formatted in #8. You also want to add the teamid and the team’s batting average for the year. The teams batting average should be calculated using the columns with the same names, but from the TEAMS table.  As a final piece of information, calculate the percentage of the team’s batting average divided by the player’s batting average. Also replace the Teamid with the team name in your ourput. Note, a percentage over 100% indicates the player is better than the average batter on the team.  Additionally, rename the tables to only use the first letter of the table so you can use that the select and where statement (ex: FROM TEAMS T). Order the results by batting average in descending order then playerid and yearid id ascending order. Also, eliminate any results where the player has an AB less than 50.
SELECT B.playerID, P.nameGiven + ' ( ' + P.NameFirst + ' ) ' + P.nameLast as [Full_Name],t.yearId,t.name,B.B2*2+B.B3*3+B.HR*4+B.BB+B.H as Total_Bases_Touched,
CONVERT(DECIMAL(5,4),(B.H*1.0/b.AB)) as [Player_Batting_Avg], CONVERT(DECIMAL(5,4),(T.H*1.0/T.AB)) as Teams_Batting_Avg, FORMAT((CONVERT(DECIMAL(5,4),(B.H*1.0/b.AB))/CONVERT(DECIMAL(5,4),(t.H*1.0/t.AB))),'P' ) as Percent_Team_Batting_AVG
FROM People P, Batting B, Teams T
WHERE B.teamID = T.teamid and B.playerid = P.playerID and B.yearid = T.yearid and (B.H*1.0/B.AB) between .2 and .4999 and T.AB > 0 and B.AB > 50
ORDER BY Player_Batting_Avg DESC, P.playerid ASC, B.yearID ASC


--11. Write a query that lists the playerid, birthcity, birthstate, Hits (H), At Bats (AB), salary and batting average for all players born in New Jersey sorted by first name and year in ascending order using the PEOPLE, SALARIES and BATTING tables. The joins must be made using the WHERE clause. 
SELECT P.playerid, birthcity, birthstate, B.teamid, H, AB, B.yearid , FORMAT(S.salary, 'C') AS salary, Convert(decimal(5,4),(B.H*1.0/AB)) as [Batting Average]
FROM People P, Salaries S, Batting B 
WHERE birthstate= 'NJ'
AND P.playerid=B.playerid 
AND P.playerid = S.playerid
AND B.AB > 0 
AND S.salary >0
AND S.yearid = B.yearid
AND S.teamid = B.teamid
ORDER BY nameFirst, B.yearid


--12. Write the same query as 11 but Using LEFT JOIN 
SELECT P.playerid, birthcity, birthstate, B.yearid, FORMAT(S.salary, 'C') AS salary, Convert(decimal(5,4),(B.H*1.0/AB)) as [Batting Average]
FROM People P 
LEFT JOIN Batting B ON B.playerid=P.playerid 
LEFT JOIN Salaries S ON S.playerid=P.playerid  
WHERE birthstate IN ('NJ') and AB >0
ORDER BY salary DESC, nameFirst ASC, B.yearid ASC


--13. You get into a debate regarding the level of school that professional sports players attend. Your stance is that there are plenty of baseball players who attended Ivy League schools and were good batters in addition to being scholars. Write a query to support your argument using the CollegePlaying and HallofFame tables. You must use an IN clause in the WHERE clause to identify the Ivy League schools. Only include players that were indicted into the HallofFame (Inducted = Y). Note the yearid is the year for the batting average not the year in College Playing. The colleges in the Ivy League are Brown, Columbia, Cornell, Dartmouth, Harvard, Princeton, UPenn, and Yale. You will need to use the HallofFame and COLLEGEPLAYING tables.
SELECT DISTINCT P.playerid, schoolid, B.yearid, Convert(decimal(5,4),(H*1.0/AB)) as [Batting Average]
FROM People P, CollegePlaying C, HallofFame H, Batting B
WHERE P.playerid = C.playerid and P.playerid=B.playerid
AND C.schoolid IN ('brown', 'columbia', 'cornell', 'dartmouth', 'harvard', 'princeton', 'upenn', 'yale')
AND B.AB > 0
AND (H*.1/AB) < 0.4 
AND H.Inducted = 'Y'
AND P.playerid=B.playerid
AND P.playerid = C.playerid
AND B.yearid = C.yearid
ORDER BY [Batting Average] DESC


--14. You are now interested in the longevity of players careers. Using the BATTING table and the appropriate SET clause, find the players that played for the same teams in 2016 and 2021. Your query only needs to return the playerid and teamids. 
SELECT playerid, teamid
FROM  Appearances
WHERE yearid=2016
INTERSECT
SELECT playerid, teamid
FROM Appearances
WHERE yearid=2021


--15. Using the BATTING table and the appropriate SET clause, find the players that played for the different teams in 2016 and 2021 Your query only needs to return the playerids and the 2016 teamid. 
SELECT playerid, teamid
FROM  Appearances
WHERE yearid=2016
EXCEPT
SELECT playerid, teamid
FROM Appearances
WHERE yearid=2021


--16. Using the Salaries table, calculate the average and total salary for each player. Make sure the amounts are properly formatted and sorted by the total salary in descending order. 
SELECT playerid, FORMAT(AVG(salary), 'C') as [Average Salary], FORMAT(SUM(salary), 'C') as [Total Salary] 
FROM Salaries
GROUP BY playerid
ORDER BY playerid


--17. Using the Batting and People tables and a HAVING clause, write a query that lists the playerid, the players full name, the number of home runs (HR) for all players having more than 400 home runs and the number of years they played. 
SELECT P.playerID, concat(P.nameFirst,P.nameLast) as [Full Name], SUM(B.HR) as [Total HR], (MAX(B.yearID)-MIN(B.yearID))+1 as [Years Played]
FROM People P
JOIN Batting B ON P.playerID = B.playerID
GROUP BY P.playerID,concat(P.nameFirst,P.nameLast)
HAVING SUM(B.HR) > 400


--18. Hitting 500 home runs is a hallmark achievement in baseball. You want to project if the players with under 500 but more than 400 home runs will have over 500 home runs, assuming they will play for a total of 22 years. To create your estimates, divide the total number of home runs by the years played and multiply by 22. Use a BETWEEN clause in the HAVING statement to identify players having between 400 and 499 home runs.  Only include playeris you estimate will reach the 500 HR goal. 
SELECT P.playerID, concat(P.nameFirst,P.nameLast) as [Full Name], SUM(B.HR) as [Total HR], (MAX(B.yearID)-MIN(B.yearID))+1 as [Years Played]
FROM People P
JOIN Batting B ON P.playerID = B.playerID
GROUP BY P.playerID,concat(P.nameFirst,P.nameLast)
HAVING (SUM(B.HR) between 400 and 499) and (MAX(B.yearID)-MIN(B.yearID))+1>=22


--19. Using a subquery along with an IN clause in the WHERE statement, write a query that identifies all the playerids, the players full name and the team names who in 2021 that were playing on teams that existed prior to 1910. You should use the appearances table to identify the players years and the TEAMS table to identify the team name. Sort your results by players last name. 
SELECT A.playerID, CONCAT(nameFirst,' ',nameLast) AS [Full Name], Teams.name as [Team Name]
FROM Appearances A
JOIN Teams ON Teams.teamid = A.teamid 
JOIN People ON People.playerID=A.playerID
WHERE  A.yearid = 2021
AND Teams.yearid < 1910
ORDER BY nameLast


--20. Using the Salaries table, find the players full name, average salary and the last year they played for each team they played for during their career. Also find the difference between the players salary and the average team salary. You must use subqueries in the FROM statement to get the team and player average salaries and calculate the difference in the SELECT statement. Sort your answer by the last year in descending order , the difference in descending order and the playerid in ascending order.
SELECT Person.playerID, [Full Name], t.teamID, [Last Year], 
format([Player Average], 'c') AS 'Last Year	Player Average',
format([Team Average], 'C') AS 'Team Average', 
format([Player Average]-[Team Average], 'C') AS 'Difference'
FROM (SELECT teamID, avg(salary) AS [Team Average] 
FROM Salaries GROUP BY teamID) t,
(SELECT teamID, playerID, avg(salary) AS [Player Average], max(yearId) AS [Last Year]
FROM Salaries GROUP BY teamID, playerID) p,
(SELECT playerID, namegiven + ' (' + namefirst + ') ' + namelast AS [Full Name]
FROM People GROUP BY playerID, namegiven + ' (' + namefirst + ') ' + namelast ) Person
WHERE t.teamID = p.teamID
AND Person.playerID = p.playerID
ORDER BY playerId, [Last Year] DESC


--21. Rewrite the query using a WITH statement for the subqueries instead of having the subqueries in the from statement.
With t AS
(SELECT teamID, avg(salary) AS [Team Average] FROM Salaries GROUP BY teamID),
p AS
(SELECT teamID, playerID, avg(salary) AS [Player Average], max(yearId) AS [Last Year]
FROM Salaries GROUP BY teamID, playerID),
person AS
(SELECT playerID, namegiven + ' (' + namefirst + ') ' + namelast AS [Full Name]
FROM People GROUP BY playerID, namegiven + ' (' + namefirst + ') ' + namelast )
SELECT person.playerID, [Full Name], t.teamID, [Last Year], format([Player Average], 'c') AS 'Last Year	Player Average',
format([Team Average], 'C') AS 'Team Average' , format([Player Average]-[Team Average], 'C') AS 'Difference'
FROM t, p, person
WHERE t.teamID = p.teamID
AND Person.playerID = p.playerID
ORDER BY playerId, [Last Year] DESC


--22. Using a scalar queries in the SELECT statement and the salaries, batting, pitching and people tables , write a query that shows the full Name, the average salary (from SALARIES table), career batting average (from the BATTING table), career ERA (from the PITCHING table) and the number of teams the player played (from the BATTING table). Format the results as shown below and only use the PEOPLE table in the FROM statement of the top level select.
SELECT nameGiven+' ' +CONCAT('(',nameFirst,')')+' '+nameLast AS [Full Name], FORMAT (avg(salary), 'C') AS [Average Salary] ,
(SELECT count(teamID) FROM Salaries S WHERE P.playerID = S.playerID) as [Total Teams], FORMAT (avg(ERA), 'C') AS 'Avg ERA' , FORMAT (avg(AB), 'C') AS 'Avg BA'
FROM People P, Salaries S,BATTING B,PITCHING C
WHERE S.playerID = P.playerID and B.playerID=P.playerID and C.playerID=P.playerID
GROUP BY P.playerID, nameGiven, nameLast, nameFirst


--23. The player’s union has negotiated that players will start to have a 401K retirement plan. Using the [401K Contributions] column in the Salaries table,  populate this column for each row by updating it to contain 6% of the salary in the row. 
UPDATE Salaries SET [401K Contributions] = salary * 0.06
GO
SELECT playerid, salary,[401K Contributions] 
FROM Salaries S
ORDER BY playerid ASC;


--24. Contract negotiations have proceeded and now the team owner will make a seperate contribution to each players 401K each year. If the player’s salary is under $1 million, the team will contribute another 5%. If the salary is over $1 million, the team will contribute 2.5%. You now need to write an UPDATE query for the [401K Team Contributions] column in the Salaries table to populate the team contribution with the correct amount. You must use a CASE clause in the UPDATE query to handle the different amounts contributed. 
UPDATE Salaries
SET [401K Team Contributions] =
( CASE
WHEN (salary < 1000000) THEN salary*0.05
WHEN (salary >= 1000000) THEN salary*0.025
ELSE (NULL)
END )
GO

SELECT playerid,salary,[401K Contributions],[401K Team Contributions] 
FROM Salaries 
ORDER BY 1 ASC;


--25. You have now been asked to populate the columns to the PEOPLE table that contain the total number of HRs hit ( Total_HR column) by the player and the highest Batting Average the player had during any year they played ( High_BA column). Write a single query that correctly populates these columns. You will need to use a subquery to make is a single query. This query updates 17,593 rows if you use AB > 0 in the where statement. It updates 19,898 rows in nullif is used for batting average. After your update query, write a query that shows the playerid, Total HRs and Highest Batting Average for each player. The Batting Average must be formatted to only show 4 decimal places. Sort the results by playerid. The update query will update 17841 rows and the select query will return 20,370 rows.

-- Updating Total_HR --
BEGIN TRAN
UPDATE People
SET Total_HR = (SELECT SUM(HR) FROM Batting B WHERE B.playerid = P.playerid GROUP BY playerid)
FROM Batting B,People P
WHERE P.playerid = B.playerid
COMMIT

-- Creating Temp_Table, Altering High_BA and updating it --
	
select playerid, max(H*1.0/AB) AS Career
INTO Temp_Table
FROM Batting
WHERE AB>0
GROUP BY playerID
ORDER BY playerID

UPDATE People
SET People.High_BA  = T.Career
FROM People P
INNER JOIN Temp_Table T
ON P.playerID = T.playerID;

select playerID,Total_HR,High_BA from People
WHERE Total_HR > 0 AND High_BA >0


--26. You have also been asked to populate a column in the PEOPLE table ( Total_401K column) that contains the total value of the 401K for each player in the Salaries table.  Write the SQL that correctly populates the column.  Also, include a query that shows the playerid, the player full name and their 401K total from the people table. Only show players that have contributed to their 401Ks. Sort the results by playerid.

BEGIN TRAN
UPDATE People
SET Total_401K = (SELECT sum([401K Contributions])+sum([401K Team Contributions]) FROM Salaries S WHERE S.playerID = P.playerID GROUP BY playerID)
FROM Salaries S,People P
WHERE P.playerID = S.playerID
COMMIT

SELECT playerID,namegiven + ' (' + namefirst + ') ' + namelast AS [Full Name],Total_401K 
FROM People
WHERE Total_401K >0


--27. 2021 Fan Cost Index (the amount it costs for a group of four people to attend an MLB game was an average of $256.41. MLB management has asked you to calculate the following using the teamid, name, yearid, attendance and GHomes (# of home games) from teams table:
--      a.	The total amount the team lost due to covid (The difference between pre-COVID and COVID Attendance (from the Teams table) multiplied by the per person Fan Cost Index)
--      b.	The average loss per game (Total amount lost/Total number of COVID HGames)
--      c.	The number of extra games it would take to recover the losses (total amount lost / average loss per game
--      d.	Per-COVID average attendance (pre-COVID attendance/pre-COVID HGames)
--      e.	COVID average attendance (sum of attendance / sum HGames)
--      f.	COVID drop in per average game attendance (e minus d)
--      g.	% drop in attendance due to cover  (e divided by d)


SELECT teamID,name, sum(L*RA) AS Total_Team_Loss, count(L) as CV_per_Game_loss,
sum(SV)/sum(L)  Games_To_recover,CAST(count(attendance) AS int) CV_Avg_attendance ,
CAST(count(attendance)/sum(L) AS int) PRE_CV_Avg_attendance 
FROM teams
GROUP BY teamID,name


--28. As with any job, players are given raises each year, write a query that calculates the increase each player received and calculate the % increase that raise makes. You will only need to use the SALARIES  and PEOPLE tables. Include the players full name and sort your results by playerid in ascending order and year in descending order. You cannot use advanced aggregate functions such as LAG for this question. 
-- Creating Temporary Table to Store All VAlues(including NUll) --
Select People.playerID, namegiven + ' (' + namefirst + ') ' + namelast AS [Player Name], yearID,
FORMAT(salary, 'C') AS [Current Salary],
FORMAT(lag(salary) over (partition by Salaries.playerID order by yearID),'C') AS [Salary Salary],
FORMAT(salary - lag(salary) over (partition by Salaries.playerID order by yearID),'C') AS [Salary Difference],
FORMAT((salary - lag(salary) over (partition by Salaries.playerID order by Salaries.playerID))/salary,'P')
AS [Increase]
INTO Temp_Table1
FROM Salaries, People
WHERE People.playerID = Salaries.playerID AND salary>0

-- Selecting Not Null Values from Temporary Table --
SELECT * 
FROM Temp_Table1
WHERE [Salary Salary] IS NOT NULL
ORDER BY playerID