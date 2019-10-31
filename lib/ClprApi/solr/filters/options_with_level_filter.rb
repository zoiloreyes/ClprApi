module ClprApi
  module Solr
    module Filters
      class OptionsWithLevelFilter < Base
        def properties
          @properties ||= HashWithIndifferentAccess.new(
            selected: selected_records,
            selected_parent: selected_parents,
            items: listable_options,
          )
        end

        delegate :selected_parents, :selected_records, to: :options

        def fetch(*args)
          properties.fetch(args.first)
        end

        def selected_slugs
          @selected_slugs ||= params[field.field_id].to_s.split(",")
        end

        def options
          @options ||= begin
            records = filter_options.each_slice(2).map { |(record, count)|
              JSON.parse(record).merge("count" => count)
            }.compact

            Utils::RecordsTreeBuilder.(records, field.field_id, selected_slugs)
          end
        end

        def listable_options
          @listable_options ||= options.as_tree
        end

        private

        def find_option(option_id)
          field.options.find { |option| option.id.to_s == option_id }
        end
      end
    end
  end
end
