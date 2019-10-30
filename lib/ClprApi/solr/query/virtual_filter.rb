module ClprApi
  module Solr
    class Query
      class VirtualFilter < Struct.new(:field_id, :value, :options)
      end
    end
  end
end
