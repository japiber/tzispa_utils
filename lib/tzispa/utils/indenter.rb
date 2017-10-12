# frozen_string_literal: true

require 'tzispa/utils/tz_string'

module Tzispa
  module Utils

    class Indenter
      using Tzispa::Utils::TzString

      DEFAULT_INDENT_CHAR = ' '
      DEFAULT_INDENT_SIZE = 2

      attr_reader :sbuff, :indent_char, :instr

      def initialize(indent_size = nil, indent_char = nil)
        @indent_size = indent_size || DEFAULT_INDENT_SIZE
        @indent_current = 0
        @indent_char = indent_char || DEFAULT_INDENT_CHAR
        @instr = String.new
      end

      def <<(item)
        ss = item.to_s.indentize(@indent_current, @indent_char)
        @instr.concat ss

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
        if (@indent_current - @indent_size).positive?
          @indent_current -= @indent_size
        else
          @indent_current = 0
        end

        self
      end
    end

  end
end
