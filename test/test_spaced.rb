# frozen_string_literal: true

require "test_helper"

class TestSpaced < Minitest::Test
  class User
    include Spaced

    namespace :mum do
      def full_name
        "Lesley Moss"
      end
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Spaced::VERSION
  end

  def test_should_create_class
    user = User.new
    assert_kind_of TestSpaced::User::Mum, user.mum
  end

  def test_should_respond_to_parent_instance_var
    user = User.new
    assert_instance_of User, user.mum.instance_variable_get(:@parent)
  end

  def test_should_respond_to_private_parent_method
    user = User.new
    assert_instance_of User, user.mum.send(:parent)
  end

  def test_should_expose_method
    user = User.new
    assert_equal "Lesley Moss", user.mum.full_name
  end
end
