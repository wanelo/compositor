require 'spec_helper'

describe Compositor::Literal do

  let(:context) { Object.new }

  it 'returns the hash its given' do
    actual = { test: 123 }

    Compositor::Literal.new(context, actual).to_hash.should == actual
  end
end
