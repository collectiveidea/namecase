require 'test/unit'
require 'rubygems'
require 'active_support'
require File.dirname(__FILE__) + "/../lib/namecase"

class TestClass
  include CollectiveIdea::Namecase
  
  @@callbacks = []

  def initialize(attrs = {})
    @attrs = attrs
  end
  
  def [](attr_name)
    @attrs[attr_name.to_sym]
  end
  def []=(attr_name, value)
    @attrs[attr_name.to_sym] = value
  end
  
  def self.before_save(*callbacks, &block)
    @@callbacks << block
  end
  def run_callbacks
    @@callbacks.each {|callback| callback.call(self) }
  end
  
  namecase :first_name, :last_name, :middle_name, :pet, :on => :save
end


class NamecaseTest < Test::Unit::TestCase

  def test_namecase
    t = TestClass.new(:first_name => "BRANDON", :last_name => "LaSalle", :middle_name => "LouAnne", :pet => "dog")
    t.run_callbacks
    assert_equal "Brandon", t[:first_name]
    assert_equal "LaSalle", t[:last_name]
    assert_equal "LouAnne", t[:middle_name]
    assert_equal "Dog", t[:pet]
  end

end
