module ClprApi
  module Serializers
    class BusinessFromSerializedListing
      alias_method :read_attribute_for_serialization, :send
      attr_reader :id, :name, :license, :phone, :phone_ext, :phone2, :phone2_ext, :address1, :address2, :city, :state, :country, :postal_code, :url, :logo_path, :slug, :business_industry_id, :industry, :location_string
      attr_reader :attrs

      def initialize(attrs)
        @attrs = attrs
        @id = attrs["business_id"]
        @url = attrs["business_url"]
        @name = attrs["business_name"]
        @slug = attrs["business_slug"]
        @city = attrs["business_city"]
        @phone = attrs["business_phone"]
        @state = attrs["business_country"]
        @address1 = attrs["business_address1"]
        @logo_path = attrs["business_logo_path"].to_s
        @business_industry_id = attrs["business_industry_id"]
        @industry = BusinessIndustryFromSerializedListing.new(attrs)
      end
    end
  end
end
