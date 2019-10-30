module ClprApi
  module Serializers
    class SolrListingExtraFieldsSerializer
      include Solr::FieldSupport

      attr_reader :fields

      def initialize(fields)
        @fields = fields
      end

      def as_json(*)
        cast_extra_attributes(fields)
      end

      private

      def cast_extra_attributes(attrs)
        attrs.inject({}) { |hash, item|
          if item.has_options? || item.string_field?
            hash.merge(cast_solr_type(item))
          else
            hash[name_for(item)] = cast_solr_type(item)
            hash
          end
        }
      end

      def name_for(field)
        if field.field_type == "date"
          "#{field.field_id}_$DATE"
        else
          field.field_id
        end
      end

      def string_options_for(field)
        {
          "#{field.field_id}_$STRING" => field.field_value,
          "#{field.field_id}_slug_$STRING" => field.field_value.parameterize,
        }
      end

      def value_for_option(field)
        if (field.field_type == "option")
          {
            "#{field.field_id}_$INTEGER" => field.raw_value.to_i,
            "#{field.field_id}_$STRING" => field.field_value,
            "#{field.field_id}_slug_$STRING" => field.slug,
            "#{field.field_id}_json_$STRING" => {
              field_id: field.field_id,
              slug: field.slug,
              label: field.field_value,
              value: field.raw_value.to_i,
            }.to_json,
          }
        elsif (field.field_type == "optionlist")
          {
            "#{field.field_id}_im" => field.options.map(&:raw_value),
            "#{field.field_id}_sm" => field.options.map(&:field_value),
            "#{field.field_id}_slug_sm" => field.options.map(&:slug),
            "#{field.field_id}_json_sm" => field.options.map { |option|
              {
                field_id: field.field_id,
                slug: option.slug,
                label: field.field_value,
                value: field.raw_value.to_i,
              }.to_json
            },
          }
        end
      end
    end
  end
end
