module ClprApi
  module Serializers
    class IndustrySerializer < ActiveModel::Serializer
      attributes :id, :name, :slug, :description, :category_slug
    end
  end
end
