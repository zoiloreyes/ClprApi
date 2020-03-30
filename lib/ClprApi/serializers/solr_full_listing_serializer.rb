module ClprApi
  module Serializers
    class SolrFullListingSerializer
      include ClprApi::Solr::FieldSupport

      attr_reader :listing

      def initialize(listing)
        @listing = listing
      end

      def as_json(*)
        data_with_solr_type_suffix
      end

      def data_with_solr_type_suffix
        @data_with_solr_type_suffix ||= begin
            json_data.reduce({}) { |hash, item|
              if item.first == "id"
                hash[item.first] = item.last
              else
                hash[field(nil, item.first, item.last)] = format_field_value_for_solr_serialization(item.last)
              end
              hash
            }
          end
      end

      def json_data
        @json_data ||= serialized_listing.merge(serialized_offering)
          .merge(preffix_hash_keys_with("area", serialized_area))
          .merge(preffix_hash_keys_with("lister", serialized_lister))
          .merge(preffix_hash_keys_with("business", serialized_business))
          .merge(preffix_hash_keys_with("business_industry", serialized_business_industry))
          .merge(preffix_hash_keys_with("category", serialized_category))
          .merge(preffix_hash_keys_with("category_config", serialized_category_config))
          .merge(serialized_extra_attributes)
          .merge(preffix_hash_keys_with("photos", serialized_photos)).stringify_keys.compact
      end

      def positive?(value)
        value if value&.positive?
      end

      def price_start_method
        "#{listing.offering}_price_start"
      end

      def price_end_method
        "#{listing.offering}_price_end"
      end

      def offering_price_start
        return unless listing.respond_to?(price_start_method)

        value = listing.send(price_start_method)

        value if positive?(value)
      end

      def offering_price_end
        return unless listing.respond_to?(price_end_method)

        value = listing.send("#{listing.offering}_price_end") || offering_price_start

        value if positive?(value)
      end

      def serialized_offering
        offering = {}

        if offering_price_start
          offering["price_start"] = offering_price_start
        end

        if offering_price_end
          offering["price_end"] = offering_price_end
          offering["#{listing.offering}_price_end"] = offering_price_end
        end

        if listing.respond_to?("#{listing.offering}_price_unit")
          offering["price_unit"] = listing.send("#{listing.offering}_price_unit").to_s
        end

        if listing.respond_to?("#{listing.offering}_price_conditions")
          offering["price_conditions"] = listing.send("#{listing.offering}_price_conditions").to_s
        end

        if listing.respond_to?("#{listing.offering}_price_obo")
          offering["price_obo"] = listing.send("#{listing.offering}_price_obo")
        end

        offering
      end

      def serialized_listing
        ClprApi::Serializers::SolrListingSerializer.new(listing).as_json(root: nil)
      end

      def serialized_extra_attributes
        ClprApi::Serializers::SolrListingExtraFieldsSerializer.new(listing.fields).as_json
      end

      def serialized_photos
        ClprApi::Serializers::SolrListingPhotoSerializer.new(listing).as_json(root: nil)
      end

      def serialized_category
        ClprApi::Serializers::SolrCategorySerializer.new(listing.listing_category).as_json(root: nil)
      end

      def serialized_category_config
        ClprApi::Serializers::SolrCategoryConfigSerializer.new(listing.listing_category.listing_category_config).as_json(root: nil)
      end

      def serialized_area
        ClprApi::Serializers::SolrAreaSerializer.new(listing.area_record).as_json(root: nil)
      end

      def serialized_lister
        ClprApi::Serializers::SolrListerSerializer.new(listing.account_or_inner_account).as_json(root: nil)
      end

      def serialized_business
        ClprApi::Serializers::SolrBusinessSerializer.new(listing.business_or_inner_business).as_json(root: nil)
      end

      def serialized_business_industry
        ClprApi::Serializers::SolrBusinessIndustrySerializer.new(listing.business_or_inner_business.industry).as_json(root: nil)
      end

      def preffix_hash_keys_with(preffix, hash)
        (hash || {}).reduce({}) { |collection, item|
          collection["#{preffix}_#{item.first}"] = item.last
          collection
        }
      end
    end
  end
end
