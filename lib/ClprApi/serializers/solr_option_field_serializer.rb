module ClprApi
  module Serializers
    class SolrOptionFieldSerializer
      attr_reader :field

      def initialize(field)
        @field = field
      end

      def as_json
        {
          "#{field.field_id}_$INTEGER" => field_raw_value,
          "#{field.field_id}_$STRING" => field_value,
          "#{field.field_id}_slug_$STRING" => field_slug,
          "#{field.field_id}_json_$STRING" => field_option,
        }
      end

      def field_slug
        field.slug
      end

      def field_value
        field.field_value
      end

      def field_raw_value
        field.raw_value.to_i
      end

      def field_option
        {
          field_id: field.field_id,
          slug: field.slug,
          label: field.field_value,
          value: field.raw_value.to_i,
        }.to_json
      end

      def self.call(field)
        new(field).as_json
      end
    end
  end
end
