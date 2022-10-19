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

  with "bang method" do
    it "aliases to #call" do
      expect(user.brother!).to be == "Andy Moss"
    end

    with "arguments" do
      it "passes through arguments" do
        expect(user.brother!("?")).to be == "Andy Moss?"
      end
    end
  end

  with "predicate method" do
    it "aliases to #predicate" do
      expect(user.brother?).to be == true
    end
  end
end
