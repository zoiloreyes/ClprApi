require "dotenv/load"
require "bundler/setup"
require "ClprApi"
require "dotenv"
require "pry"
require "httparty"
require "awesome_print"

def delete_all_from_solr
  HTTParty.post(
    ENV.fetch("SOLR_URL") + "/update?commit=true",
    headers: { "Content-Type" => "text/xml" },
    body: "<delete><query>*:*</query></delete>",
  )
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
