# frozen_string_literal: true

require 'i18n'
require 'sanitize'
require 'escape_utils'

module Tzispa
  module Utils
    module TzString

      NAMESPACE_SEPARATOR        = '::'
      CLASSIFY_SEPARATOR         = '_'
      UNDERSCORE_SEPARATOR       = '/'
      DOT_SEPARATOR              = '.'
      UNDERSCORE_DIVISION_TARGET = '\1_\2'
      DEFAULT_ENCODING           = 'UTF-8'

      refine String do
        def constantize
          names = split(NAMESPACE_SEPARATOR)
          names.shift if names.empty? || names.first.empty?
          constant = Object
          names.each do |name|
            constant = if constant.const_defined?(name)
                         constant.const_get(name)
                       else
                         constant.const_missing(name)
                       end
          end
          constant
        end

        def camelize
          dup.camelize!
        end

        def camelize!
          split(CLASSIFY_SEPARATOR).collect!(&:capitalize).join
        end

        def dottize
          dup.dottize!
        end

        def dottize!
          tap do |s|
            s.gsub!(NAMESPACE_SEPARATOR, DOT_SEPARATOR)
            s.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
            s.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
            s.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
            s.downcase!
          end
        end

        def underscore
          dup.underscore!
        end

        def underscore!
          tap do |s|
            s.gsub!(NAMESPACE_SEPARATOR, UNDERSCORE_SEPARATOR)
            s.gsub!(/([A-Z\d]+)([A-Z][a-z])/, UNDERSCORE_DIVISION_TARGET)
            s.gsub!(/([a-z\d])([A-Z])/, UNDERSCORE_DIVISION_TARGET)
            s.gsub!(/[[:space:]]|\-/, UNDERSCORE_DIVISION_TARGET)
            s.downcase!
          end
        end

        def fix_encoding(src_enc, dest_enc = DEFAULT_ENCODING)
          dup.fix_encoding src_enc, dest_enc
        end

        def fix_encoding!(src_enc, dest_enc = DEFAULT_ENCODING)
          tap do |s|
            s.force_encoding(src_enc).encode(dest_enc)
          end
        end

        def indentize(count, char = ' ')
          dup.indentize!(count, char)
        end

        # Indent a string by count chars
        def indentize!(count, char = ' ')
          tap do |s|
            s.gsub!(/([^\n]*)(\n|$)/) do
              s1 = Regexp.last_match(1)
              s2 = Regexp.last_match(2)
              not_empty = s1 != '' || s2 != ''
              "#{char * count}#{s1}#{s2}" if not_empty
            end
          end
        end

        # Replace accents in the string using I18n.transliterate
        def transliterate(locale = nil)
          I18n.transliterate(self, ({ locale: locale } if locale))
        end

        # Convert a string to a format suitable for a URL without ever using escaped characters.
        # It calls strip, transliterate, downcase (optional) then removes the spaces (optional)
        # and finally removes any characters matching the default regexp (/[^-_A-Za-z0-9]/).
        #
        # Options
        #
        # * :downcase => call downcase on the string (defaults to true)
        # * :convert_spaces => Convert space to underscore (defaults to true)
        # * :regexp => matching characters that will be removed (defaults to /[^-_A-Za-z0-9]/)
        def urlize(options = {})
          downcase = options[:downcase] ||= true
          convert_spaces = options[:convert_spaces] ||= true
          regexp = options[:regexp] ||= /[^-_A-Za-z0-9]/
          locale = options[:locale]
          transliterate(locale).strip.tap do |str|
            str.downcase! if downcase
            str.tr!(' ', '_') if convert_spaces
            str.gsub!(regexp, '')
          end
        end

        def length_constraint_wordify(max, word_splitter = ' ')
          ml = 0
          split(word_splitter).take_while { |s| (ml += s.length + 1) <= max }.join(word_splitter)
        end

        def sanitize_html(level = nil)
          level ? Sanitize.fragment(self, level) : Sanitize.fragment(self)
        end
        alias_method :sanitize_htm, :sanitize_html

        def sanitize_filename
          gsub(%r{[\x00\/\\:\*\?\"\,\'<>\|]}, '')
        end

        def escape_html
          EscapeUtils.escape_html(self)
        end
        alias_method :escape_htm, :escape_html

        def unescape_html
          EscapeUtils.unescape_html(self)
        end
        alias_method :unescape_htm, :unescape_html

        def to_bool
          return true if self == true || self =~ /^(true|t|yes|y|1)$/i
          return false if self == false || self =~ /^(false|f|no|n|0)$/i
          raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
        end
        alias_method :to_boolean, :to_bool

        def integer?(base = 10)
          Integer(self, base)
        rescue StandardError
          false
        end

        def blank?
          match?(/\A\s*\z/)
        end
      end

      refine String.singleton_class do
        def underscore(str)
          String.new(str).underscore
        end

        def camelize(str)
          String.new(str).camelize
        end

        def dottize(str)
          String.new(str).dottize
        end

        def constantize(str)
          String.new(str).constantize
        end

        def fix_encoding(str, src_enc, dest_enc = DEFAULT_ENCODING)
          String.new(str).fix_encoding(src_enc, dest_enc)
        end

        def urlize(str)
          String.new(str).urlize
        end

        def indentize(str, count, char = ' ')
          String.new(str).indentize count, char
        end

        def sanitize_html(str, level = nil)
          String.new(str).santize(level)
        end
        alias_method :sanitize_htm, :sanitize_html

        def sanitize_filename(str)
          String.new(str).sanitize_filename
        end

        def escape_html(str)
          String.new(str).escape_html
        end
        alias_method :escape_htm, :escape_html

        def unescape_html(str)
          String.new(str).unescape_html
        end
        alias_method :unescape_htm, :unescape_html

        def to_bool(str)
          String.new(str).to_bool
        end

        def integer?(str, base = 10)
          String.new(str).integer?(base)
        end

        def blank?
          String.new(str).blank?
        end
      end

    end
  end
end
