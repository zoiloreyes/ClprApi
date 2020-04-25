require "spec_helper"

RSpec.describe ClprApi::Serializers::SolrOptionListFieldSerializer do
  let(:field) do
    OpenStruct.new(
      field_id: "features",
      slug: "male",
      field_value: "male",
      raw_value: "1",
      options: [
        OpenStruct.new(field_value: "male", raw_value: 2, slug: "super_sayan"),
        OpenStruct.new(field_value: "female", raw_value: 3, slug: "instant_transmition"),
      ],
    )
  end

  context "Serialized" do
    subject { described_class.call(field) }

    it "serializes an `Option` field" do
      expect(subject).to eq(
        {
          "features_im" => [2, 3],
          "features_sm" => ["male", "female"],
          "features_slug_sm" => ["super_sayan", "instant_transmition"],
          "features_json_sm" => [
            "{\"field_id\":\"features\",\"slug\":\"super_sayan\",\"label\":\"male\",\"value\":1}",
            "{\"field_id\":\"features\",\"slug\":\"instant_transmition\",\"label\":\"male\",\"value\":1}",
          ],
        }
      )
    end
  end

  context "Object" do
    subject { described_class.new(field) }
    it "represents an `OptionList` field ready for solr serialization" do
      expect(subject.field_raw_values).to eq([2, 3])
      expect(subject.field_values).to eq(["male", "female"])
      expect(subject.field_slugs).to eq(["super_sayan", "instant_transmition"])
      expect(subject.field_options).to eq(["{\"field_id\":\"features\",\"slug\":\"super_sayan\",\"label\":\"male\",\"value\":1}", "{\"field_id\":\"features\",\"slug\":\"instant_transmition\",\"label\":\"male\",\"value\":1}"])
    end
  end
end
