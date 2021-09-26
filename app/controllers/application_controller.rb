# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authenticate_admin
    return true unless Credentials.fetch(:basic_auth, :active)

    authenticate_or_request_with_http_basic('Admin') do |name, password|
      name == Credentials.fetch(:basic_auth, :user) &&
        password == Credentials.fetch(:basic_auth, :password)
    end
  end
end
