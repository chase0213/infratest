require 'rake'
require 'rspec/core/rake_task'
require 'json'

hosts = {}
roles = {}
dirs = Dir.glob("nodes/**/test_*.json")
dirs.each {|d|
  json_data = open(d) do |io|
    node = JSON.load(io)
    hosts[node['name']] = node['roles']
    node['roles'].each do |role|
      if roles.has_key?(role) then
        roles[role] << node['name']
      else
        roles[role] = [node['name']]
      end
    end
  end
}

class ServerspecTask < RSpec::Core::RakeTask
  attr_accessor :target
  def spec_command
    cmd = super
    "env TARGET_HOST=#{target} #{cmd}"
  end
end


namespace :spec do

  # task for each role
  roles.each do |role, names|
    desc "Run serverspec to #{role}"
    task role.to_sym => names.map {|n| 'spec:' + n + '_' + role}
  end

  # task for each node
  hosts.each do |name, roles|
    desc "Run serverspec to #{name}"
    task name.to_sym => roles.map {|r| 'spec:' + name + '_' + r}
 
    roles.each do |role|
      desc "Run serverspec to #{name}_#{role}"
      ServerspecTask.new("#{name}_#{role}".to_sym) do |t|
        t.target = name
        t.pattern = 'spec/{' + role + '}/*_spec.rb'
      end
    end

  end
end

