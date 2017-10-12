# frozen_string_literal: true

require 'i18n'

module Tzispa
  module Utils
    module TzInteger

      refine ::Integer do
        def to_filesize(precission = 1, sep = nil)
          units, qty = __i18n_filesize
          ns = (to_f / (qty / 1024)).round(precission).to_s.split('.')
          ns.pop if ns.last.to_i.zero?
          __nu_format(ns.join(sep || I18n.t('number.format.separator', default: '.')),
                      units)
        end

        def __nu_format(number, units)
          I18n.t('number.human.storage_units.format', default: '%n %u')
              .sub('%n', number)
              .sub('%u', units)
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
end
