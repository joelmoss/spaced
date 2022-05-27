# frozen_string_literal: true

require_relative "spaced/version"

module Spaced
  def self.included(base)
    base.extend ClassMethods
  end

  class Base
    private

    attr_reader :parent
  end

  module ClassMethods
    def namespace(name, &)
      class_name = name.to_s.split("_").collect(&:capitalize).join
      klass = eval <<-RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
        #{self}::#{class_name} = Class.new(Base, &)  # Parent::Namespace = Class.new(Base, &)
      RUBY

      inst_name = :"@#{name}"
      define_method name do
        if instance_variable_defined?(inst_name)
          instance_variable_get inst_name
        else
          cls = klass.new
          cls.instance_variable_set :@parent, self
          instance_variable_set inst_name, cls
        end
      end
    end
  end
end
