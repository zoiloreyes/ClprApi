module ClprApi
  module Serializers
    class ListingPhotoSerializer
      attr_reader :image

      def initialize(image)
        @image = image
      end

      IMAGES_VERSIONS = [:small, :medium, :large, :large_cropped, :full, :full_cropped].freeze

      IMAGES_VERSIONS.each do |method_name|
        define_method(method_name) do
          serialize_version(method_name)
        end
      end

      def versions
        @versions ||= Support::ThumborImage.new(self, :image) { |has|
          has.version :full, width: 1024, height: 768, fit_in: true
          has.version :full_cropped, width: 1024, height: 768
          has.version :large, width: 640, height: 480, fit_in: true
          has.version :large_cropped, width: 640, height: 480
          has.version :medium, width: 320, height: 240
          has.version :small, width: 160, height: 120
        }.image
      end

      def serialize_version(key)
        version = versions.public_send(key)

        SolrPhotoSerializer.new(image, version)
      end

      def as_json(*)
        IMAGES_VERSIONS.reduce({}) do |hash, key|
          hash[key] = serialize_version(key)
          hash
        end
      end
    end
  end
end
