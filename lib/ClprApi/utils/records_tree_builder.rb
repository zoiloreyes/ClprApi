module ClprApi
  module Utils
    class RecordsTreeBuilder
      attr_reader :records, :type, :selected_slugs

      def initialize(records, type, selected_slugs)
        @records = records.sort_by { |record| record["slug"] }
        @type = type
        @selected_slugs = selected_slugs

        match_records_on_tree
        mark_selected_parents!
      end

      def self.call(records, type, selected_slugs)
        new(records, type, selected_slugs)
      end

      def as_tree
        @as_tree ||= organize_tree(records)
      end

      def ids
        @ids ||= records.map { |cat| cat["id"].to_i }
      end

      def records_map
        @records_map ||= records.reduce({}) do |hash, item|
          hash[item["id"].to_i] = item["count"]
          hash
        end
      end

      def mark_selected_parents!
        selected_records.each { |record| selected_parent(record) }
      end

      def selected_records
        @selected_records ||= records.select { |record| selected_slugs.include?(record["slug"]) }
      end

      def selected_parent(record)
        parent = records.find { |r2| r2["id"] == record["parent_id"] }

        if parent
          parent["selected"] = true

          selected_parent(parent)
        end
      end

      def selected_parents
        @selected_parents ||= records.select { |r| r["selected"] && r["level"] == 1 }
      end

      def match_records_on_tree
        items = records.select { |item| ids.include?(item["id"]) }

        items.each do |item|
          item["count"] = records_map[item["id"]] or raise RuntimeError
          item["selected"] = selected_slugs.include?(item["slug"])
        end
      end

      def organize_tree(items)
        items.map do |cat|
          cat["children"] = items.select { |cat2| cat2["parent_id"] == cat["id"] }

          cat
        end.select { |cat| cat["level"] == 1 }
      end
    end
  end
end
