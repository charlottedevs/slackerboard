SELECT
   u.id AS user_id
  ,messages_given
  ,messages.channel
  ,messages.channel_slack_identifier
  ,messages.day
FROM users u
JOIN (
  SELECT
     sm.user_id AS id
    ,sc.name AS channel
    ,sc.slack_identifier AS channel_slack_identifier
    ,count(sm.user_id) AS messages_given
    ,DATE(sm.created_at) as day
  FROM slack_messages sm
  JOIN slack_channels sc ON sc.id = sm.slack_channel_id
  GROUP BY sm.user_id, sc.name, sc.slack_identifier, day
) AS messages USING(id)
;
