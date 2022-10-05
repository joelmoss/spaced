# frozen_string_literal: true

require_relative "spaced/version"
require "forwardable"

module Spaced
  def self.included(base)
    base.extend ClassMethods
  end

  class Base
    private

    attr_reader :parent
  end

  module ClassMethods
    def namespace(name, klass = nil, &)
      if klass
        raise "#{klass} must be a subclass of Spaced::Base" unless klass < Spaced::Base
      else
        class_name = name.to_s.split("_").collect(&:capitalize).join
        klass = eval <<-RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
        #{self}::#{class_name} = Class.new(Base, &)  # Parent::Namespace = Class.new(Base, &)
        RUBY
      end

      inst_name = :"@#{name}"

      # Define the memoized namespace method.
      define_method name do
        if instance_variable_defined?(inst_name)
          instance_variable_get inst_name
        else
          cls = klass.new
          cls.instance_variable_set :@parent, self
          instance_variable_set inst_name, cls
        end
      end

      # Define the bang and predicate methods.
      methods = klass.instance_methods(false)

      if methods.include?(:call) || methods.include?(:predicate)
        extend Forwardable
        def_delegator :"#{name}", :call, :"#{name}!" if methods.include?(:call)
        def_delegator :"#{name}", :predicate, :"#{name}?" if methods.include?(:predicate)
      else
        unless methods.include?(:call)
          define_method :"#{name}!" do
            raise NoMethodError, "undefined method `#{name}!' for #<#{klass}>. Have you defined `#{klass}#call`?"
          end
        end

        unless methods.include?(:predicate)
          define_method :"#{name}?" do
            raise NoMethodError, "undefined method `#{name}?' for #<#{klass}>. Have you defined `#{klass}#predicate`?"
          end
        end
      end
    end
  end
end
