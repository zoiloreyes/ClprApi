module ClprApi
  module Support
    class ExtraField
      include JsonAttributesSerializer
      include AttributesFromHashInitializer

      attributes :id, :label, :type, :primary, :value, :slug
      initializable_attributes :id, :label, :type, :primary, :value, :slug
    end
  end
end
