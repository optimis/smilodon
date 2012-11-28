require 'bundler/setup'

require 'smilodon/errors'
require 'smilodon/railtie' if defined?(Rails)

# Smilodon includes helper methods to ease parsing data files.
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

module Smilodon
  module Populator

    # Default directory location for data files.
    DIRECTORY = 'files'

    # Default data file type is CSV.
    TYPE = 'csv'

    # Attribute accessors for the directory, file name, header, rows and before hook.
    attr_accessor :logger, :directory, :files, :type, :header, :rows, :before

    # Configuration helper.
    #
    # @param [Array] args an array of strings with an optional options hash
    # @option options [String] :directory ('db/populate/data_files') The location of the data file.
    # @option options [String] :type ('csv') The data file type.
    # @option options [Boolean] :header Set true if the file has a header.
    # @option options [String] :before The method to call before the run.
    def populates(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      self.directory = if defined?(Rails) 
        "#{Rails.root}/#{options[:directory] || DIRECTORY}"
      else
        options[:directory] || DIRECTORY
      end

      self.type = options[:type] || TYPE
      self.header = options[:header]
      self.before = options[:before]
      self.files = args.empty? ? grab_files : args
    end

    # Parses the data file content and processes each row.
    #
    # @return [Boolean] Returns true if all rows are processed successfully.
    def run
      files.each do |f|
        # Call the before hook if defined.
        #
        # @usage
        #   populates 'TestFile', :before => :inactivate
        send(before) if before
        rows = parser.parse(read(f))
        rows.each_with_index do |row, index|
          if index == 0 && header
            self.header = row
          else
            process(row)
          end
        end
      end

      # Return true when all rows are processed.
      true
    end

    # Stub method to be defined in the extended module.
    # 
    # @raise [Exception] Raises an exception if the extended module does not override the method.
    def process(row = nil)
      raise MethodNotOverridden
    end

    private
    def grab_files
      Dir.glob("#{directory}/*").map do |file|
        File.basename(file, File.extname(file))
      end
    end

    # The parser to use based on the type of data file.
    #
    # @param [String] Name of file to be read
    # @return [Parser, #parse] Returns the parser class to use.
    def parser
      if type == 'csv'
        require 'csv'
        return CSV
      end
    end

    # Absolute path for the data file.
    # 
    # @return [String] The absolute path.
    def path(file)
      "#{directory}/#{file}.#{type}"
    end

    # Reads the data file.
    #
    # @param [String] Name of file to be read
    # @return [File] The data file contents.
    # @raise [DataFileNotConfigured] Raises an exception when the file is not configured.
    # @raise [MissingDataFile] Raises an exception when the configured file is missing.
    def read(file)
      raise DataFileNotConfigured unless file
      raise MissingDataFile unless File.exist?(path(file))
      File.read path(file)
    end
  end
end
