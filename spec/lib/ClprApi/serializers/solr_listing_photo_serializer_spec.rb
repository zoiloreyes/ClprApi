require "spec_helper"

RSpec.describe ClprApi::Serializers::SolrListingPhotoSerializer do
  let(:listing) {
    OpenStruct.new(s3_listing_photos: [
                     OpenStruct.new(s3: "path/to/image-1.png", id: 1, description: "image-1"),
                     OpenStruct.new(s3: "path/to/image-2.png", id: 2, description: "image-2"),
                     OpenStruct.new(s3: "path/to/image-3.png", id: 3, description: "image-3"),
                   ])
  }

  subject { described_class.new(listing) }
  let(:json) { subject.as_json(root: nil) }

  it "serializes listing photos" do
    expect(subject.main_url).to eq("path/to/image-1.png")
    expect(subject.url_sm).to eq(["path/to/image-1.png", "path/to/image-2.png", "path/to/image-3.png"])
    expect(subject.id_im).to eq([1, 2, 3])
    expect(subject.description_sm).to eq(["image-1", "image-2", "image-3"])
    expect(json.keys).to eq([:main_url, :url_sm, :id_im, :description_sm])
  end
end
