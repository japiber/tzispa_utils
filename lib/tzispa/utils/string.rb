# frozen_string_literal: true

module Tzispa
  module Utils



    class String

      NAMESPACE_SEPARATOR        = '::'
      CLASSIFY_SEPARATOR         = '_'
      UNDERSCORE_SEPARATOR       = '/'

      UNDERSCORE_DIVISION_TARGET = '\1_\2'

      # The extended characters map used by removeaccents. The accented characters
      # are coded here using their numerical equivalent to sidestep encoding issues.
      # These correspond to ISO-8859-1 encoding.
      ACCENTS_MAPPING = {
        'E' => [200,201,202,203],
        'e' => [232,233,234,235],
        'A' => [192,193,194,195,196,197],
        'a' => [224,225,226,227,228,229,230],
        'C' => [199],
        'c' => [231],
        'O' => [210,211,212,213,214,216],
        'o' => [242,243,244,245,246,248],
        'I' => [204,205,206,207],
        'i' => [236,237,238,239],
        'U' => [217,218,219,220],
        'u' => [249,250,251,252],
        'N' => [209],
        'n' => [241],
        'Y' => [221],
        'y' => [253,255],
        'AE' => [306],
        'ae' => [346],
        'OE' => [188],
        'oe' => [189]
      }


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


      # Remove the accents from the string. Uses ACCENTS_MAPPING as the source map.
      def removeaccents
        str = String.new(self)
        ACCENTS_MAPPING.each {|letter,accents|
          packed = accents.pack('U*')
          rxp = Regexp.new("[#{packed}]", nil, 'U')
          str.gsub!(rxp, letter)
        }

        str
      end

      # Convert a string to a format suitable for a URL without ever using escaped characters.
      # It calls strip, removeaccents, downcase (optional) then removes the spaces (optional)
      # and finally removes any characters matching the default regexp (/[^-_A-Za-z0-9]/).
      #
      # Options
      #
      # * :downcase => call downcase on the string (defaults to true)
      # * :convert_spaces => Convert space to underscore (defaults to false)
      # * :regexp => The regexp matching characters that will be converting to an empty string (defaults to /[^-_A-Za-z0-9]/)
      def urlize(options = {})
        options[:downcase] ||= true
        options[:convert_spaces] ||= false
        options[:regexp] ||= /[^-_A-Za-z0-9]/

        str = self.strip.removeaccents
        str.downcase! if options[:downcase]
        str.gsub!(/\ /,'_') if options[:convert_spaces]
        str.gsub(options[:regexp], '')
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
