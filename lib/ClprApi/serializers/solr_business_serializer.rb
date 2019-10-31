module ClprApi
  module Serializers
    class SolrBusinessSerializer < ActiveModel::Serializer
      attributes :id, :name, :license, :phone, :phone_ext, :phone2, :phone2_ext, :phone2_ext, :address1, :address2, :city, :state, :country, :postal_code, :url, :logo_path, :slug

      def logo_path
        object.s3_logo || legacy_business_logo
      end

      def legacy_business_logo
        object.logo_path&.split("uploads/")&.last
      end
    end
  end
end
