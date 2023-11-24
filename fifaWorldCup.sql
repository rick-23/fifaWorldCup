CREATE DATABASE IF NOT EXISTS FIFA_WORLD_CUP;
USE FIFA_WORLD_CUP;

CREATE TABLE IF NOT EXISTS WorldCups (
	Year INT PRIMARY KEY,
    Country VARCHAR(25),
    Winner VARCHAR(25),
    RunnersUp VARCHAR(25),
    Third VARCHAR(25),
    Fourth VARCHAR(25),
    GoalsScored INT,
    QualifiedTeams INT,
    MatchesPlayed INT,
    Attendance VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS WorldCupMatches (
    Year INT,
    Datetime VARCHAR(200),
    Stage VARCHAR(25),
    Stadium VARCHAR(100),
    City VARCHAR(50),
    Home_Team_Name VARCHAR(25),
    Home_Team_Goals INT,
    Away_Team_Goals INT,
    Away_Team_Name VARCHAR(25),
    Win_Conditions VARCHAR(200),
    Attendance INT,
    Half_Time_Home_Goals INT,
    Half_Time_Away_Goals INT,
    Referee VARCHAR(100),
    Assistant_1 VARCHAR(100),
    Assistant_2 VARCHAR(100),
    Round_ID INT,
    Match_ID INT PRIMARY KEY,
    Home_Team_Initials VARCHAR(5),
    Away_Team_Initials VARCHAR(5),
    FOREIGN KEY (Year) REFERENCES WorldCups(Year)
);

CREATE TABLE IF NOT EXISTS WorldCupPlayers (
    Round_ID INT,
    Match_ID INT,
    Team_Initials VARCHAR(5),
    Coach_Name VARCHAR(100),
    Line_up VARCHAR(5),
    Shirt_Number INT,
    Player_Name VARCHAR(100),
    Position VARCHAR(10),
    Event_Name VARCHAR(20),
    FOREIGN KEY (Match_ID) REFERENCES WorldCupMatches(Match_ID)
);

LOAD DATA LOCAL INFILE '/Users/rick/Workspace/mySQLProjects/fifaWorldCup/WorldCups.csv'
INTO TABLE WorldCups
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/rick/Workspace/mySQLProjects/fifaWorldCup/WorldCupMatches.csv'
INTO TABLE WorldCupMatches
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/rick/Workspace/mySQLProjects/fifaWorldCup/WorldCupPlayers.csv'
INTO TABLE WorldCupPlayers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- FIFA World Cup Year and Host Country that had the most goals scored
SELECT Year, Country AS Host_Country, GoalsScored AS Goals_Scored
FROM WorldCups
ORDER BY GoalsScored DESC 
LIMIT 1;

-- FIFA World Cup Year and Host Country with the most stadiums/pitch locations
SELECT WorldCups.Year, WorldCups.Country, COUNT(DISTINCT t2.Stadium) as Num_Of_Stadiums
FROM WorldCups
JOIN WorldCupMatches t2 ON WorldCups.Year = t2.Year
GROUP BY WorldCups.Year, WorldCups.Country
ORDER BY Num_Of_Stadiums DESC
LIMIT 1;

-- FIFA World Cup Year that was the most exciting (Highest Average Goals Scored per match)
WITH AverageGoalsPerMatch AS (
	SELECT
		WorldCups.Year,
        WorldCups.Country as Host_Country,
        GoalsScored / MatchesPlayed AS AverageGoalsPerMatch
	FROM WorldCups
)
SELECT Year, Host_Country, AverageGoalsPerMatch
FROM AverageGoalsPerMatch
ORDER BY AverageGoalsPerMatch DESC
LIMIT 1;

-- Top 10 Popular teams in FIFA World Cup Histort! (With largest stadium attendance)
WITH TeamAttendance AS (
	SELECT Team, SUM(Attendance) AS TotalAttendance FROM (
		SELECT Home_Team_Name AS Team, Attendance
		FROM WorldCupMatches

		UNION ALL
    
		SELECT Away_Team_Name AS Team, Attendance
		FROM WorldCupMatches
    ) AS CombinedMatches
    GROUP BY Team
)
SELECT Team, SUM(TotalAttendance) AS TotalStadiumAttendance
FROM TeamAttendance
GROUP BY Team
ORDER BY TotalStadiumAttendance DESC
LIMIT 10;