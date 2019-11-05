module ClprApi
  module Listings
    class SearchResults
      include Support::JsonAttributesSerializer
      include Support::AttributesFromHashInitializer

      attributes :filters, :total, :total_pages, :current_page, :items, :fields, :business
      initializable_attributes :filters, :total, :total_pages, :current_page, :items, :fields, :business
    end
  end
end
