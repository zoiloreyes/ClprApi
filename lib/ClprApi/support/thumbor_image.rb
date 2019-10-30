module ClprApi
  module Support
    class ThumborImage
      def initialize(model, data_method, versions = nil)
        @model = model
        @method = data_method

        image = VersionsAccumulator.new
        yield(image) if block_given?

        @versions = versions || image.versions
      end

      def image
        versions = versions_hash
        Versionable::Image.new(model, method) do
          versions.each do |version_name, version_opts|
            version version_name, version_opts
          end
        end
      end

      private

      attr_reader :model, :method, :versions

      def versions_hash
        @versions_hash ||= versions.reduce({}, :update)
      end

      class VersionsAccumulator
        attr_accessor :versions

        def initialize
          @versions = []
        end

        def version(name, params)
          versions << { name => params }
        end
      end
    end
  end
end
