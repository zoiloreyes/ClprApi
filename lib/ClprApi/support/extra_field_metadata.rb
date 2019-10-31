module ClprApi
  module Support
    class ExtraFieldMetadata
      include JsonAttributesSerializer
      include AttributesFromHashWithStringKeysInitializer

      attributes :id, :type, :label
      initializable_attributes :id, :type, :label
    end
  end
end
