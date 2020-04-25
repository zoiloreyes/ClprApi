module ClprApi
  module Serializers
    class SolrOptionListFieldSerializer
      attr_reader :field

      def initialize(field)
        @field = field
      end

      def as_json
        {
          "#{field.field_id}_im" => field_raw_values,
          "#{field.field_id}_sm" => field_values,
          "#{field.field_id}_slug_sm" => field_slugs,
          "#{field.field_id}_json_sm" => field_options,
        }
      end

      def field_raw_values
        field.options.map(&:raw_value)
      end

      def field_values
        field.options.map(&:field_value)
      end

      def field_slugs
        field.options.map(&:slug)
      end

      def field_options
        field.options.map { |option|
          {
            field_id: field.field_id,
            slug: option.slug,
            label: field.field_value,
            value: field.raw_value.to_i,
          }.to_json
        }
      end

      def self.call(field)
        new(field).as_json
      end
    end
  end
end
