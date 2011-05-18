require 'populator/errors'
require 'populator/logger'

# Populator includes helper methods to ease parsing data files.
# Assigning a header and iterating over rows is handled by the
# module via a simple configuration.
# 
# @example
#   Define a module and extend it with the populator module.
#
# @example A Custom Populator.
#   module CustomPopulator
#     extend Populator
#     populates 'CustomFile'
#
#     def process(row)
#       ...
#     end
#   end
#
# @note As noted in the example the extended module defines the
#   logic to process a single row.

module Populator

  # Default directory location for data files.
  DIRECTORY = 'files'

  # Default data file type is CSV.
  TYPE = 'csv'

  # Attribute accessors for the directory, file name, header, count, rows and before hook.
  attr_accessor :logger, :directory, :file, :type, :header, :count, :rows, :before

  # Configuration helper.
  #
  # @param [String] file The data file name.
  # @option options [String] :directory ('db/populate/data_files') The location of the data file.
  # @option options [String] :type ('csv') The data file type.
  # @option options [Boolean] :header Set true if the file has a header.
  # @option options [String] :before The method to call before the run.
  def populates(file, options = {})
    # Setup the logger to log populator warnings and messages.
    self.logger = PopulateLogger.setup

    self.directory = options[:directory] || DIRECTORY
    self.file = file
    self.type = options[:type] || TYPE
    self.header = options[:header]
    self.before = options[:before]
  end

  # Parses the data file content and processes each row.
  #
  # @return [Boolean] Returns true if all rows are processed successfully.
  def run

    # Call the before hook if defined.
    #
    # @usage
    #   populates 'TestFile', :before => :inactivate
    send(before) if before

    rows = parser.parse(read)
    self.count = header ? rows.count - 1 : rows.count
    self.header = rows.shift if header
    count.times { process(rows.shift) }

    # Return true when all rows are processed.
    return true
  end

  # Stub method to be defined in the extended module.
  # 
  # @raise [Exception] Raises an exception if the extended module does not override the method.
  def process(row = nil)
    raise MethodNotOverridden
  end

  private
  
  # The parser to use based on the type of data file.
  #
  # @return [Parser, #parse] Returns the parser class to use.
  def parser
    if type == 'csv'
      require 'csv'
      return CSV::Reader
    end
  end

  # Absolute path for the data file.
  # 
  # @return [String] The absolute path.
  def path
    "#{Rails.root}/#{directory}/#{file}.#{type}"
  end

  # Reads the data file.
  #
  # @return [File] The data file contents.
  # @raise [DataFileNotConfigured] Raises an exception when the file is not configured.
  # @raise [MissingDataFile] Raises an exception when the configured file is missing.
  def read
    raise DataFileNotConfigured unless file
    raise MissingDataFile unless File.exist?(path)
    File.read path
  end
end
