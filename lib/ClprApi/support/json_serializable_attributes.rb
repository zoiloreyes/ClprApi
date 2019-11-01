module ClprApi
  module Support
    module JsonAttributesSerializer
      def self.json_attributes_support_on_included_or_inhetited(base)
        base.extend ClassMethods

        base.class_eval do
          superclass_interitable = base.superclass.ancestors.include?(JsonAttributesSerializer)

          @serializable_attributes = superclass_interitable ? base.superclass.serializable_attributes.dup : []
          @serializable_attributes_procs = superclass_interitable ? base.superclass.serializable_attributes_procs.dup : {}
          @serializable_attributes_aliases = superclass_interitable ? base.superclass.serializable_attributes_aliases.dup : {}
        end

        if base.include?(JsonAttributesSerializer)
          base.define_singleton_method(:inherited) do |subclass|
            JsonAttributesSerializer.json_attributes_support_on_included_or_inhetited(subclass)
          end
        end
      end

      module ClassMethods
        attr_reader :serializable_attributes, :serializable_attributes_procs, :serializable_attributes_aliases

        def attributes(*args)
          args.each { |arg| attribute(arg) }
        end

        def attribute(arg, alias_name = nil, &block)
          serializable_attributes << arg rescue ::Kernel.binding.pry

          serializable_attributes_procs[arg] = block if block_given?
          serializable_attributes_aliases[arg] = alias_name if alias_name
        end
      end

      def self.included(base)
        json_attributes_support_on_included_or_inhetited(base)
      end

      attr_reader :serializer_params

      def with_params_for_serialization(params)
        @serializer_params = params

        self
      end

      def as_json(*)
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
