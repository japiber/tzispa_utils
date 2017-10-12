# frozen_string_literal: true

require 'test_helper'

class HashTest < Minitest::Test
  using Tzispa::Utils::TzHash

  def test_symbolize
    s1 = { 'one' => 1, 'two' => 2 }
    s1s = { one: 1, two: 2 }
    assert_equal s1.symbolize.keys, [:one, :two]
    assert_equal s1.symbolize, s1s
    refute_equal s1, s1s
    s1.symbolize!
    assert_equal s1, s1s
  end

  def test_deep_symbolize
    s2 = { 'one' => 1, 'two' => { 'one' => 1, 'two' => 2 } }
    s2s = { one: 1, two: { 'one' => 1, 'two' => 2 } }
    s2d = { one: 1, two: { one: 1, two: 2 } }
    s2m = { 'one' => 1, 'two' => { one: 1, two: 2 } }
    assert_equal s2.symbolize, s2s
    assert_equal s2.deep_symbolize, s2d
    refute_equal s2, s2d
    refute_equal s2, s2m
    s2.deep_symbolize!
    assert_equal s2, s2d
  end

  def test_stringify
    s1 = { 'one' => 1, 'two' => 2 }
    s1s = { one: 1, two: 2 }
    assert_equal s1s.stringify.keys, %w(one two)
    assert_equal s1s.stringify, s1
    refute_equal s1, s1s
    s1s.stringify!
    assert_equal s1, s1s
  end

  def test_tuplify
    s1 = { 'one' => 1, 'two' => 2, 'three' => 3 }
    s2 = { file: %w(read write delete), document: %w(read update), folder: 'read' }
    assert_equal s1.tuplify,
                 [['one', 1], ['two', 2], ['three', 3]]
    assert_equal s2.tuplify,
                 [[:file, 'read'], [:file, 'write'], [:file, 'delete'],
                  [:document, 'read'], [:document, 'update'],
                  [:folder, 'read']]
  end

end
