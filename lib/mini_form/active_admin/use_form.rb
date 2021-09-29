# frozen_string_literal: true

module MiniForm
  module ActiveAdmin
    module UseForm
      module_function

      def call(active_admin, form_class)
        active_admin.instance_eval do
          permit_params form_class.attribute_names

          controller do
            define_method(:the_form_class) { form_class }

            def show
              @resource = the_form_class.new find_resource
            end

            def new
              @resource = the_form_class.new
              @resource.attributes = params.permit(*@resource.attributes.keys)
            end

            def create
              @resource = the_form_class.new
              @resource.update params.permit![resource_class.name.underscore.tr(
                '/', '_'
              ).to_sym]

              respond_with @resource, location: collection_path
            end

            def edit
              @resource = the_form_class.new find_resource
            end

            def update
              @resource = the_form_class.new find_resource
              @resource.update params.permit![resource_class.name.underscore.tr(
                '/', '_'
              ).to_sym]

              respond_with @resource, location: collection_path
            end
          end
        end
      end

      def extend_form(form, attribute_name)
        form.instance_eval do
          delegate :id, :persisted?, to: attribute_name

          alias_method :to_model, attribute_name

          def to_param
            id
          end
        end
      end
    end
  end
end
