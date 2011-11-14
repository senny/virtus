module Virtus
  class Attribute

    # Class representing the default value option
    class DefaultValue
      DUP_CLASSES = [ ::NilClass, ::TrueClass, ::FalseClass,
                      ::Numeric,  ::Symbol ].freeze

      # Returns the attribute associated with this default value instance
      #
      # @return [Virtus::Attribute::Object]
      #
      # @api private
      attr_reader :attribute

      # Returns the value instance
      #
      # @return [Object]
      #
      # @api private
      attr_reader :value

      # Initializes an default value instance
      #
      # @param [Virtus::Attribute] attribute
      # @param [Object] value
      #
      # @return [undefined]
      #
      # @api private
      def initialize(attribute, value)
        @attribute = attribute
        @value     = case value when *DUP_CLASSES then value else value.dup end
      end

      # Evaluates the value
      #
      # @param [Object]
      #
      # @return [Object] evaluated value
      #
      # @api private
      def evaluate(instance)
        if callable?
          call(instance)
        elsif method_symbol?
          send_method(instance)
        else
          value
        end
      end

    private

      # Evaluates a proc value
      #
      # @param [Object]
      #
      # @return [Object] evaluated value
      #
      # @api private
      def call(instance)
        value.call(instance, attribute)
      end

      # Evaluates a method_symbol value
      #
      # @param [Object]
      #
      # @return [Object] evaluated value
      #
      # @api private
      def send_method(instance)
        instance.send value
      end

      # Returns if the value is callable
      #
      # @return [TrueClass,FalseClass]
      #
      # @api private
      def callable?
        value.respond_to?(:call)
      end

      # Returns if the value is a method_symbol
      #
      # @return [TrueClass,FalseClass]
      #
      # @api private
      def method_symbol?
        value.is_a?(Symbol)
      end

    end # class DefaultValue
  end # class Attribute
end # module Virtus
