# frozen_string_literal: true

module Tzispa
  module Utils
    module Duplicable

      def self.dup(value, &blk)
        case value
        when NilClass, FalseClass, TrueClass, Symbol, Numeric
          value
        when v = blk && blk.call(value)
          v
        else
          value.dup
        end
      end

    end
  end
end
