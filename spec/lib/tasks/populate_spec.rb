require 'spec/spec_helper'
require 'smilodon/fakes'
require 'rake'

load 'tasks/populate.rake'

describe 'db:populate' do
  it 'should run the fake populator' do
    Rake::Task.define_task :environment
    YAML.stub(:load_file).and_return({ :populators => [ 'FakePopulator' ]})
    FakePopulator.should_receive :run
    Rake::Task['db:populate'].invoke
  end
end
