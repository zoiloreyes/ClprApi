module ClprApi
  module Solr
    class Query
      class FilterCollectionFromParams
        delegate :each, :[], :select, :map, to: :filters

        attr_reader :fields, :params, :category

        def initialize(fields, params, category)
          @fields = fields
          @params = params
          @category = category
        end

        def valid
          @valid ||= filters.select(&:valid?).reject { |filter| filter.field_id == "car_model" && !field_ids.include?("car_make") }
        end

        private

        def field_ids
          @field_ids ||= filters.map(&:field_id)
        end

        def raw_filters
          @raw_filters ||= fields.map do |field|
            Solr::Filters::Node.for(field, params)
          end.compact
        end

        def filters
          @filters ||= raw_filters.push(price_filter).compact
        end

        def price_filter
          @price_filter ||= PriceFilterParser.call(raw_filters, params, category)
        end
      end
    end
  end
end
