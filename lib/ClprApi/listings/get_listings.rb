module ClprApi
  module Listings
    class GetListings
      include Listings::SerializedFieldsSupport

      attr_reader :params, :search_conditions, :listing_serializer_klass, :serializer_params, :cache_ttl

      def initialize(params: {}, config: {}, search_conditions: [])
        _params = prepare_params(params)

        api_key = _params[:api_key]
        @listing_serializer_klass = config.fetch(:listing_serializer_klass) { ClprApi.listing_serializer_klass }
        @serializer_params = config.fetch(:serializer_params) { {} }
        @cache_ttl = config[:cache_ttl]

        if api_key
          conditions_by_api_key = Listings::FilterBuilderByApiKey.call(api_key)
          @params = _params.reverse_merge(conditions_by_api_key[:params])
          @search_conditions = search_conditions + conditions_by_api_key[:search_conditions]
        else
          @params = _params
          @search_conditions = search_conditions
        end
      end

      def self.call(params: {}, config: {}, search_conditions: [])
        new(params: params, config: config, search_conditions: search_conditions)
      end

      def as_json(*)
        search_results.as_json
      end

      def search_results_hash
        @search_results_hash ||= ClprApi.cache_enabled? ? cached_results : raw_results
      end

      def search_results
        @search_results ||= SearchResults.new(search_results_hash)
      end

      def items
        @items ||= data.response.fetch("docs").map { |doc| listing_serializer_klass.new(doc).with_params_for_serialization(serializer_params) }
      end

      def query
        @query ||= Solr::Query.new(params: params, search_conditions: search_conditions).with_cache_ttl(cache_ttl)
      end

      private

      def extra_fields_ids
        items.map { |item| item["extra_fields"] }.flatten.uniq
      end

      def data
        @data ||= query.response
      end

      def prepare_params(_params = {})
        params = _params.dup.to_h.with_indifferent_access
        _filters = params.delete(:filters) || {}

        params.merge(_filters).with_indifferent_access
      end

      def cache_key
        @cache_key ||= "#{self.class.name}-#{query.cache_key}"
      end

      def cached_results
        ClprApi.cache.fetch(cache_key) { raw_results }
      end

      def raw_results
        {
          filters: response.filters,
          total: total,
          total_pages: total_pages,
          current_page: current_page,
          items: items,
          fields: fields,
        }
      end

      delegate :regular_filters, :stats_filters, :filters, to: :data

      delegate :total, :total_pages, :current_page, :search_query, :response, to: :query
    end
  end
end
