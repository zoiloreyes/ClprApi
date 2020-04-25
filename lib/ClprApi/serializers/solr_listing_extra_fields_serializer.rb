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
        attrs.reduce({}) { |hash, item|
          if item.has_options? || item.string_field?
            hash.merge(cast_solr_type(item))
          else
            hash[name_for(item)] = cast_solr_type(item)
            hash
          end
        }
      end

      def name_for(field)
        return "#{field.field_id}_$DATE" if field.field_type == "date"

        field.field_id
      end

      def string_options_for(field)
        {
          "#{field.field_id}_$STRING" => field.field_value,
          "#{field.field_id}_slug_$STRING" => field.field_value.parameterize,
        }
      end

      def value_for_option(field)
        case field.field_type
        when "option"
          SolrOptionFieldSerializer.call(field)
        when "optionlist"
          SolrOptionListFieldSerializer.call(field)
        end
      end
    end
  end
end
