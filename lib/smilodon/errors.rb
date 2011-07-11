# The exception class used when the data file is not configured.
class DataFileNotConfigured < Exception

  # Set the message to return when a data file is not configured.
  #
  # @return [String] The message to return if the data file is not configured.
  def message
    'No data file was specified. Usage: populates <file>'
  end
end

# The exception class used when the data file is missing.
class MissingDataFile < Exception

  # Set the message to return when a data file is missing.
  #
  # @return [String] The message to return if the data file is missing.
  def message
    'The data file configured is missing.'
  end
end

# The exception class used when the process method is not overridden.
class MethodNotOverridden < Exception

  # Set the message to return when the process method is not overridden.
  #
  # @return [String] The message to return when the process method is not overridden.
  def message
    'You must override the .process method in the extended populator class.'
  end
end
