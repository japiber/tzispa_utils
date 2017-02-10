require 'test_helper'

class IntegerTest < Minitest::Test
  using Tzispa::Utils

  def setup
    I18n.enforce_available_locales = false
  end

  def test_that_it_has_a_version_number
    refute_nil ::Tzispa::Utils::VERSION
  end

  def test_filesize
    assert_equal 8192.to_filesize, '8 KB'
    assert_equal 8192000.to_filesize, '7.8 MB'
    assert_equal 8388608.to_filesize, '8 MB'
    assert_equal 8589934592.to_filesize, '8 GB'
    assert_equal 0x80000000000.to_filesize, '8 TB'
    assert_equal 0x85000000000.to_filesize, '8.3 TB'
  end

  def test_localized_filesize
    locales = I18n.load_path += Dir["test/res/locales/*.yml"]
    refute_nil locales
    I18n.default_locale = :es
    assert_equal 8192.to_filesize, '8 KB'
    assert_equal 8192000.to_filesize, '7,8 MB'
    assert_equal 8388608.to_filesize, '8 MB'
    assert_equal 8589934592.to_filesize, '8 GB'
    assert_equal 0x80000000000.to_filesize, '8 TB'
    assert_equal 0x85000000000.to_filesize, '8,3 TB'
  end


end
