require 'json'
require 'open-uri'
require 'faraday'

class UpdateSlackEmoji
  include Interactor

  SLACK_TOKEN = ENV.fetch('SLACK_TOKEN')

  def call
    endpoint    = "https://slack.com/api/emoji.list?token=#{SLACK_TOKEN}"
    res         = JSON.parse(Faraday.get(endpoint).body)
    dirname     = Rails.root.join 'static/emoji'
    config_file = Rails.root.join 'emoji/custom_emoji.json'
    emoji       = []

    if res['ok']
      res['emoji'].each do |name, url|
        next if url.match('alias:') # skip aliases for now

        ext = url.split('.').last
        fn = "#{name}.#{ext}"
        path = File.join(dirname,fn)
        puts path
        File.write(path, open(url).read)

        emoji << {
          shortname: name,
          image: fn,
          path: path
        }
      end

      File.write(config_file, JSON.pretty_generate(emoji))
      puts "=> updated #{config_file}"
    else
      puts res
      exit 1
    end
  end
end
