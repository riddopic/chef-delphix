require 'spec_helper'

describe 'LKOUT002' do
  let(:fc_run) do
    foodcritic_run('LKOUT002')
  end

  it "generates a warning against invalid_apt_resource.rb's spec file" do
    expect(warnings(fc_run)).to include('invalid_apt_resource.rb')
  end

  it "doesn't generate a warning against valid_apt_resource.rb's spec file" do
    expect(warnings(fc_run)).to_not include('valid_apt_resource.rb')
  end
end
