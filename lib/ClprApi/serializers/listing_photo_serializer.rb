module ClprApi
  module Serializers
    class ListingPhotoSerializer
      attr_reader :image

      def initialize(image)
        @image = image
      end

      IMAGES_VERSIONS = [:small, :medium, :large, :full].freeze

      NON_RESIZABLE_IMAGES = [".gif"].freeze

      IMAGES_VERSIONS.each do |method_name|
        define_method(method_name) do
          serialize_version(method_name)
        end
      end

      def versions
        @versions ||= Support::ThumborImage.new(self, :image) { |has|
          has.version :full, width: 1024, height: 768, fit_in: true # , fit_in: true
          has.version :large, width: 640, height: 480, fit_in: true
          has.version :medium, width: 320, height: 240
          has.version :small, width: 160, height: 120
        }.image
      end

      class ListingSizePhotoSerializer
        attr_reader :image, :version

        delegate :width, :height, to: :version

        def initialize(image, version)
          @image = image
          @version = version
        end

        def as_json(*)
          {
            url: url,
            width: version.width,
            height: version.height,
          }
        end

        def url
          @url ||= image_url_for(version)
        end

        def image_url_for(version)
          NON_RESIZABLE_IMAGES.include?(File.extname(image)) ? image : version.url
        end
      end

      def serialize_version(key)
        version = versions.public_send(key)

        ListingSizePhotoSerializer.new(image, version)
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
