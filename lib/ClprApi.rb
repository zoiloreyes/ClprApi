require "ClprApi/version"
require "active_support/all"
require "active_model_serializers"
require "addressable"
require "rsolr"
require "faraday"
require "versionable"
require "versionable/version"
require "ClprApi/utils/records_tree_builder"
require "ClprApi/utils/group_hash_by_prop"
require "ClprApi/solr/connection"
require "ClprApi/solr/field_support"
require "ClprApi/support/thumbor_image"

require "ClprApi/support/youtube/url_or_hash_validation"
require "ClprApi/support/json_serializable_attributes"
require "ClprApi/support/attributes_from_hash_with_string_keys_initializer"
require "ClprApi/support/youtube/url_or_hash_values"
require "ClprApi/support/youtube/url"
require "ClprApi/support/extra_field_metadata"
require "ClprApi/support/extra_field"

require "ClprApi/serializers/solr_business_industry_serializer"
require "ClprApi/serializers/business_photo_serializer"
require "ClprApi/serializers/solr_photo_serializer"
require "ClprApi/serializers/business_industry_from_serialized_listing"
require "ClprApi/serializers/business_from_serialized_listing"
require "ClprApi/serializers/business_serializer"
require "ClprApi/serializers/category_config_serializer"
require "ClprApi/serializers/industry_serializer"
require "ClprApi/serializers/listing_field_serializer"
require "ClprApi/serializers/listing_photo_serializer"
require "ClprApi/serializers/listing_serializer"
require "ClprApi/serializers/solr_area_serializer"
require "ClprApi/serializers/solr_business_serializer"
require "ClprApi/serializers/solr_category_config_serializer"
require "ClprApi/serializers/solr_category_serializer"
require "ClprApi/serializers/solr_extra_fields_metadata_serializer"
require "ClprApi/serializers/solr_lister_serializer"
require "ClprApi/serializers/solr_listing_extra_fields_serializer"
require "ClprApi/serializers/solr_listing_photo_serializer"
require "ClprApi/serializers/solr_listing_serializer"

require "ClprApi/solr/query/filter_collection_from_params"
require "ClprApi/listings/serialized_fields_support"
require "ClprApi/solr/query/query_params"
require "ClprApi/solr/filters/node"
require "ClprApi/solr/query/random_sorter"
require "ClprApi/solr/filters/builder"
require "ClprApi/solr/filters/base"
require "ClprApi/solr/filters/options_filter"
require "ClprApi/solr/filters/dynamic_options_filter"
require "ClprApi/solr/filters/range_filter"
require "ClprApi/solr/filters/boolean_filter"
require "ClprApi/solr/filters/item"
require "ClprApi/solr/filters/options_with_level_filter"
require "ClprApi/solr/filters/range_option_filter"
require "ClprApi/solr/filters/price_filter"
require "ClprApi/solr/filters/string_filter"
require "ClprApi/solr/query/price_filter_parser"
require "ClprApi/solr/query/query_sorter"
require "ClprApi/solr/query/virtual_filter"
require "ClprApi/solr/query/virtual_fields"
require "ClprApi/solr/response"
require "ClprApi/solr/query"
require "ClprApi/listings/serialized_fields_support_for_listing"
require "ClprApi/listings/filter_builder_by_api_key"
require "ClprApi/listings/get_listings"
require "ClprApi/listings/get_listing"
require "ClprApi/listings/get_listings_by_business"
require "ClprApi/solr/facetable_field"

module ClprApi
  class Error < StandardError; end

  class << self
    attr_writer :cache
    attr_writer :listing_serializer_klass

    def listing_serializer_klass
      Serializers::ListingSerializer
    end

    def cache
      @cache ||= ActiveSupport::Cache::NullStore.new
    end
  end

  Versionable.configure do
    thumbor_server ENV.fetch("THUMBOR_SERVER")
    secret_key ENV.fetch("SECRET_KEY")
  end
end
