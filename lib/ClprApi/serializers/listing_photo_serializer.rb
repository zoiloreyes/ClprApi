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
        @versions ||= GfrImageTransformer::Variations.for(image) do
          variant(:full) { resize(1024, 768, resizer_mode: :fill) }
          variant(:full_cropped) { resize(1024, 768) }
          variant(:large) { resize(640, 480, resizer_mode: :fill) }
          variant(:large_cropped) { resize(640, 480) }
          variant(:medium) { resize(320, 240) }
          variant(:small) { resize(160, 120) }
        end
      end

      def serialize_version(key)
        version = versions.fetch(key)

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
