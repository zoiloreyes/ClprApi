module ClprApi
  module Solr
    class Response
      include Solr::Query::VirtualFields

      PRICE_KEYS = ["price_start_f", "price_end_f"].freeze

      attr_reader :raw_response, :filterable_fields, :selected_values, :params

      def initialize(raw_response, filterable_fields, selected_values, params)
        @raw_response = raw_response
        @filterable_fields = filterable_fields
        @selected_values = selected_values
        @params = params
      end

      def fields_metadata
        filterable_fields + valid_virtual_fields
      end

      def selected_category
        params[:category]
      end

      def valid_virtual_fields
        @valid_virtual_fields ||= begin
          valid_fields = virtual_fields
          valid_fields.reject! { |f| f.field_id == "offering" } unless selected_category.to_s.starts_with?("bienes-raices")
          valid_fields.reject! { |f| f.field_id == "has_photos" } if selected_category.to_s.starts_with?("cursos")
          valid_fields
        end
      end

      def regular_filters
        @regular_filters ||= Solr::Filters::Builder.options(facet_fields, fields_metadata, selected_values, total, params)
      end

      def stats_filters
        @stats_filters ||= Solr::Filters::Builder.stats(statistics_fields, fields_metadata, selected_values, total, params)
      end

      def filters
        @filters ||= begin
          _filters = {}.merge(regular_filters).merge(stats_filters).merge(pricing_filter).select { |_, filter| filter.any? }

          # TODO: Add dependency model that dinamically selectes if a field should be visible or not based on another field being selected
          _filters.delete("car_model") unless _filters["car_make"] && _filters["car_make"].selected_values.present?

          _filters
        end
      end

      def response
        @response ||= raw_response.fetch("response")
      end

      def total
        @total ||= response.fetch("numFound")
      end

      def docs
        @docs ||= response.fetch("docs")
      end

      def pricing_filter
        { "price" => price_filter }
      end

      def price_filter
        @price_filter ||= Solr::Filters::PriceFilter.build(statistics, fields_metadata, selected_values, total, params)
      end

      def statistics_fields
        statistics.reject { |key, _| PRICE_KEYS.include?(key) }
      end

      def statistics
        raw_response.fetch("stats", {}).fetch("stats_fields", {})
      end

      def facet_fields
        raw_response.fetch("facet_counts", {}).fetch("facet_fields", {})
      end
    end
  end
end
