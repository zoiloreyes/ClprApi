require "spec_helper"

RSpec.describe ClprApi::Serializers::SolrOptionFieldSerializer do
  let(:field) do
    OpenStruct.new(
      field_id: "gender",
      slug: "male",
      field_value: "El Hombre",
      raw_value: "1",
    )
  end

  context "Serialized" do
    subject { described_class.call(field) }

    it "serializes an option field" do
      expect(subject).to eq(
        {
          "gender_$INTEGER" => 1,
          "gender_$STRING" => "El Hombre",
          "gender_slug_$STRING" => "male",
          "gender_json_$STRING" => "{\"field_id\":\"gender\",\"slug\":\"male\",\"label\":\"El Hombre\",\"value\":1}",
        }
      )
    end
  end

  context "Object" do
    subject { described_class.new(field) }
    it "serializes an option field" do
      expect(subject.field_slug).to eq("male")
      expect(subject.field_value).to eq("El Hombre")
      expect(subject.field_raw_value).to eq(1)
      expect(subject.field_option).to eq("{\"field_id\":\"gender\",\"slug\":\"male\",\"label\":\"El Hombre\",\"value\":1}")
    end
  end
end
