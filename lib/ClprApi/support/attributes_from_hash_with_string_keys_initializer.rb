module ClprApi
  module Support
    module AttributesFromHashWithStringKeysInitializer
      def initialize(attrs)
        self.class.initializable_attributes_list.map(&:to_s).each do |attribute|
          instance_variable_set("@#{attribute}", attrs[attribute])
        end
      end

      module ClassMethods
        def initializable_attributes_list
          @initializable_attributes_list = (@initializable_attributes_list || [])
        end

        def initializable_attributes(*args)
          args.each { |arg| initializable_attribute(arg) }
        end

        def initializable_attribute(arg)
          initializable_attributes_list << arg

          attr_reader arg
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end
    end
  end
end
