module ClprApi
  module Support
    module AttributesFromHashInitializer
      attr_reader :init_attrs

      delegate :[], :fetch, to: :init_attrs

      def initialize(attrs)
        @init_attrs = attrs.with_indifferent_access

        self.class.initializable_attributes_list.each do |attribute|
          instance_variable_set("@#{attribute}", init_attrs[attribute])
        end
      end

      module ClassMethods
        def initializable_attributes_list
          @initializable_attributes_list = @initializable_attributes_list || (superclass.respond_to?(:initializable_attributes_list) ? superclass.public_send(:initializable_attributes_list) : [])
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
