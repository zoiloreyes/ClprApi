module ClprApi
  module Support
    module JsonAttributesSerializer
      module ClassMethods
        def serializable_attributes
          @serializable_attributes = @serializable_attributes || (superclass.include?(JsonAttributesSerializer) ? superclass.serializable_attributes : [])
        end

        def serializable_attributes_procs
          @serializable_attributes_procs = @serializable_attributes_procs || (superclass.include?(JsonAttributesSerializer) ? superclass.serializable_attributes_procs : {})
        end

        def serializable_attributes_aliases
          @serializable_attributes_aliases = @serializable_attributes_aliases || (superclass.include?(JsonAttributesSerializer) ? superclass.serializable_attributes_aliases : {})
        end

        def attributes(*args)
          args.each { |arg| attribute(arg) }
        end

        def attribute(arg, alias_name = nil, &block)
          serializable_attributes << arg

          serializable_attributes_procs[arg] = block if block_given?
          serializable_attributes_aliases[arg] = alias_name if alias_name
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      attr_reader :serializer_params

      def with_params_for_serialization(params)
        @serializer_params = params

        self
      end

      def default_as_json
        {}
      end

      def as_json(*)
        return default_as_json if self.class.serializable_attributes.empty?

        self.class.serializable_attributes.reduce({}) do |hash, attribute|
          value = if self.class.serializable_attributes_procs[attribute]
                    if self.class.serializable_attributes_procs[attribute].arity.positive?
                      self.class.serializable_attributes_procs[attribute].call(self, serializer_params)
                    else
                      self.class.serializable_attributes_procs[attribute].call(self)
                    end
                  else
                    public_send(attribute)
                  end

          hash.merge(self.class.serializable_attributes_aliases.fetch(attribute, attribute) => value)
        end
      end
    end
  end
end
