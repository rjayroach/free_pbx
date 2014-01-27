class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  layout "layouts/mcp_common/application"
end
