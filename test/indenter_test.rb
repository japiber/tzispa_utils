require 'test_helper'

class IndenterTest < Minitest::Test

  def setup
    @ind = Tzispa::Utils::Indenter.new 2
  end

  def test_indenter
    str_t = "indenter test"
    assert (@ind.indent << str_t).to_s == "  indenter test"
    assert (@ind.indent << str_t).to_s == "  indenter test    indenter test"
    assert (@ind.unindent << str_t).to_s == "  indenter test    indenter test  indenter test"
    assert (@ind.unindent << str_t).to_s == "  indenter test    indenter test  indenter testindenter test"
  end



end
