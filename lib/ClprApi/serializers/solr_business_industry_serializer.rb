module ClprApi
  module Serializers
    class SolrBusinessIndustrySerializer < ActiveModel::Serializer
      attributes :id, :name, :description, :slug, :category_slug
    end
  end
end
