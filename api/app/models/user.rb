class User < ApplicationRecord
  has_many :slack_messages
  has_many :slack_reactions
  has_many :slack_channels, through: :slack_messages
  has_many :channel_usages
  has_many :reaction_usages

  SLACKERS = <<~SQL
  (
    SELECT
       u.id
      ,u.slack_identifier
      ,u.slack_handle
      ,u.real_name
      ,u.profile_image
      ,COALESCE(m.messages_given, 0) AS messages_given
      ,COALESCE(r.reactions_given, 0) AS reactions_given
    FROM users u
    JOIN (
      SELECT
         user_id AS id
        ,SUM(messages_given) AS messages_given
      FROM channel_usages cu
      %{message_where_clause}
      GROUP BY id
    ) AS m USING(id)
    LEFT JOIN (
      SELECT
         user_id AS id
        ,SUM(reactions_given) AS reactions_given
      FROM reaction_usages ru
      %{reaction_where_clause}
      GROUP BY id
    ) AS r USING(id)
  ) AS users
  SQL
  def self.slackers(since: nil)
    opts = {
      message_where_clause:  nil,
      reaction_where_clause: nil
    }

    if since
      opts[:message_where_clause] = since_sql(since, tbl: 'cu', col: 'day')
      opts[:reaction_where_clause] = since_sql(since, tbl: 'ru', col: 'day')
    end

    sql = SLACKERS % opts

    User.from(sql)
        .where('messages_given > 0')
        .order(
          messages_given: :desc,
          reactions_given: :desc,
          slack_handle: :asc
        )
  end

  def self.since_sql(since, tbl:, col: 'created_at')
    return unless since
    "WHERE #{tbl}.#{col} >= '#{since}'"
  end

  def update_slack_info
    UpdateSlackUser.call(user: self)
  end

  def update_slack_info!
    UpdateSlackUser.call(user: self, save: true)
  end


  MESSAGE_SUMMARY = <<~SQL
  (
    SELECT
       user_id
      ,channel
      ,channel_slack_identifier
      ,SUM(messages_given) AS messages_given
    FROM channel_usages
    %{where}
    GROUP BY user_id, channel, channel_slack_identifier
    ORDER BY user_id, messages_given DESC, channel DESC
  ) AS channel_usages
  SQL
  def message_summary(since: nil)
    sql = MESSAGE_SUMMARY % { where: where(since) }
    ChannelUsage.from(sql)
  end

  REACTION_SUMMARY = <<~SQL
  (
    SELECT
       user_id
      ,emoji
      ,SUM(reactions_given) AS reactions_given
    FROM reaction_usages
    %{where}
    GROUP BY user_id, emoji
    ORDER BY user_id, reactions_given DESC, emoji DESC
  ) AS reaction_usages
  SQL
  def reaction_summary(since: nil)
    sql = REACTION_SUMMARY % { where: where(since) }
    ReactionUsage.from(sql)
  end

  private

  def where(since)
    "WHERE user_id = '#{id}'".tap do |where|
      where << " AND day >= '#{since}'" if since
    end
  end
end
