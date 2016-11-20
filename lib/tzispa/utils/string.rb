# frozen_string_literal: true

require 'i18n'

module Tzispa
  module Utils

    refine String do

      NAMESPACE_SEPARATOR        = '::'
      CLASSIFY_SEPARATOR         = '_'
      UNDERSCORE_SEPARATOR       = '/'
      DOT_SEPARATOR              = '.'
      UNDERSCORE_DIVISION_TARGET = '\1_\2'

      def constantize
        names = self.split(NAMESPACE_SEPARATOR)
        names.shift if names.empty? || names.first.empty?
        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end

      def camelize
        split(CLASSIFY_SEPARATOR).collect{ |w| w.capitalize }.join
      end

      def camelize!
        split(CLASSIFY_SEPARATOR).collect!{ |w| w.capitalize }.join
      end

      def dottize
        dup.tap { |s|
          s.gsub!(NAMESPACE_SEPARATOR, DOT_SEPARATOR)
          s.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
          s.downcase!
        }
      end

      def dottize!
        tap { |s|
          s.gsub!(NAMESPACE_SEPARATOR, DOT_SEPARATOR)
          s.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
          s.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
          s.downcase!
        }
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

      def length_constraint_wordify(max, word_splitter=' ')
        ml = 0
        split(word_splitter).take_while { |s| (ml += s.length + 1) <= max }.join(word_splitter)
      end

    end


    refine String.singleton_class do

      def underscore(str)
        String.new(str&.to_s)&.underscore
      end

      def camelize(str)
        String.new(str&.to_s)&.camelize
      end

      def dottize(str)
        String.new(str&.to_s)&.dottize
      end

      def constantize(str)
        String.new(str&.to_s)&.constantize
      end

    end


  end
end
