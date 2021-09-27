# frozen_string_literal: true

module Credentials
  module_function

  def fetch(*keys, default: nil)
    env = Rails.env.to_sym
    value = Rails.application.credentials.dig(env, *keys)

    value.presence ||
      default.presence ||
      raise("#{keys} is missing for #{env}")
  end
end
