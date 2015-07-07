require 'spec_helper'

describe 'LKOUT001' do
  let(:fc_run) do
    foodcritic_run('LKOUT001')
  end

  it "generates a warning against untested.rb's spec file" do
    expect(warnings(fc_run)).to include('untested_spec.rb')
  end

  it "doesn't generate a warning against tested.rb's spec file" do
    expect(warnings(fc_run)).to_not include('tested_spec.rb')
  end

  it "doesn't generate a warning against tested_alt_path.rb's spec file" do
    expect(warnings(fc_run)).to_not include('tested_alt_path_spec.rb')
  end
end
