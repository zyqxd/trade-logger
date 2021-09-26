ActiveAdmin.setup do |config|
  config.site_title = "App"
  config.comments = false

  # Basic auth from ApplicationController
  config.authentication_method = :authenticate_admin
end
