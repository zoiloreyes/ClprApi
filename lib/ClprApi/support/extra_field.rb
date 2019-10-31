module ClprApi
  module Support
    class ExtraField < ExtraFieldMetadata
      attributes :id, :type, :label, :value
      initializable_attributes :id, :type, :label, :value
    end
  end
end
