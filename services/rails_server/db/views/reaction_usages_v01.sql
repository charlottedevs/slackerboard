SELECT
   u.id AS user_id
  ,reactions_given
  ,reactions.emoji
  ,reactions.day
FROM users u
JOIN (
  SELECT
     sr.user_id AS id
    ,sr.emoji
    ,count(sr.user_id) AS reactions_given
    ,DATE(sr.created_at) as day
  FROM slack_reactions sr
  GROUP BY sr.user_id, sr.emoji, day
) AS reactions USING(id)
;
