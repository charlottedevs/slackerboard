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
    ,sr.created_at as day
  FROM slack_reactions sr
  GROUP BY sr.user_id, sr.emoji, day
) AS reactions USING(id)
ORDER BY user_id, reactions_given DESC, reactions.emoji DESC
;
