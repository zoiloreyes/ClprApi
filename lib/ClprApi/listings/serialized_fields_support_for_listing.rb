module ClprApi
  module Listings
    module SerializedFieldsSupportForListing
      GLOBAL_IGNORED_FIELDS = ["car_features", "re_house_units_info"].freeze

      def fields
        item.extra_fields_metadata
      end

      private

      def ignored_fields
        self.class::GLOBAL_IGNORED_FIELDS
      end
    end
  end
end
