module Tzispa
  module Utils

    class CsvFixer < File

      def initialize(filename, mode, separator)
        @separator = separator
        super(filename, mode)
      end

      def gets(sep, limit=nil)
        line = limit ? super(sep) : super(sep, limit)
        line&.split(@separator)&.map { |field|
          field = field.strip
          if /\A\".*\"\Z/ =~ field
            "\"#{field.gsub(/\A\"(.*)\"\Z/, '\1').gsub(/([^\"])\"([^\"])/,'\1""\2')}\""
          else
            "\"#{field.gsub(/([^\"])\"([^\"])/, '\1""\2')}\""
          end
        }&.join(@separator)
      end

    end

  end
end
