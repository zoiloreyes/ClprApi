require "spec_helper"

RSpec.describe ClprApi::Serializers::SolrExtraFieldsMetadataSerializer do
  let(:listing) do
    _listing = OpenStruct.new(JSON.parse(File.read("spec/fixtures/listing_model.json")))
  end
end
