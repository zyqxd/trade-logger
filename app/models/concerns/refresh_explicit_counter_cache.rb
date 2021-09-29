# frozen_string_literal: true

# Counterpart to ExplicitCounterCache. This concern is used in the countable
# class and will execute a `refresh_` method on after_commit and after_destroy
#
module RefreshExplicitCounterCache
  module_function

  def define(model, parent_model, counter_name)
    method_name = "refresh_#{parent_model}_#{counter_name}".to_sym

    model.define_method method_name do
      public_send(parent_model).public_send("refresh_#{counter_name}")
    end

    model.instance_eval do
      after_commit method_name
      after_destroy method_name
    end
  end
end
