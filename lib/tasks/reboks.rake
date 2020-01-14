namespace :reboks do
  desc "Rake task to update gym occupancies"
  require_relative '../reboks/reboks_scraper'

  task update_occupancy: :environment do
    scraper = Reboks::ReboksScraper.new
    scraper.start
    data = scraper.get_occupancy
    puts data
    Occupancy.create(
      utown: data[:utown].to_i,
      mpsh: data[:mpsh].to_i,
      usc: data[:usc].to_i
    )
  end
end
