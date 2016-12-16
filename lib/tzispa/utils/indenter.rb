require 'tzispa/utils/string'

module Tzispa
  module Utils

    class Indenter
      using Tzispa::Utils

      DEFAULT_INDENT_CHAR = ' '

      attr_reader :sbuff, :indent_char, :instr

      def initialize(indent_size, indent_char=DEFAULT_INDENT_CHAR)
        @indent_size = indent_size
        @indent_current = 0
        @indent_char = indent_char
        @instr = String.new
      end

      def <<(str)
        @instr << String.indentize(str, @indent_current, @indent_char)
        self
      end

      def to_s
        @instr
      end

      def indent
        @indent_current += @indent_size
        self
      end

      def unindent
        @indent_current -= @indent_size if @indent_current-@indent_size >= 0
        @indent_current = 0 if @indent_current-@indent_size < 0
        self
      end


    end

  end
end
