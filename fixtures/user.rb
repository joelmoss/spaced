# frozen_string_literal: true

class User
  include Spaced

  namespace :mum do
    def full_name
      "Lesley Moss"
    end
  end

  namespace :dad, Daddy
  namespace :brother do
    def call(append = nil)
      "Andy Moss#{append}"
    end

    def predicate
      true
    end
  end
end
