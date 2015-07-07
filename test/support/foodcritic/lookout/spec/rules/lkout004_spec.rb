require 'spec_helper'

describe 'LKOUT004' do
  let(:fc_run) do
    foodcritic_run('LKOUT004')
  end

  it "generates a warning against invalid_group.rb's spec file" do
    expect(warnings(fc_run)).to include('invalid_group.rb')
  end

  it "doesn't generate a warning against valid_group.rb's spec file" do
    expect(warnings(fc_run)).to_not include('valid_group.rb')
  end
end
