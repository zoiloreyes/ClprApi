module ClprApi
  module Support
    class ExtraField
      include JsonAttributesSerializer
      include AttributesFromHashInitializer

      attributes :id, :type, :label, :value
      initializable_attributes :id, :type, :label, :value
    end
  end
end
