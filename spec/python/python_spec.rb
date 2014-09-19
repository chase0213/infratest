require 'spec_helper'

describe package('python') do
  it { should be_installed }
end
