module ClprApi
  module Solr
    module Filters
      class Base
        delegate :any?, to: :listable_options

        attr_reader :filter_options, :field, :selected_values, :total, :params

        def initialize(field, filter_options, selected_values, total, params)
          @field = field
          @filter_options = filter_options
          @selected_values = selected_values
          @total = total
          @params = params
        end

        def as_json(*)
          HashWithIndifferentAccess.new(
            properties.merge(
              type: field.value,
              label: field.label,
              field: field.field_id,
            ),
          )
        end

        def properties
          {}
        end

        def selected_ids
          @selected_ids ||= selected_values&.value || []
        end
      end
    end
  end
end
