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
        @versions ||= GfrImageTransformer::Variations.for(image) do
          variant(:large) { resize(480, 480) }
          variant(:medium) { resize(320, 320) }
          variant(:small) { resize(240, 240) }
          variant(:thumbnail) { resize(320, 240, resizer_mode: :fill) }
        end
      end

      def serialize_version(key)
        version = versions.fetch(key)

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
