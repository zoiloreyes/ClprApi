module ClprApi
  module Solr
    module Filters
      class BooleanFilter < Base
        def properties
          @properties ||= {
            items: listable_options,
          }
        end

        def listable_options
          return [] unless filter_options.first == "true"

          [
            Solr::Filters::Item.new(id: "true", label: "Si", slug: "true", count: filter_options.last),
            Solr::Filters::Item.new(id: "false", label: "No", slug: "false", count: total - filter_options.last),
          ]
        end
      end
    end
  end
end
