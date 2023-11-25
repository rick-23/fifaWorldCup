
-- 1. The number of submissions per language.
SELECT submissions.language, 
      COUNT(*) AS lang_count 
      FROM submissions 
      GROUP BY submissions.language 
      ORDER BY lang_count DESC;

-- 2. Players who are exactly 25 years old.
SELECT nickname from players 
    WHERE ROUND(DATEDIFF(CURRENT_DATE, players.birth)/365.2) = 25;

-- 3. The top 10 users ranked by number of unique problems attempted.
SELECT nickname, COUNT(DISTINCT(t2.problem_id)) AS problems_attempted 
    FROM players
    JOIN submissions t2 ON players.user_id=t2.user_id
    GROUP BY players.nickname
    ORDER BY problems_attempted DESC
    LIMIT 10;


-- 4. Players who submitted on the same problem with at least two different languages.
SELECT players.nickname 
    FROM players 
    JOIN submissions t1 ON players.user_id = t1.user_id
    JOIN submissions t2 ON t1.problem_id = t2.problem_id AND t1.user_id = t2.user_id AND t1.language <> t2.language
    GROUP BY players.nickname
    ORDER BY COUNT(DISTINCT t1.problem_id) DESC;

-- 5. Players who solved at least 60 different MEDIUM or HARD problems with a 100% score.
SELECT players.nickname 
    FROM players
    JOIN submissions t1 ON players.user_id = t1.user_id
    JOIN problems t2 ON t1.problem_id = t2.problem_id
    GROUP BY players.nickname
    HAVING COUNT(DISTINCT CASE WHEN t2.difficulty IN ('MEDIUM', 'HARD') AND t1.score = 100 THEN t1.problem_id END) >= 60
    ORDER BY COUNT(DISTINCT t1.problem_id) DESC; 
