SELECT MAX(winnerage) AS oldest_winner_age, MIN(winnerage) AS youngest_winner_age
FROM Matches;

SELECT COUNT(*) AS fed_tournaments FROM Tournaments WHERE name LIKE 'Fed Cup%';

SELECT fname, COUNT(*) AS num_players 
FROM Players WHERE fname NOT LIKE ''
AND fname NOT LIKE 'Mrs%'
AND LENGTH(fname) > 1
GROUP BY fname
ORDER BY num_players DESC
LIMIT 10;

SELECT COUNT(*) AS wins
FROM Matches m
JOIN Players p ON m.winner = p.id
WHERE p.fname = 'Iga' AND p.lname = 'Swiatek' AND m.year = 2019;

SELECT COUNT(DISTINCT p.id) AS players_without_matches
FROM Players p
LEFT JOIN Matches m ON p.id = m.winner OR p.id = m.loser
WHERE m.winner IS NULL AND m.loser IS NULL;

SELECT DISTINCT T1.*
FROM Tournaments T1
INNER JOIN Tournaments T2 ON T1.id = T2.id AND T1.year != T2.year
ORDER BY T1.id;

SELECT M.year, P.fname, P.lname
FROM Matches M
JOIN Players P ON M.winner = P.id 
JOIN Tournaments T ON T.id = M.tourney
WHERE T.name = 'Wimbledon' AND M.round = 'F'
ORDER BY M.year;

SELECT P.fname, P.lname
FROM Matches
JOIN Players P ON Matches.winner = P.id
WHERE Matches.score LIKE '0-6%' 
GROUP BY P.id HAVING COUNT(*) > 1;

(WITH Wins AS (
  SELECT winner AS player_id, COUNT(*) AS num_of_wins
  FROM Matches
  WHERE year BETWEEN 2010 AND 2019
  GROUP BY winner
  ORDER BY num_of_wins DESC
  LIMIT 5
),
Losses AS (
  SELECT loser AS player_id, COUNT(*) AS num_of_losses
  FROM Matches
  WHERE year BETWEEN 2010 AND 2019
  GROUP BY loser
  ORDER BY num_of_losses DESC
  LIMIT 5
)
SELECT P.fname, P.lname, W.num_of_wins, L.num_of_losses
FROM Players P
LEFT JOIN Wins W ON P.id = W.player_id
LEFT JOIN Losses L ON P.id = L.player_id
WHERE W.player_id IS NOT NULL OR L.player_id IS NOT NULL)
ORDER BY num_of_wins DESC, num_of_losses DESC;

SELECT P.fname, P.lname, P.dob, T.name AS tournament_name, T.held
FROM Matches M
JOIN Players P ON M.winner = P.id
JOIN Tournaments T ON M.year = T.year AND M.tourney = T.id
WHERE EXTRACT(MONTH FROM P.dob) = EXTRACT(MONTH FROM T.held)
AND EXTRACT(DAY FROM P.dob) = EXTRACT(DAY FROM T.held)
ORDER BY T.held;
