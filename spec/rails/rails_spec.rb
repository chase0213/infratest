require 'spec_helper'

describe package('rails') do
  it { should be_installed }
end
