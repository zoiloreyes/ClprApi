module ClprApi
  module Solr
    module Filters
      class RangeFilter < Base
        def any?
          (min + max).positive?
        end

        def min
          @min ||= (range_field? ? field.options.first : filter_options.fetch("min", 0)).to_i
        end

        def max
          @max ||= (range_field? ? field.options.last : filter_options.fetch("max", 0)).to_i
        end

        def properties
          {
            min: min,
            max: max,
          }
        end

        private

        def range_field?
          field.value == "range" && field.options.present?
        end
      end
    end
  end
end
