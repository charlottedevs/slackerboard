#!/usr/bin/env ruby

require 'fileutils'

# download manually from 'https://emojipedia.org/apple/'
# dumps an 'emojis_files' directory
# not possible to scrape because images are lazily loaded.
directory = 'emoji'
unless FileTest.directory? directory
  puts "Creating #{directory} directory"
  Dir.mkdir directory
end

src_dir = 'emojis_files'
Dir.foreach(src_dir) do |item|
  next if item == '.' or item == '..'
  emoji = item.split('_').first
  dest = File.join(directory, "#{emoji}.png")
  FileUtils.cp(File.join(src_dir, item), dest)

  # lazy man's way of dealing with emojis that
  # have some with underscore and some with dashes
  # better way is to look at unicodes, but meh.
  underscore = emoji.tr('-', '_')
  dest = File.join(directory, "#{underscore}.png")
  FileUtils.cp(File.join(src_dir, item), dest)
end

puts "done"
