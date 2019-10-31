module ClprApi
  module Serializers
    class BusinessPhotoSerializer
      attr_reader :image

      def initialize(image)
        @image = image
      end

      IMAGES_VERSIONS = [:small, :medium, :large, :thumbnail].freeze

      IMAGES_VERSIONS.each do |method_name|
        define_method(method_name) do
          return if image.blank?

          serialize_version(method_name)
        end
      end

      def versions
        @versions ||= Support::ThumborImage.new(self, :image) { |has|
          has.version :large, width: 480, height: 480, fit_in: true
          has.version :medium, width: 320, height: 320, fit_in: true
          has.version :small, width: 240, height: 240, fit_in: true
          has.version :thumbnail, width: 320, height: 240
        }.image
      end

      def serialize_version(key)
        version = versions.public_send(key)

        SolrPhotoSerializer.new(image, version)
      end

      def as_json(*)
        return if image.blank?

        IMAGES_VERSIONS.reduce({}) do |hash, key|
          hash[key] = serialize_version(key)
          hash
        end
      end
    end
  end
end
