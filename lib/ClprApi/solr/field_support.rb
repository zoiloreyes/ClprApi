module ClprApi
  module Solr
    module FieldSupport
      DATE_FORMAT = "%Y-%m-%dT%H:%M:%SZ".freeze

      FIELD_TYPE_SUFFIX = {
        boolean: "_b",
        complex: "_s",
        date: "_d",
        float: "_f",
        integer: "_i",
        option: "_i",
        range: "_i",
        optionlist: "_im",
        text: "_s",
        string: "_s",
        option_string: "_s",
      }.freeze

      DEFAULT_FIELD_TYPE = "_s".freeze

      def solr_field_suffix_for(field)
        FIELD_TYPE_SUFFIX[field.value.to_sym]
      end

      def cast_solr_type(field)
        value = field.raw_value

        return nil if value.nil?
        return "" if value.blank?

        case field.field_type
        when "boolean"
          value == "1" ? true : false
        when "date"
          DateTime.parse(value).utc.strftime(DATE_FORMAT) rescue ""
        when "complex"
          value.to_s
        when "float"
          value.to_f
        when "integer"
          value.to_i
        when "range"
          field.field_value.to_i
        when "option", "optionlist"
          value_for_option(field)
        when "string"
          string_options_for(field)
        else
          value.to_s
        end
      end

      def format_field_value_for_solr_serialization(value)
        case value
        when Date, Time, DateTime
          value.utc.strftime(DATE_FORMAT)
        when Float, BigDecimal
          value.to_f
        else
          value
        end
      end

      def infer_solr_type(value)
        case value
        when TrueClass, FalseClass
          "_b"
        when Date, Time, DateTime
          "_d"
        when Integer
          "_i"
        when Float, BigDecimal
          "_f"
        when Array
          ""
        else
          "_s"
        end
      end

      def field(type, field, value = nil)
        suffix = FIELD_TYPE_SUFFIX[type] || infer_solr_type(value) || DEFAULT_FIELD_TYPE
        "#{field}#{suffix}".gsub("_$INTEGER", "").gsub("_$STRING", "").gsub("_$FLOAT", "").gsub("_$DATE_s", "_d")
      end
    end
  end
end
