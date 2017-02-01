require 'i18n'
require 'sanitize'
require 'escape_utils'
require 'i18n'

module Tzispa
  module Utils

    refine Integer do

      def to_filesize(precission=1)
        fsz = {
          I18n.t('number.human.storage_units.byte.other', default: 'Bytes')  => 1024,
          I18n.t('number.human.storage_units.kb', default: 'KB')             => 1024 * 1024,
          I18n.t('number.human.storage_units.mb', default: 'MB')             => 1024 * 1024 * 1024,
          I18n.t('number.human.storage_units.gb', default: 'GB')             => 1024 * 1024 * 1024 * 1024,
          I18n.t('number.human.storage_units.tb', default: 'TB')             => 1024 * 1024 * 1024 * 1024 * 1024
        }.select { |k, v| self < v }.first
        ns = (self.to_f / (fsz[1] / 1024)).round(precission).to_s.split('.')
        n = ns[1].to_i == 0 ? ns[0] : ns.join( I18n.t('number.format.separator', default: '.') )
        u = fsz[0]
        fmt = I18n.t('number.human.storage_units.format', default:  '%n %u')
        fmt.sub('%n', n).sub('%u', u)
      end

    end


  end
end