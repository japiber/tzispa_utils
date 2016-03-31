require 'i18n'

module Tzispa
  module Utils

    class String < ::String

      NAMESPACE_SEPARATOR        = '::'
      CLASSIFY_SEPARATOR         = '_'
      UNDERSCORE_SEPARATOR       = '/'
      UNDERSCORE_DIVISION_TARGET = '\1_\2'


      def self.constantize(str)
        self.new(str.to_s).constantize
      end

      def constantize
        names = self.split(NAMESPACE_SEPARATOR)
        names.shift if names.empty? || names.first.empty?
        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end

      def self.camelize(str)
        self.new(str.to_s).camelize
      end

      def camelize
        split(CLASSIFY_SEPARATOR).collect{ |w| w.capitalize }.join
      end

      def camelize!
        split(CLASSIFY_SEPARATOR).collect!{ |w| w.capitalize }.join
      end

      def self.underscore(str)
        self.new(str.to_s).underscore
      end

      def underscore
        dup.tap { |s|
          s.gsub!(NAMESPACE_SEPARATOR, UNDERSCORE_SEPARATOR)
          s.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
          s.downcase!
        }
      end

      def underscore!
        tap { |s|
          s.gsub!(NAMESPACE_SEPARATOR, UNDERSCORE_SEPARATOR)
          s.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
          s.downcase!
        }
      end

      # Replace accents in the string using I18n.transliterate
      def transliterate(locale=nil)
        I18n.transliterate(self, ({locale: locale} if locale))
      end

      # Convert a string to a format suitable for a URL without ever using escaped characters.
      # It calls strip, transliterate, downcase (optional) then removes the spaces (optional)
      # and finally removes any characters matching the default regexp (/[^-_A-Za-z0-9]/).
      #
      # Options
      #
      # * :downcase => call downcase on the string (defaults to true)
      # * :convert_spaces => Convert space to underscore (defaults to false)
      # * :regexp => The regexp matching characters that will be removed (defaults to /[^-_A-Za-z0-9]/)
      def urlize(options = {})
        options[:downcase] ||= true
        options[:convert_spaces] ||= true
        options[:regexp] ||= /[^-_A-Za-z0-9]/

        transliterate(options[:locale]).strip.tap { |str|
          str.downcase! if options[:downcase]
          str.gsub!(/\ /,'_') if options[:convert_spaces]
          str.gsub!(options[:regexp], '')
        }
      end

    end
  end
end

TzString = Tzispa::Utils::String
