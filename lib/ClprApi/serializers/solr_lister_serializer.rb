module ClprApi
  module Serializers
    class SolrListerSerializer < ActiveModel::Serializer
      attributes :first_name, :last_name, :phone, :phone2, :fax, :email, :email2
    end
  end
end
