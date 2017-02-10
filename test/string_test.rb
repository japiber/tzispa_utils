require 'test_helper'

class StringTest < Minitest::Test
  using Tzispa::Utils

  @@locales = (I18n.load_path += Dir["test/res/locales/*.yml"])


  def test_that_it_has_a_version_number
    refute_nil ::Tzispa::Utils::VERSION
  end

  def test_camelize
    assert_equal "my_test".camelize, "MyTest"
    assert_equal "mytest".camelize, "Mytest"
    assert_equal "MY_TEST".camelize, "MyTest"
  end

  def test_constantize
    assert_equal "Tzispa::Utils::Decorator".constantize, Tzispa::Utils::Decorator
    assert_equal "Hash".constantize, Hash
  end

  def test_dottize
    assert_equal "Tzispa::Utils::SimpleStringParser".dottize, "tzispa.utils.simple_string_parser"
    assert_equal "SimpleStringParser".dottize, "simple_string_parser"
  end

  def test_underscore
    assert_equal "SimpleStringParser".underscore, "simple_string_parser"
    assert_equal "Tzispa::Utils::SimpleStringParser".underscore, "tzispa/utils/simple_string_parser"
  end

  def test_transliterate
    refute_nil @@locales
    refute_empty @@locales
    assert_equal "áéíóúÁÉÍÓÚñÑ".transliterate(:es), "aeiouAEIOUnN"
    assert_equal "aeiouAEIOUnN".transliterate(:es), "aeiouAEIOUnN"
  end

  def test_urlize
    refute_nil @@locales
    refute_empty @@locales
    assert "El ciprés es un árbol con leña".urlize(locale: :es) == "el_cipres_es_un_arbol_con_lena"
  end

  def test_length_constraint_wordify
    str_t = "en un lugar de la mancha de cuyo nombre no quiero acordarme"
    assert_equal str_t.length_constraint_wordify(25), "en un lugar de la mancha"
    assert_equal str_t.length_constraint_wordify(64), str_t
    assert_equal str_t.length_constraint_wordify(0),  ""
  end

  def test_escape_html
    str_t = "esto<es un>texto\" & inseguro' para html"
    assert_equal str_t.escape_html, "esto&lt;es un&gt;texto&quot; &amp; inseguro&#39; para html"
    assert_equal str_t.escape_html.unescape_html, str_t
  end

  def test_sanitize
    str_t = '<b><a href="http://foo.com/">foo</a></b><img src="bar.jpg">'
    assert_equal str_t.sanitize_html, 'foo'
    assert_equal str_t.sanitize_html(Sanitize::Config::RESTRICTED), '<b>foo</b>'
    assert_equal str_t.sanitize_html(Sanitize::Config::BASIC), '<b><a href="http://foo.com/" rel="nofollow">foo</a></b>'
    assert_equal str_t.sanitize_html(Sanitize::Config::RELAXED), '<b><a href="http://foo.com/">foo</a></b><img src="bar.jpg">'
  end

end
