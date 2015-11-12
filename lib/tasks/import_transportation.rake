desc "Import routes from CSV"
task :import => :environment do
  require 'csv'

  csv_text = File.read('db/OldTables/favorites.csv', :encoding => 'iso-8859-1')
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    Favorite.create!(row.to_hash)
  end

  csv_text = File.read('db/OldTables/train_stops.csv', :encoding => 'iso-8859-1')
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    TrainStop.create!(row.to_hash)
  end

  csv_text = File.read('db/OldTables/transportations.csv', :encoding => 'iso-8859-1')
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    Transportation.create!(row.to_hash)
  end

  csv_text = File.read('db/OldTables/users.csv', :encoding => 'iso-8859-1')
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    User.create!(row.to_hash)
  end
end
