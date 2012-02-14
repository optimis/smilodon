require 'spec_helper'
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
    FakePopulator.files.should == ['TestFile']
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

describe FakePopulator, '.files' do
  it 'should return the configured file names' do
    FakePopulatorWithMultipleFiles.files.should == ['TestFile1', 'TestFile2', 'TestFile3']
  end

  it 'should handle an options hash' do
    FakePopulatorWithMultipleFiles.directory.should == 'db/populate/files'
  end

  it 'calls read for each file passed to populate' do
    FakePopulatorWithMultipleFiles.files.each { |f| FakePopulatorWithMultipleFiles.should_receive(:read).with(f).and_return('') }
    FakePopulatorWithMultipleFiles.run
  end
end

describe FakePopulator, '.run' do
  module TestPopulator
    extend Smilodon::Populator
    populates 'abc'
  end

  context 'header is true' do
    let!(:csv) { ["id,name", "1,atsuya"].join("\n") }

    before do 
      TestPopulator.header = true
      TestPopulator.stub(:read).and_return(csv)
      TestPopulator.should_receive(:process).once
      TestPopulator.run
    end

    it 'should process csv file' do
      TestPopulator.header.should == ["id", "name"]
    end

    it 'calls process for each non-header row' do
    end
  end

  context 'header is false' do
    let!(:csv) { ["id,name", "1,atsuya"].join("\n") }

    before do
      TestPopulator.header = false
      TestPopulator.stub(:read).and_return(csv)
      TestPopulator.should_receive(:process).twice
      TestPopulator.run
    end

    it 'should process csv file' do
      TestPopulator.header.should == false
    end
    
    it 'calls process for each row' do
    end
  end
end
