module ClprApi
  module Serializers
    class SolrListingPhotoSerializer < ActiveModel::Serializer
      attributes :url_large_sm, :url_medium_sm, :url_small_sm, :url_tiny_sm, :url_sm, :url_src_sm, :id_im, :description_sm

      def url_large_sm
        photo_collection_for(:large)
      end

      def url_medium_sm
        photo_collection_for(:medium)
      end

      def url_small_sm
        photo_collection_for(:small)
      end

      def url_tiny_sm
        photo_collection_for(:tiny)
      end

      def url_sm
        object.s3_listing_photos.map(&:s3)
      end

      def url_src_sm
        object.s3_listing_photos.map(&:img_source)
      end

      def id_im
        object.s3_listing_photos.map(&:id)
      end

      def description_sm
        object.s3_listing_photos.map(&:description).map(&:to_s)
      end

      private

      def photo_collection_for(size)
        object.s3_listing_photos.map { |photo| photo.send("s3_#{size}") }
      end
    end
  end
end
