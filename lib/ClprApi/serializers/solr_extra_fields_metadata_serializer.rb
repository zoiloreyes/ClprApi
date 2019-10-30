module ClprApi
  module Serializers
    class SolrExtraFieldsMetadataSerializer
      def self.call(field)
        {
          id: field.field_id,
          label: field.label,
          type: field.field_type,
        }
      end
    end
  end
end
