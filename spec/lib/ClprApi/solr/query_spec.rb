require "spec_helper"

RSpec.describe ClprApi::Solr::Query do
  let(:params) { {} }

  subject { described_class.new(params: params) }

  let(:solr) { ClprApi::Solr::Connection.instance }

  describe "cache_key" do
    describe "generates cache keys bases on given params" do
      let(:default_cache_key) { "e18966f4f787a89da26528bba6a60485" }

      before do
        allow(subject).to receive(:current_date_formatted) { "2020-12-12" }
      end

      context "with empty params" do
        it { expect(subject.cache_key).to eq(default_cache_key) }
      end

      context "if invalid not filterable params are provided" do
        let(:params) { { some: :value, another: :value } }

        it { expect(subject.cache_key).to eq(default_cache_key) }
      end

      context "with provided values params" do
        let(:params) { { category: "vehiculos-carros-sedan" } }

        it { expect(subject.cache_key).to eq("753e6a7c59d5eaea6993f7247fe0ec6b") }
      end
    end
  end

  describe "total_pages" do
    context "default" do
      before do
        delete_all_from_solr
      end

      it "returns zero as the total number of pages if there are no records in the response" do
        expect(subject.current_page).to eq(1)
        expect(subject.total_pages).to be_zero
      end
    end

    context "limit records to zero" do
      let(:params) { { limit: 0 } }

      it "limits records to zero" do
        expect(subject).to be_limit_records_to_zero
        expect(subject.limit).to eq(0)
      end
    end
  end

  describe "search_filters" do
    it "includes the highlights filter" do
      expect(subject.search_filters).to be_empty
    end

    context "defaults" do
      it "generates default values for Solr Search query" do
        expect(subject.search_filters).to be_empty
        expect(subject.stats).to eq({ stats: true, :"stats.field" => ["price_start_f", "price_end_f"] })
        expect(subject.stats_fields).to eq(["price_start_f", "price_end_f"])
        expect(subject.facet_fields).to match_array([
                                          "{!ex=offering key=offering}offering_s",
                                          "{!ex=has_photos key=has_photos}has_photos_b",
                                          "{!ex=category key=category}category_as_json_sm",
                                          "{!ex=area key=area}area_as_json_sm",
                                        ])
      end
    end

    context "with_category" do
      let(:params) { { category: "vehiculos-carros" } }

      it "generates filtering options that includes filterable dynamic fields of a given category" do
        expect(subject.search_query).to match_array(["{!tag=category}( ( category_slug_sm: (vehiculos-carros) ) )"])
        expect(subject.stats_fields).to match_array(["car_year_i", "price_start_f", "price_end_f"])

        expect(subject.facet_fields).to match_array([
          "{!ex=offering key=offering}offering_s",
          "{!ex=has_photos key=has_photos}has_photos_b",
          "{!ex=category key=category}category_as_json_sm",
          "{!ex=area key=area}area_as_json_sm",
          "{!ex=car_color key=car_color}car_color_json_s",
          "{!ex=car_engine key=car_engine}car_engine_json_s",
          "{!ex=car_make key=car_make}car_make_json_s",
          "{!ex=car_model key=car_model}car_model_s",
          "{!ex=car_year key=car_year}car_year_i",
          "{!ex=new_or_used key=new_or_used}new_or_used_json_s",
        ])
      end
    end

    context "with_category and car_make" do
      let(:params) { { "category" => "vehiculos-carros", "car_make" => "toyota" } }

      it "generates filtering options that includes filterable dynamic fields of a given category" do
        expect(subject.search_query).to match_array(["{!tag=car_make}( ( car_make_slug_s: (toyota) ) )", "{!tag=category}( ( category_slug_sm: (vehiculos-carros) ) )"])
      end
    end

    context "with_category and car_model" do
      let(:params) { { "category" => "vehiculos-carros", car_model: "camry" } }

      it "generates filtering options that includes filterable dynamic fields of a given category" do
        expect(subject.search_query).to match_array(["{!tag=category}( ( category_slug_sm: (vehiculos-carros) ) )"])
      end
    end

    context "with_category, car_make and car_model" do
      let(:params) { { "category" => "vehiculos-carros", "car_make" => "toyota", "car_model" => "camry" } }

      it "generates filtering options that includes filterable dynamic fields of a given category" do
        expect(subject.search_query).to match_array([
          "{!tag=car_make}( ( car_make_slug_s: (toyota) ) )",
          "{!tag=car_model}( ( car_model_slug_s: (camry) ) )",
          "{!tag=category}( ( category_slug_sm: (vehiculos-carros) ) )",
        ])
      end
    end

    context "with_category_and_offering" do
      let(:params) { { "category" => "bienes-raices", "offering" => "sale" } }

      it "generates filtering options that includes filterable dynamic fields of a given category" do
        expect(subject.search_query).to match_array(["{!tag=category}( ( category_slug_sm: (bienes-raices) ) )", "{!tag=offering}( ( offering_s: (sale) ) )"])
        expect(subject.stats_fields).to match_array(["price_end_f", "price_start_f"])
        expect(subject.facet_fields).to match_array([
          "{!ex=offering key=offering}offering_s",
          "{!ex=has_photos key=has_photos}has_photos_b",
          "{!ex=category key=category}category_as_json_sm",
          "{!ex=area key=area}area_as_json_sm",
        ])
      end
    end

    describe "results from servicios category" do
      context "category equals servicios" do
        let(:params) { { category: "servicios" } }

        it "adds an exclusion facet filter for servicios-masajes" do
          expect(subject.search_query).to match_array(["{!tag=category}( ( category_slug_sm: (servicios) ) )", "{!tag=category}((-category_slug_sm:(servicios-masajes)))"])
        end
      end

      context "category equals servicios-masajes" do
        let(:params) { { category: "servicios-masajes" } }

        it "doesn't add exclusion filter for servicios-masajes" do
          expect(subject.search_query).to match_array(["{!tag=category}( ( category_slug_sm: (servicios-masajes) ) )"])
        end
      end
    end

    context "highlighted" do
      let(:params) { { highlighted: "true" } }

      it "includes the highlights filter" do
        expect(subject.search_filters).to eq(described_class::HIGHLIGHTED_FILTER)
      end
    end
  end
end
