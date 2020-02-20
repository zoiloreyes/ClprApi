module ClprApi
  module Solr
    module Filters
      class OptionsFilter < Base
        def properties
          @properties ||= {
            items: listable_options,
          }
        end

        delegate :each, :map, :select, :to_a, to: :listable_options

        def listable_options
          @listable_options ||= filter_options.each_slice(2).map { |(option_id, count)|
            next unless count.positive?

            field_option = find_option(option_id)

            Solr::Filters::Item.new(id: option_id, label: field_option.label, slug: field_option.slug, count: count, selected: selected_ids.include?(option_id)) if field_option
          }.compact.sort_by(&:label)
        end

        private

        def selected_ids
          super.map do |value|
            value.is_a?(Query::VirtualFields::VirtualOption) ? value.id : value
          end
        end

        def find_option(option_id)
          field.options.find { |option| option.id.to_s == option_id }
        end
      end
    end
  end
end
