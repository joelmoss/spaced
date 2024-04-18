# frozen_string_literal: true

require "test_helper"

describe ".namespace" do
  let(:user) { User.new }

  it "should create class" do
    expect(user.mum).to be :kind_of?, User::Mum
  end

  it "should accept a class" do
    expect(user.dad).to be :kind_of?, Daddy
  end

  it "should respond to parent instance var" do
    expect(user.mum.instance_variable_get(:@parent)).to be :instance_of?, User
  end

  it "should respond to private parent method" do
    expect(user.mum.send(:parent)).to be :instance_of?, User
  end

  it "should expose methods" do
    expect(user.mum.full_name).to be == "Lesley Moss"
  end

  with "'call' bang method" do
    it "aliases to #call" do
      expect(user.brother!).to be == "Andy Moss"
    end

    with "arguments" do
      it "passes through arguments" do
        expect(user.brother!("?")).to be == "Andy Moss?"
      end
    end
  end

  with "bang named method" do
    it "aliases to #sister!" do
      expect(user.sister!).to be == "Alex Moss"
    end

    with "arguments" do
      it "passes through arguments" do
        expect(user.sister!("?")).to be == "Alex Moss?"
      end
    end
  end

  with "bang underscore method" do
    it "aliases to #_!" do
      expect(user.mother!).to be == "Lesley Moss"
    end

    with "arguments" do
      it "passes through arguments" do
        expect(user.mother!("?")).to be == "Lesley Moss?"
      end
    end
  end

  with "'predicate' method" do
    it "aliases to #predicate" do
      expect(user.brother?).to be == true
    end
  end

  with "predicate named method" do
    it "aliases to #sister?" do
      expect(user.sister?).to be == true
    end
  end

  with "predicate underscore method" do
    it "aliases to #_?" do
      expect(user.mother?).to be == true
    end

    it "supports arguments" do
      expect(user.mother?(:foo, bar: 1)).to be == true
    end
  end
end
