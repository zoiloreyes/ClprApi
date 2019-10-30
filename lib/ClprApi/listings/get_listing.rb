module ClprApi
  module Listings
    class GetListing
      include SerializedFieldsSupportForListing
      include Solr::FieldSupport

      def initialize(id, config = {})
        @id = id
        @listing_serializer_klass = config.fetch(:listing_serializer_klass) { ClprApi.listing_serializer_klass }
      end

      def self.call(id, config = {})
        new(id, config)
      end

      def as_json(*)
        {
          fields: fields,
          item: item,
        }
      end

      def extra_fields_ids
        @extra_fields_ids ||= item["extra_fields"].to_a
      end

      def item
        @item ||= listing_serializer_klass.new(response)
      end

      def response
        @response ||= Solr::Connection.instance.find_by_id_with_params(id, query_params)
      end

      private

      def query_params
        {
          fq: active_listings_filter,
        }
      end

      def current_date_formatted
        @current_date_formatted ||= Date.today.strftime(DATE_FORMAT)
      end

      def active_listings_filter
        ["{!tag=active}( ( expires_on_d: { #{current_date_formatted} TO * } ) )"]
      end

      attr_reader :id, :listing_serializer_klass
    end
  end
end
