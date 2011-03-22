module Stupidedi
  module Schema

    #
    # @see X222.pdf B.1.1.3.4 Data Segment
    #
    class SegmentDef
      include Inspect

      # @return [Symbol]
      attr_reader :id

      # @return [String]
      attr_reader :name

      # @return [String]
      attr_reader :purpose

      # @return [Array<SimpleElementUse, CompositeElementUse>]
      attr_reader :element_uses

      # @return [Array<SyntaxNote>]
      attr_reader :syntax_notes

      # @return [SegmentUse]
      attr_reader :parent

      def initialize(id, name, purpose, element_uses, syntax_notes, parent)
        @id, @name, @purpose, @element_uses, @syntax_notes, @parent =
          id, name, purpose, element_uses, syntax_notes, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @element_uses = @element_uses.map{|x| x.copy(:parent => self) }
          @syntax_notes = @syntax_notes.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [SegmentDef]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:name, @name),
          changes.fetch(:purpose, @purpose),
          changes.fetch(:element_uses, @element_uses),
          changes.fetch(:syntax_notes, @syntax_notes),
          changes.fetch(:parent, @parent)
      end

      # @return [SegmentUse]
      def use(position, requirement, repeat_count)
        SegmentUse.new(self, position, requirement, repeat_count, nil)
      end

      # @return [Values::SegmentVal]
      def empty(parent = nil, usage = nil)
        Values::SegmentVal.new(self, [], parent, usage)
      end

      # @return [Values::SegmentVal]
      def value(element_vals, parent = nil, usage = nil)
        Values::SegmentVal.new(self, element_vals, parent, usage)
      end

      # @return [void]
      def pretty_print(q)
        q.text "SegmentDef[#{@id}]"

        q.group(2, "(", ")") do
          q.breakable ""
          @element_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end

        # @syntax_notes.each do |e|
        #   unless q.current_group.first?
        #     q.text ","
        #     q.breakable
        #   end
        #   q.pp e
        # end
        end
      end
    end

    class << SegmentDef
      #########################################################################
      # @group Constructor Methods

      # @return [SegmentDef]
      def build(id, name, purpose, *args)
        element_uses = args.take_while{|x| x.is_a?(AbstractElementUse) }
        syntax_notes = args.drop(element_uses.length)

        # @todo: Validate SyntaxNotes
        new(id, name, purpose, element_uses, syntax_notes, nil)
      end

      # @endgroup
      #########################################################################
    end

  end
end
