module ClprApi
  module Serializers
    class BusinessSerializer < ActiveModel::Serializer
      CDN_URL = "https://listamax.com/uploads".freeze
      S3_CDN_URL = "https://s3.amazonaws.com/media.listamax.com".freeze

      attributes :id, :name, :license, :phone, :phone_ext, :phone2, :phone2_ext, :phone2_ext, :address1, :address2, :city, :state, :country, :postal_code, :url, :logo_path, :logo, :slug, :industry, :location_string, :whatsapp_phone, :premium

      def industry
        @industry ||= Serializers::IndustrySerializer.new(object.industry) if object.respond_to?(:industry)
      end

      def s3_logo_url
        "#{S3_CDN_URL}/#{object.logo_path}" if object.logo_path.present?
      end

      def logo
        @logo ||= BusinessPhotoSerializer.new(s3_logo_url) if object.logo_path.present?
      end
    end
  end
end
