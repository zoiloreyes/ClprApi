module ClprApi
  module Serializers
    class SolrPhotoSerializer
      NON_RESIZABLE_IMAGES = [".gif"].freeze

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
  end
end
