# frozen_string_literal: true

require 'test_helper'

class IndenterTest < Minitest::Test

  def setup
    @ind = Tzispa::Utils::Indenter.new 2
  end

  def test_indenter
    str_t = 'indenter test'
    assert_equal (@ind.indent << str_t).to_s,
                 '  indenter test'
    assert_equal (@ind.indent << str_t).to_s,
                 '  indenter test    indenter test'
    assert_equal (@ind.unindent << str_t).to_s,
                 '  indenter test    indenter test  indenter test'
    assert_equal (@ind.unindent << str_t).to_s,
                 '  indenter test    indenter test  indenter testindenter test'
  end

end
