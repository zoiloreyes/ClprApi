require "spec_helper"

RSpec.describe ClprApi::Listings::GetListings do
  let(:solr) { ClprApi::Solr::Connection.instance }
  let(:params) { {} }
  subject { described_class.new(params: params).as_json }

  before do
    delete_all_from_solr

    solr.add!(JSON.parse(File.read("spec/fixtures/listing.json")))
  end

  describe "filter by area" do
    context "Area is Puerto Rico" do
      let(:params) { { area: "puerto-rico" } }

      it "brings listings tagged with area `puerto-rico`" do
        expect(subject["filters"].fetch("area").fetch("selected").count).to be(1)
        expect(subject["filters"].fetch("area").fetch("selected").first["slug"]).to eq("puerto-rico")

        expect(subject["total"]).to eq(1)
      end
    end
  end

  describe "filter by category" do
    context "category is Sedan" do
      let(:params) { { category: "vehiculos-carros-sedan" } }

      it "brings listings tagged with category `sedan`" do
        expect(subject["filters"].fetch("category").fetch("selected").count).to be(1)
        expect(subject["filters"].fetch("category").fetch("selected").first["slug"]).to eq("vehiculos-carros-sedan")

        expect(subject["total"]).to eq(1)
      end
    end
  end

  let(:serialized_listing) { subject["items"].first }
  let(:listing_image_serialized) { serialized_listing.images.first }

  it "returns serialized items" do
    expect(subject["filters"].fetch("area").fetch("selected")).to be_empty
    expect(subject["filters"].fetch("category").fetch("selected")).to be_empty

    expect(subject["total"]).to eq(1)
    expect(subject["items"].count).to eq(1)
    expect(subject["total_pages"]).to eq(1)
    expect(subject["current_page"]).to eq(1)

    expect(serialized_listing.listing_id).to eq(1200601)
    expect(serialized_listing.source).to eq("INV360")
    expect(serialized_listing.source_id).to eq("")
    expect(serialized_listing.title).to eq("Nissan Versa 2015.")
    expect(serialized_listing.description).to eq("Nissan Versa 2015 Car Description")
    expect(serialized_listing.category_id).to eq([1, 3, 9, 13])
    expect(serialized_listing.is_free).to be_falsey
    expect(serialized_listing.is_sale).to be_truthy
    expect(serialized_listing.sale_price_obo).to be_falsey
    expect(serialized_listing.is_rent).to be_falsey
    expect(serialized_listing.rent_price_obo).to be_falsey
    expect(serialized_listing.is_barter).to be_falsey
    expect(serialized_listing.has_photos).to be_truthy
    expect(serialized_listing.boost).to eq(1)
    expect(serialized_listing.primary).to be_truthy
    expect(serialized_listing.offering).to eq("sale")
    expect(serialized_listing.sale_price_start).to eq(9000.0)
    expect(serialized_listing.sale_price_unit_label).to eq("")
    expect(serialized_listing.rent_price_unit_label).to eq("")
    expect(serialized_listing.price_start).to eq(9000.0)
    expect(serialized_listing.price_unit).to eq("")
    expect(serialized_listing.price_conditions).to eq("")
    expect(serialized_listing.price_obo).to be_falsey
    expect(serialized_listing.area_type).to eq("country")
    expect(serialized_listing.extra_fields.map(&:id)).to match_array(["car_doors", "car_make", "car_model", "car_vin", "car_year", "new_or_used"])
    expect(serialized_listing.extra_fields.map(&:value)).to match_array(["3N1CN7APXFL934684", "Versa", 2015, 4, "Nuevo", "Nissan"])
    expect(serialized_listing.id).to eq("1200601s")
    expect(serialized_listing.highlighted).to be_falsey

    expect(listing_image_serialized.small.url).to be_end_with("/160x120/https://s3.amazonaws.com/media.listamax.com/path/to/car-photo-spec.jpg")
    expect(listing_image_serialized.medium.url).to be_end_with("/320x240/https://s3.amazonaws.com/media.listamax.com/path/to/car-photo-spec.jpg")
    expect(listing_image_serialized.large.url).to be_end_with("/640x480/https://s3.amazonaws.com/media.listamax.com/path/to/car-photo-spec.jpg")
    expect(listing_image_serialized.full.url).to be_end_with("/1024x768/https://s3.amazonaws.com/media.listamax.com/path/to/car-photo-spec.jpg")

    expect(serialized_listing.as_json.keys).to eq([:id, :title, :listing_id, :category_slug, :area_slug, :primary_fields])
  end
end
