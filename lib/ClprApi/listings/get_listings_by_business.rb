module ClprApi
  module Listings
    class GetListingsByBusiness < Listings::GetListings
      attr_reader :business_slug, :params, :listing_serializer_klass

      def initialize(business_slug:, params: {}, config: {}, search_conditions: [])
        @business_slug = business_slug
        @listing_serializer_klass = config.fetch(:listing_serializer_klass) { ClprApi.listing_serializer_klass }
        @search_conditions = search_conditions

        super(params: prepare_params(params), config: config, search_conditions: search_conditions)
      end

      def self.call(business_slug:, params: {}, config: {}, search_conditions: [])
        new(business_slug: business_slug, params: params, config: config, search_conditions: search_conditions)
      end

      def search_results_hash
        { business: business }.merge(super)
      end

      def search_conditions
        super.push(business_filter)
      end

      def business_filter
        "business_slug_s:(#{business_slug})"
      end

      def business
        @business ||= Serializers::BusinessSerializer.new(business_record, root: nil)
      end

      def business_record
        listing_from_business.business
      end

      private

      def listing_from_business
        @listing_from_business ||= ClprApi::Listings::GetListings.new(search_conditions: [business_filter], params: { limit: 1 }).items.last
      end

      def category_param_from_business_industry
        { category: business_record.industry.slug, filters_category_param: business_record.industry.category_slug }
      end

      def prepare_params(_params)
        params = _params.dup

        return params.reverse_merge(category_param_from_business_industry) if business_record.industry

        params
      end
    end
  end
end
