module ClprApi
  module Solr
    class Query
      class PriceFilterParser
        SPECIAL_CAR_CATEGORY_SLUG = "vehiculos-carros".freeze

        attr_reader :filters, :params, :category

        def initialize(filters, params, category)
          @filters = filters
          @params = params
          @category = category
        end

        def self.call(filters, params, category)
          new(filters, params, category).filter
        end

        def price_param
          params[:price]
        end

        def filter_metadata
          @filter_metadata ||= VirtualFilter.new("price", "price", [])
        end

        def filtered_price
          if category.include?(SPECIAL_CAR_CATEGORY_SLUG) && price_param.present? && filters.empty?
            price_parts = price_param.split(",")

            [
              "*",
              price_parts[1],
            ].join(",")
          else
            price_param
          end
        end

        def filtered_price_param
          { "price" => filtered_price }
        end

        def filter
          @filter ||= begin
            Solr::Filters::Node.for(filter_metadata, filtered_price_param)
          end
        end
      end
    end
  end
end
