# frozen_string_literal: true

require 'tzispa/utils/duplicable'

module Tzispa
  module Utils

    DUPLICATE_LOGIC = proc do |value|
      case value
      when Hash
        value.deep_dup
      when ::Hash
        Hash.new(value).deep_dup.to_h
      end
    end.freeze

    refine Hash do
      def symbolize!
        keys.each do |k|
          v = delete(k)
          self[k.to_sym] = v
        end

        self
      end

      def deep_symbolize!
        keys.each do |k|
          v = delete(k)
          v = self.class.new(v).deep_symbolize! if v.respond_to?(:to_hash)

          self[k.to_sym] = v
        end

        self
      end

      def stringify!
        keys.each do |k|
          v = delete(k)
          v = self.class.new(v).stringify! if v.respond_to?(:to_hash)

          self[k.to_s] = v
        end

        self
      end

      def deep_dup
        self.class.new.tap do |result|
          @hash.each { |k, v| result[k] = Duplicable.dup(v, &DUPLICATE_LOGIC) }
        end
      end
    end

  end
end
