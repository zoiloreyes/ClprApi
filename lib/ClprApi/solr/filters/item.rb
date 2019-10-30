module ClprApi
  module Solr
    module Filters
      class Item
        attr_reader :id, :label, :slug, :count, :level, :selected

        def initialize(id:, label:, slug:, count:, level: 0, selected: false)
          @id = id
          @label = label
          @slug = slug
          @count = count
          @level = level
          @selected = selected
        end

        def [](key)
          public_send(key)
        end

        def []=(*args)
          instance_variable_set("@#{args.first}", args.last)
        end
      end
    end
  end
end
