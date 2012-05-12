require 'smilodon'
require 'rails'

module Smilodon
  class Railtie < Rails::Railtie
    railtie_name :smilodon

    rake_tasks do
      load 'tasks/smilodon.rake'
    end
  end
end
