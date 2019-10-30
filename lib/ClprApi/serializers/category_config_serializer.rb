module ClprApi
  module Serializers
    class CategoryConfigSerializer < ActiveModel::Serializer
      attributes :id, :for_free, :for_sale, :for_sale_ranged, :for_sale_conditions, :for_sale_obo, :for_sale_units, :for_sale_units_labels, :for_rent, :for_rent_ranged, :for_rent_conditions, :for_rent_obo, :for_barter, :location_type, :setting, :title_template, :for_rent_units, :for_rent_units_labels

      def for_sale_units_labels
        return {} if object.for_sale_units.blank?

        to_humanized_units(object.for_sale_units)
      end

      def for_rent_units_labels
        return {} if object.for_rent_units.blank?

        to_humanized_units(object.for_rent_units)
      end

      def to_humanized_units(units)
        units = units.split(",")

        Hash[ListingPriceUnit.where(id: units).pluck(:id, :label_long)]
      end
    end
  end
end
