#require 'private_pub'

module FreePbx
  class Engine < ::Rails::Engine
    isolate_namespace FreePbx

    config.generators do |g|
      g.test_framework :rspec,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => false,
        :request_specs => false,
        :fixtures => true
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.helper = false
      g.stylesheets = false
    end 

  end
end


