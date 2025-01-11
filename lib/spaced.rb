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
    def namespace(name, klass = nil, &block) # rubocop:disable Metrics/*
      if klass
        raise "#{klass} must be a subclass of Spaced::Base" unless klass < Spaced::Base
      else
        class_name = name.to_s.split("_").collect(&:capitalize).join
        klass = module_eval <<-RUBY, __FILE__, __LINE__ + 1
        #{self}::#{class_name} = Class.new(Base, &block)  # Parent::Namespace = Class.new(Base, &block)
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

      if methods.include?(:_!)
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}!(...); #{name}._!(...); end # def user!; user._!; end
        RUBY
      elsif methods.include?(:"#{name}!")
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}!(...); #{name}.#{name}!(...); end # def user!; user.user!; end
        RUBY
      elsif methods.include?(:call) # DEPRECATED
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}!(...); #{name}.call(...); end # def user!(...); user.call(...); end
        RUBY
      else
        define_method :"#{name}!" do
          raise NoMethodError,
                "undefined method `#{name}!' for #<#{klass}>. Have you defined `#{klass}#_!`?", caller
        end
      end

      if methods.include?(:_?)
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}?(...); #{name}._?(...); end # def user?; user._?; end
        RUBY
      elsif methods.include?(:"#{name}?")
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}?(...); #{name}.#{name}?(...); end # def user?; user.user?; end
        RUBY
      elsif methods.include?(:predicate) # DEPRECATED
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}?(...); #{name}.predicate(...); end # def user?; user.predicate; end
        RUBY
      else
        define_method :"#{name}?" do
          raise NoMethodError,
                "undefined method `#{name}?' for #<#{klass}>. Have you defined `#{klass}#_?`?",
                caller
        end
      end
    end
  end
end
