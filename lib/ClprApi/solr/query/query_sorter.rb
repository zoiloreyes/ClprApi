module ClprApi
  module Solr
    class Query
      module QuerySorter
        DEFAULT_SORT_KEY = "updated_at_d".freeze

        SORTS = {
          "recency" => "updated_at_d",
          "most_recent" => "updated_at_d",
          "oldest" => "updated_at_d",
          "relevance" => "score",
          "score" => "score",
          "title" => "title_s",
          "a_z" => "title_s",
          "z_a" => "title_s",
          "price" => "price_start_f",
          "cheapesness" => "price_start_f",
          "expensiveness" => "price_start_f",
        }.freeze

        class << self
          def for(value)
            SORTS[value.to_s.downcase] || DEFAULT_SORT_KEY
          end

          def direction_for(value)
            case value
            when "a_z", "cheapesness", "relevance", "score", "oldest"
              :asc
            when "z_a", "expensiveness", "most_recent", "recency"
              :desc
            when :desc, :asc
              value
            else
              :desc
            end
          end
        end
      end
    end
  end
end
