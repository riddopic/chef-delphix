require 'spec_helper'

describe 'LKOUT003' do
  let(:fc_run) do
    foodcritic_run('LKOUT003')
  end

  it "generates a warning against invalid_user.rb's spec file" do
    expect(warnings(fc_run)).to include('invalid_user.rb')
  end

  it "doesn't generate a warning against valid_user.rb's spec file" do
    expect(warnings(fc_run)).to_not include('valid_user.rb')
  end
end
