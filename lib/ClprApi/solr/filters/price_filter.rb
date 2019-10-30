module ClprApi
  module Solr
    module Filters
      class PriceFilter < RangeFilter
        DEFAULT_MIN = { "min" => 0 }.freeze
        DEFAULT_MAX = { "max" => 0 }.freeze

        def self.build(data, fields_metadata, selected_values, total, params)
          options = {
            "min" => (data.fetch("price_start_f") || DEFAULT_MIN).fetch("min"),
            "max" => (data.fetch("price_end_f") || DEFAULT_MAX).fetch("max"),
          }

          field = fields_metadata.find { |f| f.field_id == "price" }

          new(field, options, selected_values, total, params)
        end
      end
    end
  end
end
