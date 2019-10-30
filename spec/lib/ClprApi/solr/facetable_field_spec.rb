require "spec_helper"

RSpec.describe ClprApi::Solr::FacetableField do
  subject { described_class }

  describe "#show" do
    context "with existing slug" do
      let(:found_field) { described_class.find("car_color") }

      it "Finds a Given facetable field field_name/slug" do
        expect(found_field).to be_a(described_class)
        expect(found_field.field_id).to eq("car_color")
        expect(found_field.label).to eq("Color")
      end
    end

    context "with non-existing slug" do
      let(:not_found_field) { described_class.find("do-not-exists") }

      it "returns nil" do
        expect(not_found_field).to be_nil
      end
    end
  end

  describe "#all" do
    subject { described_class.all }

    it "Returns a collection of FacetableFields" do
      expect(subject.count).to be_positive
      expect(subject.map(&:class).uniq).to eq([described_class])
    end
  end
end
