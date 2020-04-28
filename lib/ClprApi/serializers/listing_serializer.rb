module ClprApi
  module Serializers
    class ListingSerializer
      include ClprApi::Support::JsonAttributesSerializer

      S3_SOURCE_PATH = ENV.fetch("S3_SOURCE_PATH")
      IGNORED_FIELDS = ["photos_id", "photos_url", "photos_description"].freeze

      delegate :[], :fetch, to: :attrs

      alias_method :read_attribute_for_serialization, :send
      attr_reader :attrs, :solr_field_names

      def initialize(attrs)
        @solr_field_names = attrs.keys
        @attrs = prepare(field_sanitizer(attrs)).with_indifferent_access
      end

      def default_as_json
        attrs.as_json(except: IGNORED_FIELDS).merge(extra_fields: extra_fields).merge(image: image, images: images.map(&:as_json))
      end

      def method_missing(method, *args, &block)
        attrs[method]
      end

      def prepare(attrs)
        highlighted_until = attrs["highlighted_until"]
        youtube_id = attrs["youtube_id"]

        attrs["highlighted"] = highlighted_until.present? && Time.parse(highlighted_until) > Time.now

        if attrs["business_name"].present?
          attrs["business"] = Serializers::BusinessSerializer.new(Serializers::BusinessFromSerializedListing.new(attrs), root: nil)
        end

        if youtube_id.present?
          youtube_url = Support::Youtube::Url.new(youtube_id)
          attrs["youtube_id"] = youtube_url.embed_url if youtube_url.valid?
        end

        attrs
      end

      def extra_fields
        @extra_fields ||= attrs.fetch("extra_fields_metadata", []).map { |field|
          Support::ExtraField.new(JSON.parse(field))
        }
      end

      def main_image_url
        attrs["photos_main_url"].to_s
      end

      def image
        Serializers::ListingPhotoSerializer.new("#{S3_SOURCE_PATH}#{main_image_url}") if main_image_url.present?
      end

      def images
        Array(attrs["photos_url"]).map do |photo_url|
          Serializers::ListingPhotoSerializer.new("#{S3_SOURCE_PATH}#{photo_url}") if photo_url.present?
        end.compact
      end

      private

      def field_sanitizer(item)
        id = item.fetch("id")

        item.reduce({}) do |hash, (key, value)|
          hash.tap do |doc|
            doc[field_name_for(key)] = value
          end
        end.tap do |doc|
          doc["id"] = id

          doc.delete("")
        end
      end

      def field_name_for(key)
        field_name_parts = key.split("_")

        suffix = field_suffix_for(field_name_parts)

        "#{field_name_parts[0..-2].join("_")}#{suffix}"
      end

      def field_suffix_for(field_name_parts)
        if field_name_parts.last == "i" && field_name_parts[-2] != "id" && solr_field_names.include?("#{field_name_parts[0..-2].join("_")}_s")
          "_id"
        elsif field_name_parts.last == "im" && field_name_parts[-2] != "id"
          "_ids"
        end
      end
    end
  end
end
