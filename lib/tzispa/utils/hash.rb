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
            v = delete(k)
            self[k.to_sym] = v
          end

          self
        end

        def deep_symbolize
          dup.tap do |hsh|
            hsh.keys.each do |k|
              v = hsh.delete(k)
              v = v.dup.deep_symbolize if v.respond_to?(:to_hash)

              hsh[k.to_sym] = v
            end
          end
        end

        def deep_symbolize!
          keys.each do |k|
            v = delete(k)
            v = v.deep_symbolize! if v.respond_to?(:to_hash)

            self[k.to_sym] = v
          end

          self
        end

        def stringify
          dup.tap(&:stringify!)
        end

        def stringify!
          keys.each do |k|
            v = delete(k)
            v = self.class.new(v).stringify! if v.respond_to?(:to_hash)

            self[k.to_s] = v
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
