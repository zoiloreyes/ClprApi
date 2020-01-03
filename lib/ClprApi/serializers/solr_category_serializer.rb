module ClprApi
  module Serializers
    class SolrCategorySerializer < ActiveModel::Serializer
      attributes :label, :slug, :id_im, :slug_sm, :label_sm, :as_json_sm

      def id_im
        @id_im ||= object.with_parents_attribute(:id)
      end

      def slug_sm
        @slug_sm ||= object.with_parents_attribute(:slug)
      end

      def label_sm
        @label_sm ||= object.with_parents_attribute(:label)
      end

      def as_json_sm
        @as_json_sm ||= (object.parents + Array(object)).map { |record| CategoryRecordSerializer.call(record).to_json }
      end
    end

    class CategoryRecordSerializer
      def self.call(record)
        {
          id: record.id,
          label: record.label,
          label2: record.label2,
          slug: record.slug,
          level: record.level,
          parent_id: record.parent_id,
          seo_title: record.seo_title,
        }
      end
    end
  end
end
