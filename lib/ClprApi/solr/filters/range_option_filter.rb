module ClprApi
  module Solr
    module Filters
      class RangeOptionFilter < RangeFilter
        DEFAULT_MIN = 0
        DEFAULT_MAX = 0

        def initialize(field, fields_metadata, selected_values, total, params)
          options = {
            "min" => (field.options.first || DEFAULT_MIN).to_i,
            "max" => (field.options.last || DEFAULT_MAX).to_i,
          }

          super(field, options, selected_values, total, params)
        end
      end
    end
  end
end
