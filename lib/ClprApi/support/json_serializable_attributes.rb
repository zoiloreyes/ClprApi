module ClprApi
  module Support
    module JsonAttributesSerializer
      module ClassMethods
        def serializable_attributes
          @serializable_attributes = (@serializable_attributes || [])
        end

        def attributes(*args)
          args.each { |arg| attribute(arg) }
        end

        def attribute(arg)
          serializable_attributes << arg
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      def as_json(*)
        self.class.serializable_attributes.reduce({}) do |hash, attribute|
          hash.merge(attribute => public_send(attribute))
        end
      end
    end
  end
end
