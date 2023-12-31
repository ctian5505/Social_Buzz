----------Tools Used:  Microsoft MSSQL ------------
-- Create Database
CREATE DATABASE Social_Buzz;

-- Import the data 

-- Rename the table (beacuse imported table has unwanted characters)
USE Social_Buzz

EXEC sp_rename Content$, Content 
EXEC sp_rename ['Reaction Type$'], Reaction_Type
EXEC sp_rename Reactions$, Reactions



-- Data Joining
SELECT 
	Reac.F1
	, Reac.[Content ID]
	, Reac.[Reaction Type]
	, Reac.Datetime 
	, Cont.[Content Type]
	, Cont.Category
	, Rtype.Sentiment
	, Rtype.Score
FROM 
	Reactions AS Reac
LEFT JOIN 
	Content AS Cont
ON 
	Reac.[Content ID] = Cont.[Content ID]
LEFT JOIN 
	Reaction_Type AS Rtype
ON 
	Reac.[Reaction Type] = Rtype.Reaction_Type
ORDER BY 
	Reac.F1


--- Figure out the Top 5 performing categories

With CTE_Social_Buzz AS (
SELECT 
	Reac.F1
	, Reac.[Content ID]
	, Reac.[Reaction Type]
	, Reac.Datetime 
	, Cont.[Content Type]
	, Cont.Category
	, Rtype.Sentiment
	, Rtype.Score
FROM 
	Reactions AS Reac
LEFT JOIN 
	Content AS Cont
ON 
	Reac.[Content ID] = Cont.[Content ID]
LEFT JOIN 
	Reaction_Type AS Rtype
ON 
	Reac.[Reaction Type] = Rtype.Reaction_Type
)

SELECT TOP 5
	Category
	, SUM(Score) AS Aggregrate_Score 
	, RANK() OVER (ORDER BY SUM(Score) DESC) AS Rank
FROM 
	CTE_Social_Buzz
GROUP BY 
	Category

--- Conclusion
The top 5 performing categories are: 
animals = 68624
science	= 65405
healthy eating	= 63138
technology = 63035
food = 61598
