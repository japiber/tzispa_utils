# frozen_string_literal: true

module Tzispa
  module Utils

    class String

      NAMESPACE_SEPARATOR        = '::'
      CLASSIFY_SEPARATOR         = '_'
      UNDERSCORE_SEPARATOR       = '/'

      UNDERSCORE_DIVISION_TARGET = '\1_\2'

      def initialize(str)
        @string = str.to_s
      end

      def to_s
        @string
      end

      def ==(other)
        to_s == other
      end

      def self.constantize(str)
        self.new(str).constantize
      end

      def constantize
        names = @string.split(NAMESPACE_SEPARATOR)
        names.shift if names.empty? || names.first.empty?
        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end

      def self.camelize(str)
        self.new(str).camelize
      end

      def camelize
        self.class.new( @string.split(CLASSIFY_SEPARATOR).collect{ |w| w.capitalize }.join)
      end

      def camelize!
        @string = @string.split(CLASSIFY_SEPARATOR).collect!{ |w| w.capitalize }.join
      end

      def self.underscore(str)
        self.new(str).underscore
      end

      def underscore
        self.class.new(@string.dup.tap { |s|
          s.gsub!(NAMESPACE_SEPARATOR, UNDERSCORE_SEPARATOR)
          s.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
          s.downcase!
        })
      end

      def underscore!
        @string = @string.tap { |s|
          s.gsub!(NAMESPACE_SEPARATOR, UNDERSCORE_SEPARATOR)
          s.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
          s.downcase!
        }
      end

      private

      def gsub(pattern, replacement = nil, &blk)
        if block_given?
          @string.gsub(pattern, &blk)
        else
          @string.gsub(pattern, replacement)
        end
      end


    end
  end
end

TzString = Tzispa::Utils::String
