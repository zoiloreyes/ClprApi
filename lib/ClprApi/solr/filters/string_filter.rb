module ClprApi
  module Solr
    module Filters
      class StringFilter < Base
        def properties
          @properties ||= {
            items: listable_options,
          }
        end

        def listable_options
          @listable_options ||= Utils::GroupHashByProp.call(ungruoped_options, "slug", "count")
        end

        def ungruoped_options
          @ungruoped_options ||= filter_options.each_slice(2).map { |(option_id, count)|
            next unless count.positive?

            slug = option_id.parameterize

            Solr::Filters::Item.new(id: option_id, label: option_id, slug: slug, count: count, selected: selected_ids.include?(slug))
          }.compact.sort_by(&:label)
        end

        def selected_ids
          @selected_ids ||= Array(params[field.field_id])
        end

        def as_json(*)
          properties.merge(
            type: "optionlist",
            label: field.label,
            field: field.field_id,
          )
        end
      end
    end
  end
end
