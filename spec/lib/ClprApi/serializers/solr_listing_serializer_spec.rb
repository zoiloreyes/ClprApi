require "spec_helper"

RSpec.describe ClprApi::Serializers::SolrListingSerializer, focus: true do
  subject { described_class.new(listing) }

  describe "listing prices" do
    context "when prices are zero or negative" do
      let(:listing) do
        _listing = OpenStruct.new(JSON.parse(File.read("spec/fixtures/listing_model.json")))

        _listing.sale_price_start = 0.0
        _listing.sale_price_end = nil
        _listing.rent_price_start = -5000.0
        _listing.rent_price_end = -3000.0

        _listing
      end

      it "it exposes values as nil" do
        expect(subject.title).to eq("Nissan Versa 2015.")
        expect(subject.id).to eq("1200601s")

        expect(listing.sale_price_start).to be_zero
        expect(listing.sale_price_end).to be_nil
        expect(listing.rent_price_start).to eq(-5000.00)
        expect(listing.rent_price_end).to eq(-3000.00)

        expect(subject.sale_price_start).to be_nil
        expect(subject.sale_price_end).to be_nil
        expect(subject.rent_price_start).to be_nil
        expect(subject.rent_price_end).to be_nil
      end
    end

    context "when prices are greater than zero" do
      let(:listing) do
        _listing = OpenStruct.new(JSON.parse(File.read("spec/fixtures/listing_model.json")))

        _listing.sale_price_start = 100
        _listing.sale_price_end = 200
        _listing.rent_price_start = 300
        _listing.rent_price_end = 400

        _listing
      end

      it "uses the numerical values of the prices" do
        expect(subject.title).to eq("Nissan Versa 2015.")
        expect(subject.id).to eq("1200601s")

        expect(listing.sale_price_start).to eq(100)
        expect(listing.sale_price_end).to eq(200)
        expect(listing.rent_price_start).to eq(300)
        expect(listing.rent_price_end).to eq(400)

        expect(subject.sale_price_start).to eq(100)
        expect(subject.sale_price_end).to eq(200)
        expect(subject.rent_price_start).to eq(300)
        expect(subject.rent_price_end).to eq(400)
      end
    end
  end
end
