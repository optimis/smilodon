require 'smilodon'
require 'rails'

module Smilodon
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/populate.rake'
    end
  end
end
