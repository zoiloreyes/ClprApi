module ClprApi
  module Serializers
    class SolrListingPhotoSerializer < ActiveModel::Serializer
      attributes :url_large_sm, :url_medium_sm, :url_small_sm, :url_tiny_sm, :url_sm, :url_src_sm, :id_im, :description_sm

      def url_sm
        object.s3_listing_photos.map(&:s3)
      end

      alias_method :url_large_sm, :url_sm
      alias_method :url_medium_sm, :url_sm
      alias_method :url_small_sm, :url_sm
      alias_method :url_tiny_sm, :url_sm

      def url_src_sm
        object.s3_listing_photos.map(&:img_source)
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
