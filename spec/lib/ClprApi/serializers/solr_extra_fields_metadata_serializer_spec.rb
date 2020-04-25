require "spec_helper"

RSpec.describe ClprApi::Serializers::SolrExtraFieldsMetadataSerializer do
  let(:listing) do
    _listing = OpenStruct.new(JSON.parse(File.read("spec/fixtures/listing_model.json")))

    _listing.fields = [
      field,
    ]

    _listing
  end

  let(:field) do
    OpenStruct.new(
      field_id: "car_engine",
      label: "Motor",
      field_type: "option",
      field_value: "4 Cilindros",
      slug: "4-cilindros",
      primary: false,
    )
  end

  context "parsing" do
    subject { described_class.from_field(field) }

    it "Generates extra field metadata with listing value and slug for the given value" do
      expect(subject.id).to eq("car_engine")
      expect(subject.label).to eq("Motor")
      expect(subject.type).to eq("option")
      expect(subject.value).to eq("4 Cilindros")
      expect(subject.slug).to eq("4-cilindros")
      expect(subject.primary).to be_falsey
    end
  end
end
