module ClprApi
  module Serializers
    class IndustrySerializer < ActiveModel::Serializer
      attributes :id, :name, :slug, :description
    end
  end
end
