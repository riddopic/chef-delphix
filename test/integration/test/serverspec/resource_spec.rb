# encoding: UTF-8

require 'serverspec'

set :backend, :exec

%w[git zsh].each do |pkg|
  describe package pkg do
    it { should be_installed }
  end
end
