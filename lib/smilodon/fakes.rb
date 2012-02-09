# A fake populator module with default type for testing.
module FakePopulator

  # Extend it with the Populator module.
  extend Smilodon::Populator

  # Populate the test file.
  populates 'TestFile'
end

# A fake populator module with overridden type for testing.
module FakePopulatorWithOverriddenType

  # Extend it with the Populator module.
  extend Smilodon::Populator

  # Populate the test excel file.
  populates 'TestExcelFile', :type => 'excel'
end

# A fake populator module with overridden directory for testing.
module FakePopulatorWithOverriddenDirectory

  # Extend it with the Populator module.
  extend Smilodon::Populator

  # Populate the test file.
  populates 'TestFile', :directory => 'db/populate/files'
end

# A fake populator module with overridden directory for testing.
module FakePopulatorWithMultipleFiles

  # Extend it with the Populator module.
  extend Smilodon::Populator

  # Populate the test file.
  populates 'TestFile1', 'TestFile2', 'TestFile3', :directory => 'db/populate/files'
end
