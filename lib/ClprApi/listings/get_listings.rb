module ClprApi
  module Listings
    class GetListings
      include Listings::SerializedFieldsSupport

      attr_reader :params, :search_conditions, :listing_serializer_klass

      def initialize(params: {}, config: {}, search_conditions: [])
        api_key = params[:api_key]
        @listing_serializer_klass = config.fetch(:listing_serializer_klass) { ClprApi.listing_serializer_klass }

        if api_key
          conditions_by_api_key = Listings::FilterBuilderByApiKey.call(api_key)
          @params = params.reverse_merge(conditions_by_api_key[:params])
          @search_conditions = search_conditions + conditions_by_api_key[:search_conditions]
        else
          @params = params
          @search_conditions = search_conditions
        end
      end

      def self.call(params: {}, config: {}, search_conditions: [])
        new(params: params, config: config, search_conditions: search_conditions)
      end

      def as_json(*)
        HashWithIndifferentAccess.new(
          filters: response.filters,
          total: total,
          total_pages: total_pages,
          current_page: current_page,
          items: items,
          fields: fields,
        )
      end

      def items
        @items ||= data.response.fetch("docs").map { |doc| listing_serializer_klass.new(doc) }
      end

      def query
        @query ||= Solr::Query.new(params: params, search_conditions: search_conditions)
      end

      private

      def extra_fields_ids
        items.map { |item| item["extra_fields"] }.flatten.uniq
      end

      def data
        @data ||= query.response
      end

      delegate :regular_filters, :stats_filters, :filters, to: :data

      delegate :total, :total_pages, :current_page, :search_query, :response, to: :query
    end
  end
end
