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
          variant(:full) { resize(1024, 768, resizer_mode: :inside).with_background(:white).jpeg }
          variant(:full_cropped) { resize(1024, 768).with_background(:white).jpeg }
          variant(:large) { resize(640, 480, resizer_mode: :inside).with_background(:white).jpeg }
          variant(:large_cropped) { resize(640, 480).with_background(:white).jpeg }
          variant(:medium) { resize(320, 240, resizer_mode: :contain, fill_color: :white).with_background(:white).jpeg }
          variant(:small) { resize(160, 120).with_background(:white).jpeg }
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
