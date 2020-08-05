module ClprApi
  module Serializers
    class SolrListerSerializer < ActiveModel::Serializer
      attributes :first_name, :last_name, :phone, :phone2, :fax, :email, :email2, :whatsapp_phone, :premium

      def whatsapp_phone
        object.whatsapp_phone.to_s
      end
    end
  end
end
