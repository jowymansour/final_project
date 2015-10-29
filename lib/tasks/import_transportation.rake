desc "Import routes from CSV"
task :import => :environment do
  require 'csv'

  csv_text = File.read('db/google_transit/cta_L_stops_new.csv', :encoding => 'iso-8859-1')
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    TrainStop.create!(row.to_hash)
  end
end
