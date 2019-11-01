require "spec_helper"

RSpec.describe ClprApi::Listings::FilterBuilderByApiKey do
  let(:api_key) { "787POOONCEEEmonSUcasa321" }
  let(:expected_response) do
    {
      params: {
        "car_make" => [
          "jeep",
        ],
        "car_model" => [
          "wrangler", "wrangler-unlimited", "wrangler-sport", "wrangler", "wrangler-unlimited",
          "wrangler-sport", "wrangler-unlimited-sport", "wrangler-sahara", "wrangler-unlimited-sport",
          "wrangler-rubicon", "wrangler-rubicon", "wrangler-sport-unlimited", "wrangler-sport-unlimited",
          "wrangler-sport", "rubicon-unlimited", "rubicon-unlimited", "rubicon",
        ],
        "has_photos" => true,
      },
      search_conditions: [
        "lister_id_i:(22)",
      ],
    }
  end

  it "requests the api and gets the search filters for a given API KEY" do
    expect(described_class.call(api_key)).to eq(expected_response)
  end
end
