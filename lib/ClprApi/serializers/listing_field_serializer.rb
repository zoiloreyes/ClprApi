module ClprApi
  module Serializers
    class ListingFieldSerializer < ActiveModel::Serializer
      attributes :id, :label, value: :type
    end
  end
end
