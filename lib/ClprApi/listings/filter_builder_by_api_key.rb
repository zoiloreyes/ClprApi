module ClprApi
  module Listings
    class FilterBuilderByApiKey
      SEARCH_CONDITIONS_KEYS = ["lister", "business"].freeze

      attr_reader :key

      def initialize(key)
        @key = key
      end

      def api_key
        @api_key ||= ApiKey.find_by!(key: key)
      end

      def self.call(key)
        new(key).query_params
      end

      def query_params
        params = grouped_filters

        search_conditions = SEARCH_CONDITIONS_KEYS.map do |key|
          if value = params.delete(key)
            "#{self.class.name}::Filters::#{key.classify}".constantize.new(value.first).filter
          end
        end.compact

        {
          params: params,
          search_conditions: search_conditions,
        }
      end

      def grouped_filters
        @grouped_filters ||= begin
          _grouped_filters = api_key.api_key_filters.group_by(&:field)

          _grouped_filters.map do |(key, filters)|
            { key => filters.map(&:value).map(&:parameterize) }
          end.inject({}) do |hash, set|
            hash[set.keys.first] = set.values.flatten
            hash
          end.merge(has_photos: true)
        end
      end

      module Filters
        class Base
          attr_reader :value

          def initialize(value)
            @value = value
          end
        end

        class Lister < Base
          def filter
            @filter ||= "lister_id_i:(#{value})"
          end
        end

        class Business < Base
          def filter
            @filter ||= "business_slug_s:(#{value})"
          end
        end
      end
    end
  end
end
