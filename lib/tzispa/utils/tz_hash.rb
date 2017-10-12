# frozen_string_literal: true

require 'tzispa/utils/duplicable'

module Tzispa
  module Utils
    module TzHash

      DUPLICATE_LOGIC = proc do |value|
        case value
        when Hash
          value.deep_dup
        when ::Hash
          Hash.new(value).deep_dup.to_h
        end
      end.freeze

      refine ::Hash do
        def symbolize
          dup.tap(&:symbolize!)
        end

        def symbolize!
          keys.each do |k|
            self[k.to_sym] = delete(k) if k.respond_to? :to_sym
          end

          self
        end

        def deep_symbolize!
          keys.each do |k|
            ks = k.respond_to?(:to_sym) ? k.to_sym : k
            self[ks] = delete k # Preserve order even when k == ks
            self[ks].deep_symbolize! if self[ks].is_a? ::Hash
          end

          self
        end

        def deep_symbolize
          dup.tap do |hs|
            hs.keys.each do |k|
              ks = k.respond_to?(:to_sym) ? k.to_sym : k
              hs[ks] = hs.delete k # Preserve order even when k == ks
              hs[ks] = hs[ks].deep_symbolize if hs[ks].is_a? ::Hash
            end
          end
        end

        def stringify
          dup.tap(&:stringify!)
        end

        def stringify!
          keys.each do |k|
            self[k.to_s] = delete(k) if k.respond_to? :to_s
          end

          self
        end

        def deep_stringify!
          keys.each do |k|
            ks = k.respond_to?(:to_s) ? k.to_s : k
            self[ks] = delete k # Preserve order even when k == ks
            self[ks].deep_symbolize! if self[ks].is_a? ::Hash
          end

          self
        end

        def tuplify
          [].tap do |tp|
            each do |k, v|
              if v.respond_to? :each
                v.each { |w| tp << [k, w] }
              else
                tp << [k, v]
              end
            end
          end
        end

        def deep_dup
          self.class.new.tap do |result|
            @hash.each { |k, v| result[k] = Duplicable.dup(v, &DUPLICATE_LOGIC) }
          end
        end
      end

    end
  end
end
