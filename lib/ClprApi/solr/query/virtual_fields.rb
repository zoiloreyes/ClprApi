module ClprApi
  module Solr
    class Query
      module VirtualFields
        class VirtualField < Struct.new(:field_id, :value, :label, :options); end
        class VirtualOption < Struct.new(:id, :slug, :label); end

        def virtual_filters
          [
            VirtualFilter.new("offering", "option_string", offering_options),
            VirtualFilter.new("has_photos", "boolean", []),
          ]
        end

        def virtual_fields
          [
            VirtualField.new("price", "range", "Precio"),
            VirtualField.new("category", "tree", "Categoria"),
            VirtualField.new("area", "tree", "Area"),
            VirtualField.new("has_photos", "list", "Fotos", photos_options),
            VirtualField.new("offering", "list", "Venta o Alquiler", offering_options),
          ]
        end

        def offering_options
          [
            VirtualOption.new("sale", "sale", "Venta"),
            VirtualOption.new("rent", "rent", "Alquiler"),
          ]
        end

        def photos_options
          [
            VirtualOption.new("true", "true", "Con fotos"),
            VirtualOption.new("false", "false", "Sin fotos"),
          ]
        end
      end
    end
  end
end
