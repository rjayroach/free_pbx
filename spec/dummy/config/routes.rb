Rails.application.routes.draw do
#Dummy::Application.routes.draw do

  mount McpCommon::Engine => "/"
  mount DryAuth::Engine => "/auth"
  mount FreePbx::Engine => "/free_pbx"

  root to: McpCommon::Engine
end
