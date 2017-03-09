# frozen_string_literal: true

require 'mail'

module Tzispa
  module Utils

    class Mail
      attr_accessor :from, :to, :subject, :content, :cc,
                    :html, :charset, :debug

      attr_reader :config, :mail, :logger

      DEFAULT_CHARSET = 'UTF-8'

      def initialize(config, logger = nil)
        @hmtl = false
        @debug = false
        @charset = DEFAULT_CHARSET
        @logger = logger
        @config = config
        smtp_configuration(config)
        @mail = ::Mail.new
      end

      def send_mail
        recipients
        body
        mail.subject = subject
        mail.charset = charset
        mail.deliver
      rescue
        raise if debug
      end

      def add_file(path, attach_name)
        mail.attachments[attach_name] = File.read(path)
      end

      private

      def recipients
        mail.from = from
        mail.to to.split(';')
        return unless cc
        mail.cc cc.split(';')
      end

      def body
        if html
          mail.html_part do
            content_type "text/html; charset=#{charset}"
            body content
          end
        else
          mail.body = content
        end
      end

      def smtp_configuration(config)
        if config.smtp_auth
          auth_delivery(config)
        else
          delivery(config)
        end
      end

      def delivery(config)
        ::Mail.defaults do
          delivery_method :smtp, address: config.host, domain: config.domain,
                                 port: config.port, openssl_verify_mode: config.openssl_verify,
                                 enable_starttls_auto: config.starttls_auto
        end
      end

      def auth_delivery(config)
        ::Mail.defaults do
          delivery_method :smtp, address: config.host, domain: config.domain,
                                 port: config.port, authentication: config.authentication,
                                 openssl_verify_mode: config.openssl_verify,
                                 enable_starttls_auto: config.starttls_auto,
                                 user_name: config.user_name, password: config.password
        end
      end
    end

  end
end
