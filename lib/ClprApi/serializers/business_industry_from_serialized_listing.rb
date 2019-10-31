module ClprApi
  module Serializers
    class BusinessIndustryFromSerializedListing
      alias_method :read_attribute_for_serialization, :send
      attr_reader :id, :name, :slug, :description, :category_slug

      def initialize(attrs)
        @id = attrs["business_industry_id"]
        @name = attrs["business_industry_name"]
        @slug = attrs["business_industry_slug"]
        @description = attrs["business_industry_description"]
        @category_slug = attrs["business_industry_category_slug"]
      end
    end
  end
end
