require "spec_helper"

RSpec.describe ClprApi::Solr::Connection do
  let(:instance) { described_class.instance }

  describe "server_url" do
    it { expect(instance.class.server_read_url).to eq ENV.fetch("SOLR_URL") }
    it { expect(instance.class.server_write_url).to eq ENV.fetch("SOLR_URL_WRITE") }
  end

  before(:each) do
    delete_all_from_solr
  end

  describe "add" do
    it "adds a document without commiting changes" do
      instance.add({ id: "123" })

      expect { instance.find_by_id("123") }.to raise_error(described_class::RecordNotFound)
    end
  end

  describe "add!" do
    it "adds a document and commits changes" do
      instance.add!({ id: "123", title_s: "new doc" })

      expect(instance.find_by_id("123")["title_s"]).to eq "new doc"
    end
  end
end
