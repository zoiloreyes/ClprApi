module ClprApi
  module Utils
    class GroupHashByProp
      attr_reader :data, :group_prop, :total_prop

      def initialize(data, group_prop, total_prop)
        @data = data.sort_by { |item| -item[group_prop].length }
        @group_prop = group_prop
        @total_prop = total_prop
      end

      def self.call(data, group_prop, total_prop)
        new(data, group_prop, total_prop).call
      end

      def call
        result = {}

        data.inject({}) do |hash, item|
          node = result[item[group_prop]]

          if node
            node[total_prop] = node[total_prop] + item[total_prop]
          else
            result[item[group_prop]] = item
          end
        end

        result.values
      end

      def uniq_props
        @uniq_props ||= data.map { |item| item[group_prop] }.uniq
      end
    end
  end
end
