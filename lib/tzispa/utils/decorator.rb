# frozen_string_literal: true

module Tzispa
  module Utils

    class Decorator < SimpleDelegator
      def component
        @component ||= __getobj__
      end

      def cclass
        component.class
      end
    end

  end
end
