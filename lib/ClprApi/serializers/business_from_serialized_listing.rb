module ClprApi
  module Serializers
    class BusinessFromSerializedListing
      alias_method :read_attribute_for_serialization, :send
      attr_reader :id, :name, :license, :phone, :phone_ext, :phone2, :phone2_ext, :address1, :address2, :city, :state, :country, :postal_code, :url, :logo, :slug

      def initialize(attrs)
        @id = attrs["business_id"]
        @name = attrs["business_name"]
        @phone = attrs["business_phone"]
        @address1 = attrs["business_address1"]
        @city = attrs["business_city"]
        @state = attrs["business_country"]
        @url = attrs["business_url"]
        @logo = attrs["business_logo"].to_s
        @slug = attrs["business_slug"]
      end

      def s3_logo
        logo if logo.start_with?("logo")
      end

      def logo_path
        logo
      end
    end
  end
end
