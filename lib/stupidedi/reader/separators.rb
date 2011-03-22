module Stupidedi
  module Reader

    #
    # @see X222.pdf B.1.1.2.5 Delimiters
    #
    class Separators

      # @return [String]
      attr_accessor :component  # :

      # @return [String]
      attr_accessor :repetition # ^

      # @return [String]
      attr_accessor :element    # *

      # @return [String]
      attr_accessor :segment    # ~

      def initialize(component, repetition, element, segment)
        @component, @repetition, @element, @segment =
          component, repetition, element, segment
      end

      # @return [Separators]
      def copy(changes = {})
        Separators.new \
          changes.fetch(:component, @component),
          changes.fetch(:repetition, @repetition),
          changes.fetch(:element, @element),
          changes.fetch(:segment, @segment)
      end

      def merge(other)
        Separators.new \
          other.component  || @component,
          other.repetition || @repetition,
          other.element    || @element,
          other.segment    || @segment
      end

      def inspect
        "Separators(#{@component.inspect}, #{@repetition.inspect}, #{@element.inspect}, #{@segment.inspect})"
      end
    end

    class << Separators
      def empty
        Separators.new(nil, nil, nil, nil)
      end
    end

  end
end