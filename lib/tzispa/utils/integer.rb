# frozen_string_literal: true

require 'i18n'

module Tzispa
  module Utils

    refine Integer do
      def to_filesize(precission = 1, sep = I18n.t('number.format.separator', default: '.'))
        units, qty = __i18n_filesize
        ns = (to_f / (qty / 1024)).round(precission).to_s.split('.').join(sep)
        I18n.t('number.human.storage_units.format', default: '%n %u').sub('%n', ns).sub('%u', units)
      end

      def __i18n_filesize
        {
          I18n.t('number.human.storage_units.byte.other', default: 'Bytes') => 1024,
          I18n.t('number.human.storage_units.kb', default: 'KB') => 1024**2,
          I18n.t('number.human.storage_units.mb', default: 'MB') => 1024**3,
          I18n.t('number.human.storage_units.gb', default: 'GB') => 1024**4,
          I18n.t('number.human.storage_units.tb', default: 'TB') => 1024**5,
          I18n.t('number.human.storage_units.pb', default: 'PB') => 1024**6
        }.select { |_, v| self < v }.first
      end
    end

  end
end
