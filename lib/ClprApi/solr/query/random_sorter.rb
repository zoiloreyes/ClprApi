module ClprApi
  module Solr
    class Query
      module RandomSorter
        class << self
          def for(_)
            "random_#{Random.rand(1_000)}"
          end
        end
      end
    end
  end
end
