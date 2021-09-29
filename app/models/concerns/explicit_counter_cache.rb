# frozen_string_literal: true

# Defines a counter cache on the passed scope, which is accessible under
# counter_name and can be refreshed by calling `refresh_<counter_name>`.
#
module ExplicitCounterCache
  module_function

  def define(model, counter_name, scope)
    model.define_method "refresh_#{counter_name}" do
      relation = instance_exec(&scope)
      new_count = relation.count

      return if self[counter_name] == new_count
      return if destroyed?

      # We intentionally avoid callbacks/validations here
      update_columns counter_name => new_count, updated_at: Time.current
    end
  end
end
