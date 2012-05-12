# Require the logging gem.
require 'bundler/setup'
require 'logging'

# The populate logger class.
class PopulateLogger

  # Configures the logger.
  #
  # @return [Logger] The logger instance after configuration.
  def self.setup
    configure
    logger
  end

  private

  # Configures the level.
  #
  # @param [Symbol] The log level. (defaults to :info)
  def self.level=(level)
    @level = level
  end

  # Returns the level.
  #
  # @param [String] The configured level. (defaults to :info)
  def self.level
    @level or :info
  end

  # Returns the configured logger.
  #
  # @return [Logger, #info, #debug, #warn] The logger instance.
  def self.logger
    logger = Logging.logger['example_logger']
    logger.add_appenders Logging.appenders.stdout, Logging.appenders.file(@path)
    logger.level = level
    logger
  end

  # Configures the path of the log file.
  #
  # @return [String] The path of the log file.
  def self.configure
    @path = defined?(Rails) ? "#{Rails.root}/log/populator.log" : 'populator.log'
  end
end
