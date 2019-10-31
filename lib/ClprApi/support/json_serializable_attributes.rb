module ClprApi
  module Support
    module JsonAttributesSerializer
      module ClassMethods
        def serializable_attributes
          @serializable_attributes = (@serializable_attributes || [])
        end

        def serializable_attributes_procs
          @serializable_attributes_procs = (@serializable_attributes_procs || {})
        end

        def attributes(*args)
          args.each { |arg| attribute(arg) }
        end

        def attribute(arg, &block)
          serializable_attributes << arg

          serializable_attributes_procs[arg] = block if block_given?
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      def as_json(*)
        self.class.serializable_attributes.reduce({}) do |hash, attribute|
          value = if self.class.serializable_attributes_procs[attribute]
                    self.class.serializable_attributes_procs[attribute].call(self)
                  else
                    public_send(attribute)
                  end

          hash.merge(attribute => value)
        end
      end
    end
  end
end
