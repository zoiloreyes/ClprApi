module ClprApi
  module Serializers
    class BusinessSerializer < ActiveModel::Serializer
      CDN_URL = "https://listamax.com/uploads".freeze
      S3_CDN_URL = "https://s3.amazonaws.com/media.listamax.com".freeze

      attributes :id, :name, :license, :phone, :phone_ext, :phone2, :phone2_ext, :phone2_ext, :address1, :address2, :city, :state, :country, :postal_code, :url, :logo, :slug, :business

      def business
        @business ||= Api::IndustrySerializer.new(object.industry) if object.respond_to?(:industry)
      end

      IMAGES_VERSIONS = [:small, :medium, :large, :thumbnail].freeze

      def logo
        return nil unless valid_logo?

        IMAGES_VERSIONS.reduce({}) do |hash, key|
          hash[key] = serialize_version(key)
          hash
        end
      end

      def versions
        @versions ||= Support::ThumborImage.new(self, :s3_logo_url) { |has|
          has.version :large, { width: 480, height: 480, fit_in: true }
          has.version :medium, { width: 320, height: 320, fit_in: true }
          has.version :small, { width: 240, height: 240, fit_in: true }
          has.version :thumbnail, { width: 320, height: 240 }
        }.image
      end

      def serialize_version(key)
        version = versions.public_send(key)

        {
          url: version.url,
          width: version.width,
          height: version.height,
        }
      end

      def s3_logo_url
        "#{S3_CDN_URL}/#{object.logo}" if object.logo.present?
      end

      def valid_logo?
        s3_logo_url.present?
      end
    end
  end
end
