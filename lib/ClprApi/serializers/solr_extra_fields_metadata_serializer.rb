module ClprApi
  module Serializers
    class SolrExtraFieldsMetadataSerializer
      include Support::JsonAttributesSerializer
      include Support::AttributesFromHashInitializer

      attributes :id, :label, :type, :value
      initializable_attributes :id, :label, :type

      def self.from_field(field)
        new(
          id: field.field_id,
          label: field.label,
          type: field.field_type,
        )
      end
    end
  end
end
