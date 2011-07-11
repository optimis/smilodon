require 'rake'

namespace :db do
  desc 'Runs the populators defined in the configuration file'

  task :populate => :environment do
    populators.each do |populator|
      require "#{Rails.root}/db/populate/#{populator}" if defined?(Rails)
      Kernel.const_get(populator).run
    end
  end

  private
  def path
    defined?(Rails) ? "#{Rails.root}/config/populate.yml" : "populate.yml"
  end

  def configuration
    @configuration ||= YAML.load_file(path)
  rescue
    raise Exception, 'Missing configuration file. Add a populate.yml in the project directory or in the config/ directory for rails projects.' unless File.exists?(path)
  end

  def populators
    configuration[:populators]
  end
end
