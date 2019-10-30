module ClprApi
  module Solr
    module Filters
      class Node
        include Solr::FieldSupport

        delegate :field_id, to: :field

        attr_reader :field, :param_value

        def initialize(field, param_value)
          @field = field
          @param_value = parse_param(param_value)
        end

        def parse_param(value)
          case value
          when Array
            value
          else
            value.to_s.split(",")
          end
        end

        def suffix
          @suffix ||= solr_field_suffix_for(field)
        end

        def solr_field
          @solr_field ||= "#{field.field_id}#{suffix}"
        end

        def value
          @value ||= options.select { |option| param_value.include?(option.slug) }
        end

        def options
          field.options
        end

        def values
          @values ||= value.compact.map(&:id)
        end

        def filter
          "{!tag=#{field.field_id}}( ( #{solr_field}: (#{values.join(" OR ")}) ) )"
        end

        def as_json(*)
          return {} if value.blank?

          {
            field_id: field_id,
            solr_field: solr_field,
            param_value: param_value,
            values: values,
            filter: filter,
          }
        end

        def valid?
          values.any?
        end

        class << self
          def node_class_for(field)
            case field.value
            when "boolean"
              BooleanNode
            when "price"
              PriceNode
            when "integer", "float", "range"
              RangeNode
            when "string"
              StringNode
            when "option"
              OptionNode
            when "optionlist"
              OptionListNode
            else
              Node
            end
          end

          def for(field, params)
            field_param = params[field.field_id]

            node_class_for(field).new(field, field_param) if field_param
          end
        end
      end

      class OptionNode < Node
        def value
          Array(param_value).compact
        end

        def values
          value
        end

        def filter
          "{!tag=#{field.field_id}}( ( #{field.field_id}_slug_s: (#{values.join(" OR ")}) ) )"
        end
      end

      class OptionListNode < OptionNode
        def filter
          "{!tag=#{field.field_id}}( ( #{field.field_id}_slug_sm: (#{values.join(" OR ")}) ) )"
        end
      end

      class StringNode < Node
        def valid?
          param_value.present?
        end

        def filter
          "{!tag=#{field.field_id}}( ( #{solr_field}lug_s: (#{param_value.join(" OR ")}) ) )"
        end
      end

      class BooleanNode < Node
        def filter
          "{!tag=#{field.field_id}}( ( #{solr_field}: (#{values.join(" OR ")}) ) )"
        end

        def options
          boolean_options
        end

        def boolean_options
          [
            OpenStruct.new(id: "true", slug: "true"),
            OpenStruct.new(id: "false", slug: "false"),
          ]
        end
      end

      class RangeNode < Node
        def filter
          "{!tag=#{field.field_id}}( #{solr_field}: [ #{start} TO #{last} ] )"
        end

        def valid?
          first_value? || last_value?
        end

        private

        def first_value
          @first_value ||= param_value.first.to_i
        end

        def last_value
          @last_value ||= param_value.second.to_i
        end

        def first_value?
          first_value.positive?
        end

        def last_value?
          last_value.positive?
        end

        def start
          @start ||= first_value? ? first_value : "*"
        end

        def last
          @last ||= last_value? ? last_value : "*"
        end
      end

      class PriceNode < RangeNode
        def filter
          "{!tag=price}( price_end_f: [ #{start} TO #{last} ] )"
        end
      end
    end
  end
end
