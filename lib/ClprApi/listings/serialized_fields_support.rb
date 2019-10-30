module ClprApi
  module Listings
    module SerializedFieldsSupport
      def fields
        @fields ||= response.filterable_fields.map { |field|
          Serializers::ListingFieldSerializer.new(field, root: nil)
        }
      end
    end
  end
end
