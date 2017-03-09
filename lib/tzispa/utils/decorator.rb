# frozen_string_literal: true

module Tzispa
  module Utils

    class Decorator < SimpleDelegator
      attr_reader :component

      def initialize(component)
        @component = component
        super
      end

      def cclass
        @component.class
      end
    end

  end
end
