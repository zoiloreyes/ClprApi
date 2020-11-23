module ClprApi
  module Serializers
    class SolrCategoryConfigSerializer < ActiveModel::Serializer
      attributes :show_category_tree, :show_only_category, :show_price, :id, :show_contact_form
    end
  end
end
