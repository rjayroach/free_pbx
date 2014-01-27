require_dependency "free_pbx/application_controller"

module FreePbx
  module Api
    module V1
      class TestCallsController < McpCommon::Api::ApiController

        def index; end

        # NOTE using PrivatePub.publish_to will not work if what is rendered to Faye is not the same as what is rendered in the JSON view
        # NOTE in this action will render an empty array to return via JSON since the object has no model in the database
        def create
          @channel = "/free_pbx/test_calls/test"
          @data = {extension: params[:test_call][:extension], data: params[:test_call][:data]}
          Rails.logger.debug "Publishing to #{@channel}"
        end

      end
    end
  end
end

