module ClprApi
  module Solr
    module Filters
      class DynamicOptionsFilter < OptionsFilter
        def options
          @options ||= filter_options.each_slice(2).map { |(option, count)|
            JSON.parse(option).merge("count" => count)
          }
        end

        def listable_options
          @listable_options ||= options.map { |option|
            next unless option["count"].positive?

            Solr::Filters::Item.new(
              id: option["value"],
              label: option["label"],
              slug: option["slug"],
              count: option["count"],
              selected: selected_ids.include?(option["slug"]),
            )
          }.compact.sort_by(&:label)
        end
      end
    end
  end
end
