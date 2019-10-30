module ClprApi
  module Serializers
    class SolrAreaSerializer < ActiveModel::Serializer
      attributes :type, :country, :region, :state, :county, :city, :area, :slug, :country_id, :region_id, :state_id, :county_id, :city_id, :id_im, :slug_sm, :as_json_sm

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
        @as_json_sm ||= (object.parents + Array(object)).map { |record| AreaRecordSerializer.call(record).to_json }
      end
    end

    class AreaRecordSerializer
      def self.call(record)
        {
          id: record.id,
          label: record.name,
          slug: record.slug,
          level: record.level,
          parent_id: record.pid,
        }
      end
    end
  end
end
