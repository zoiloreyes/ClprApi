module ClprApi
  module Listings
    class GetListingsByBusiness < Listings::GetListings
      attr_reader :business_slug, :params

      def initialize(business_slug:, params: {}, search_conditions: [])
        @business_slug = business_slug
        super(params: prepare_params(params), search_conditions: search_conditions)
      end

      def self.call(business_slug:, params: {})
        new(business_slug: business_slug, params: params)
      end

      def as_json(*)
        { business: business }.merge(super)
      end

      def search_conditions
        super.push(business_filter)
      end

      def business_filter
        "business_slug_s:(#{business.slug})"
      end

      def business
        @business ||= Serializers::BusinessSerializer.new(business_record, root: nil)
      end

      def business_record
        @business_record ||= Business.find_by!(slug: business_slug)
      end

      private

      def category_param_from_business_industry
        { category: business_record.industry.slug, filters_category_param: business_record.industry.category_slug }
      end

      def prepare_params(_params)
        params = _params.dup

        if business_record.industry
          params.permit!.reverse_merge(category_param_from_business_industry) if business_record.industry
        else
          params.permit!
        end
      end
    end
  end
end
