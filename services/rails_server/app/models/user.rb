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
      ,m.slack_messages_count
      ,r.slack_reactions_count
    FROM users u
    JOIN (
      SELECT
         user_id AS id
        ,sum(messages_given) as slack_messages_count
      FROM channel_usages cu
      %{message_where_clause}
      GROUP BY id
    ) AS m USING(id)
    LEFT JOIN (
      SELECT
         user_id AS id
        ,sum(reactions_given) as slack_reactions_count
      FROM reaction_usages ru
      %{reaction_where_clause}
      GROUP BY id
    ) AS r USING(id)
    ORDER BY slack_messages_count DESC, slack_reactions_count DESC, slack_handle
  ) AS users
  SQL

  def self.slackers(since: nil)
    users = since ? User.load_slackers(since: since) : User.all

    users.where('slack_messages_count > 0')
        .order(
          slack_messages_count: :desc,
          slack_reactions_count: :desc,
          slack_handle: :asc
        )
  end

  def self.load_slackers(since: nil)
    sql = SLACKERS % {
      message_where_clause:  since_sql(since, tbl: 'cu', col: 'day'),
      reaction_where_clause: since_sql(since, tbl: 'ru', col: 'day')
    }

    User.from(sql)
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

  def message_summary(since: nil)
    usage_summary(
      channel_usages,
      group_by: %i(channel channel_slack_identifier),
      stat: :messages_given,
      since: since
    )
  end


  def reaction_summary(since: nil)
    usage_summary(
      reaction_usages,
      group_by: :emoji,
      stat: :reactions_given,
      since: since
    )
  end

  private

  def usage_summary(usage, group_by:, stat:, since: nil)
    assoc = if since
              usage.where('day >= ?', since)
            else
              usage
            end
    assoc.group(group_by).sum(stat)
  end
end
