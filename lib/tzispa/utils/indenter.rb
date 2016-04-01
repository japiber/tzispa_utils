module Tzispa
  module Utils

    class Indenter

      DEFAULT_INDENT_CHAR = ' '

      attr_reader :sbuff, :indent_char, :instr

      def initialize(indent_size, indent_char=DEFAULT_INDENT_CHAR)
        @indent_size = indent_size
        @indent_current = 0
        @indent_char = indent_char
        @instr = String.new
      end

      def <<(str)
        @instr << self.class.indentize(str, @indent_current, @indent_char)
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

      # Indent a string by count chars
      def self.indentize(str, count, char = ' ')
        str.gsub(/([^\n]*)(\n|$)/) do |match|
          last_iteration = ($1 == "" && $2 == "")
          line = ""
          line << (char * count) unless last_iteration
          line << $1
          line << $2
          line
        end
      end

    end

  end
end
