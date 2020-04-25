module ClprApi
  module Serializers
    class SolrExtraFieldsMetadataSerializer
      include Support::JsonAttributesSerializer
      include Support::AttributesFromHashInitializer

      attributes :id, :label, :type, :primary, :value, :slug
      initializable_attributes :id, :primary, :label, :type, :value, :slug

      def self.from_field(field)
        new(
          id: field.field_id,
          label: field.label,
          type: field.field_type,
          primary: field.primary,
          value: field.field_value,
          slug: field.slug,
        )
      end
    end
  end
end
