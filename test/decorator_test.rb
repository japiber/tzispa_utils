require 'test_helper'

class BaseClass

  attr_accessor :a, :b

  def sum
    a+b
  end

end

class DecoratedClass < Tzispa::Utils::Decorator

  def substract
    b-a
  end

end


class DecoratorTest < Minitest::Test

  def setup
    @base = BaseClass.new
    @base.a = 12
    @base.b = 25
    @deco = DecoratedClass.new @base
  end

  def test_decorator
    assert_respond_to @deco, :sum
    assert_respond_to @deco, :a
    assert_respond_to @deco, :b
    refute_respond_to @deco.component, :substract
    assert (@base.a == @deco.a) && (@deco.a  == 12) &&
           (@base.b == @deco.b) && (@deco.b == 25) &&
           (@base.sum == @deco.sum) && (@deco.sum == 37) &&
           (@deco.substract == 13)
  end


end
