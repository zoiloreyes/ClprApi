module ClprApi
  module Serializers
    class SolrSecondaryAreasSerializer < ActiveModel::Serializer
      attributes :as_json_sm, :slug_sm

      def slug_sm
        @slug_sm ||= areas.map { |area| area.with_parents_attribute(:slug) }.flatten.uniq
      end

      def as_json_sm
        @as_json_sm ||= areas.uniq.map { |record| AreaRecordSerializer.call(record).to_json }
      end

      private

      def areas
        object.secondary_areas.map(&:area) << object.area_record
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
