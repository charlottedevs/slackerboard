class Slackerboard
  attr_reader :this_week

  def self.this_monday
    Time.zone.now.beginning_of_week(:monday)
  end

  def initialize(*args, this_week: false)
    @this_week = this_week
  end

  def to_json
    to_builder.array!
  end

  def to_builder
    Jbuilder.new do |json|
      json.array! users do |user|
        json.extract!(user,
                      :id,
                      :slack_identifier,
                      :real_name,
                      :slack_handle,
                      :profile_image)

        json.messages channel_stats(user) do |hsh|
          json.channel hsh['channel']
          json.slack_identifier hsh['slack_identifier']
          json.messages_sent hsh['messages_sent']
        end

        json.reactions reaction_stats(user)  do |hsh|
          json.emoji hsh['emoji']
          json.reactions_given hsh['reactions_given']
        end
      end
    end
  end

  def users
    User.slackers(this_week: this_week)
  end

  def channel_stats(user)
    ActiveRecord::Base.connection.execute msg_sql(user)
  end

  def reaction_stats(user)
    ActiveRecord::Base.connection.execute reaction_sql(user)
  end

  def reaction_sql(user)
    <<~SQL
      SELECT
          r.emoji
          ,(
            SELECT COUNT(*)
            FROM slack_reactions sr
            WHERE sr.user_id = #{user.id}  AND r.emoji = sr.emoji
              #{created_at_sql('sr')}
          ) AS reactions_given
        FROM slack_reactions r
        JOIN users u ON r.user_id = u.id
      WHERE u.id = #{user.id}
        #{created_at_sql('r')}
      GROUP BY r.emoji
      ORDER BY reactions_given DESC
    SQL
  end

  def msg_sql(user)
    <<~SQL
      SELECT
      c.name AS channel
      ,c.slack_identifier
      ,(
        SELECT COUNT(*)
        FROM slack_messages sm
        WHERE sm.user_id = #{user.id} AND sm.slack_channel_id = c.id
          #{created_at_sql('sm')}
      ) AS messages_sent
      FROM slack_messages m
      JOIN users u ON m.user_id = u.id
      LEFT JOIN slack_channels c ON m.slack_channel_id = c.id
      WHERE u.id = #{user.id}
        #{created_at_sql('m')}
      GROUP BY channel, c.id
      ORDER BY messages_sent DESC
    SQL
  end


  def created_at_sql(col)
    "AND #{col}.created_at >= '#{Slackerboard.this_monday}'" if this_week
  end
end
