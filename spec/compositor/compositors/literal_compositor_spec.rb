require 'spec_helper'

describe LiteralCompositor do

  let(:context) { Object.new }

  it 'returns the hash its given' do
    actual = { test: 123 }

    LiteralCompositor.new(context, actual).to_hash.should == actual
  end
end
