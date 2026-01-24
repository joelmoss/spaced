# frozen_string_literal: true

class User
  include Spaced

  namespace :mum do
    def full_name
      "Lesley Moss"
    end
  end

  namespace :dad, Daddy

  namespace :sister do
    def sister!(append = nil)
      "Alex Moss#{append}"
    end

    def sister?
      true
    end

    def sister=(value)
      value
    end
  end

  namespace :mother do
    def _!(append = nil)
      "Lesley Moss#{append}"
    end

    def _?(*, **)
      true
    end

    def _=(value)
      value
    end
  end
end
