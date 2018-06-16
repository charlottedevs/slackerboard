require 'json'
require 'open-uri'
require 'faraday'
require 'fileutils'

class UpdateSlackEmoji
  include Interactor

  SLACK_TOKEN = ENV.fetch('SLACK_USER_TOKEN')

  def call
    endpoint    = "https://slack.com/api/emoji.list?token=#{SLACK_TOKEN}"
    res         = JSON.parse(Faraday.get(endpoint).body)
    dirname     = 'static/emoji'
    config_file = 'emoji/custom_emoji.json'
    emoji       = []

    FileUtils.rm_rf Dir.glob(File.join(dirname, '*'))

    if res['ok']
      res['emoji'].each do |name, url|
        next if url.match('alias:') # skip aliases for now

        ext = url.split('.').last
        fn = "#{name}.#{ext}"
        path = File.join(dirname,fn)
        Rails.logger.info path

        File.open(path, 'w:UTF-8') do |f|
          f.write open(url).read.force_encoding('UTF-8')
        end

        emoji << {
          shortname: name,
          image: fn,
          path: path
        }
      end

      File.write(config_file, JSON.pretty_generate(emoji))
      Rails.logger.info "=> updated #{config_file}"
    else
      Rails.logger.fatal res
      exit 1
    end
  end
end
