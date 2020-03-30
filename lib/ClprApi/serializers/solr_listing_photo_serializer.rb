module ClprApi
  module Serializers
    class SolrListingPhotoSerializer < ActiveModel::Serializer
      attributes :url_sm, :id_im, :description_sm

      def url_sm
        object.s3_listing_photos.map(&:s3)
      end

      def id_im
        object.s3_listing_photos.map(&:id)
      end

      def description_sm
        object.s3_listing_photos.map(&:description).map(&:to_s)
      end
    end
  end
end
