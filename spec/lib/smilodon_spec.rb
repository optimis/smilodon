require 'spec/spec_helper'
require 'smilodon/fakes'

describe Smilodon::Populator, 'DIRECTORY' do
  it 'should be set to the default directory' do
    Smilodon::Populator::DIRECTORY.should == 'files'
  end
end

describe FakePopulator, '.directory' do
  context 'when no directory is configured' do
    it 'should return the default directory' do
      FakePopulator.directory.should == Smilodon::Populator::DIRECTORY
    end
  end

  context 'when the directory is configured' do
    it 'should return the configured directory' do
      FakePopulatorWithOverriddenDirectory.directory.should == 'db/populate/files'
    end
  end
end

describe FakePopulator, '.file' do
  it 'should return the configured file name' do
    FakePopulator.file.should == 'TestFile'
  end
end

describe FakePopulator, '.type' do
  context 'when no file type is configured' do
    it 'should return the default file type' do
      FakePopulator.type.should == 'csv'
    end
  end

  context 'when the file type is configured' do
    it 'should return the configured file type' do
      FakePopulatorWithOverriddenType.type.should == 'excel'
    end
  end
end

describe FakePopulator, '.process(row)' do
  it 'should raise an exception with a message to define the method in the extended populator class' do
    lambda {
      FakePopulator.process
    }.should raise_exception(MethodNotOverridden)
  end
end
