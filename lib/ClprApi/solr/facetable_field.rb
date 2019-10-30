module ClprApi
  module Solr
    class FacetableField
      extend Forwardable

      attr_reader :field_id, :value, :label, :category_ids, :category_slugs, :is_facetable, :options
      alias_method :read_attribute_for_serialization, :send
      alias_method :id, :field_id

      def initialize(values)
        @value = values.fetch("value")
        @label = values.fetch("label")
        @field_id = values.fetch("field_id")
        @is_facetable = values.fetch("is_facetable")
        @options = values.fetch("options")
        @category_ids = values.fetch("category_ids")
        @category_slugs = values.fetch("category_slugs")
      end

      class << self
        def all
          raw_api_response.map { |field| new(field) }
        end

        def find(field_slug)
          field = raw_api_response.find { |_field| _field["field_id"] == field_slug }

          new(field) if field
        end

        def raw_api_response
          ClprApi.cache.fetch("FACETABLE_FIELDS_METADATA", expires_in: 1.hour) do
            HTTParty.get("#{api_url}/facetable_fields").parsed_response
          end
        end

        def api_url
          ENV.fetch("CONSOLE_API")
        end
      end
    end
  end
end
