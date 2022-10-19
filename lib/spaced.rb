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
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
    def namespace(name, klass = nil, &)
      if klass
        raise "#{klass} must be a subclass of Spaced::Base" unless klass < Spaced::Base
      else
        class_name = name.to_s.split("_").collect(&:capitalize).join
        klass = module_eval <<-RUBY, __FILE__, __LINE__ + 1
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

      if methods.include?(:call)
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}!(...); #{name}.call(...); end # def user!(...); user.call(...); end
        RUBY
      else
        define_method :"#{name}!" do
          raise NoMethodError, "undefined method `#{name}!' for #<#{klass}>. Have you defined `#{klass}#call`?", caller
        end
      end

      if methods.include?(:predicate)
        define_method(:"#{name}?") { send(name).predicate }
      else
        define_method :"#{name}?" do
          raise NoMethodError, "undefined method `#{name}?' for #<#{klass}>. Have you defined `#{klass}#predicate`?",
                caller
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
  end
end
