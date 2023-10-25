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

With Social_Buzz AS (
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
SELECT TOP 5 Category, COUNT(*) AS Category_Count, RANK() OVER (ORDER BY COUNT(Category) DESC) AS Rank
FROM Social_Buzz
GROUP BY Category
