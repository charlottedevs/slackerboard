namespace :db do
  desc "truncates everything in the database"
  task truncate: :environment do
    conn = ActiveRecord::Base.connection
    conn.tables.each do |t|
      sql = "TRUNCATE #{t} CASCADE"
      puts sql
      conn.execute(sql)
    end
  end
end
