require 'test_helper'

class StringTest < Minitest::Test
  using Tzispa::Utils

  @@locales = (I18n.load_path += Dir["test/res/locales/*.yml"])


  def test_that_it_has_a_version_number
    refute_nil ::Tzispa::Utils::VERSION
  end

  def test_camelize
    assert "my_test".camelize == "MyTest" &&
          "mytest".camelize == "Mytest" &&
          "MY_TEST".camelize == "MyTest"
  end

  def test_constantize
    assert "Tzispa::Utils::Decorator".constantize == Tzispa::Utils::Decorator &&
           "Hash".constantize == Hash
  end

  def test_dottize
    assert "Tzispa::Utils::SimpleStringParser".dottize == "tzispa.utils.simple_string_parser" &&
           "SimpleStringParser".dottize == "simple_string_parser"
  end

  def test_underscore
    assert "SimpleStringParser".underscore == "simple_string_parser" &&
           "Tzispa::Utils::SimpleStringParser".underscore == "tzispa/utils/simple_string_parser"
  end

  def test_transliterate
    refute_nil @@locales
    refute_empty @@locales
    assert "áéíóúÁÉÍÓÚñÑ".transliterate(:es) == "aeiouAEIOUnN" &&
           "aeiouAEIOUnN".transliterate(:es) == "aeiouAEIOUnN"
  end

  def test_urlize
    refute_nil @@locales
    refute_empty @@locales
    assert "El ciprés es un árbol con leña".urlize(locale: :es) == "el_cipres_es_un_arbol_con_lena"
  end

  def test_length_constraint_wordify
    str_t = "en un lugar de la mancha de cuyo nombre no quiero acordarme"
    assert str_t.length_constraint_wordify(25) == "en un lugar de la mancha" &&
           str_t.length_constraint_wordify(64) == str_t &&
           str_t.length_constraint_wordify(0) == ""
  end


end
