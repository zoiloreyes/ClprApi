module ClprApi
  module Listings
    class FilterBuilderByApiKey
      SEARCH_CONDITIONS_KEYS = ["lister", "business"].freeze

      attr_reader :api_key

      def initialize(api_key)
        @api_key = api_key
      end

      def self.call(api_key)
        new(api_key).query_params
      end

      def query_params
        params = api_response

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

      private

      def api_url
        ENV.fetch("CONSOLE_API")
      end

      def api_response
        @api_response ||= JSON.parse(ClprApi.cache.fetch("API-KEY-CONFIGURATION-FOR-#{api_key}", expires_in: 1.hour) do
          HTTParty.get("#{api_url}/api_keys/#{api_key}").parsed_response.to_json
        end)
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
