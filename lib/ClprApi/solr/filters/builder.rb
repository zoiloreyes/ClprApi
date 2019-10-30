module ClprApi
  module Solr
    module Filters
      class Builder
        class << self
          def options(items, fields, selected_values, total, params)
            items.inject({}) do |hash, (key, filter_options)|
              field = fields.find { |item| item.field_id == key }

              next hash if filter_options.blank? || !field

              selected = selected_values.find { |value| value.field_id == key }

              filter_class = if ["category", "area"].include?(key)
                               Filters::OptionsWithLevelFilter
                             else
                               case field.value
                               when "option", "optionlist" then Filters::DynamicOptionsFilter
                               when "range" then Filters::RangeOptionFilter
                               when "boolean" then Filters::BooleanFilter
                               when "string" then Filters::StringFilter
                               else Filters::OptionsFilter
                               end
                             end

              hash[key] = filter_class.new(field, filter_options, selected, total, params) if filter_options.any?

              hash
            end
          end

          def stats(items, fields, selected_values, total, params)
            items.reduce({}) do |hash, (key, filter_options)|
              field_id = key.split("_")[0..-2].join("_")
              field = fields.find { |item| item.field_id == field_id }
              selected = selected_values.find { |value| value.field_id == key }

              next hash if filter_options.blank?

              hash[field_id] = Filters::RangeFilter.new(field, filter_options, selected, total, params)

              hash
            end
          end
        end
      end
    end
  end
end
