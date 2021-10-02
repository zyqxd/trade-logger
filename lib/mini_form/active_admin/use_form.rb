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
              @resource.attributes = params.permit(*@resource.attribute_names)

              set_redirect
            end

            def create
              @resource = the_form_class.new
              @resource.update params.permit![resource_class.name.underscore.tr(
                '/', '_'
              ).to_sym]

              if @resource.valid?
                redirect_to(
                  get_redirect,
                  notice: "#{@resource.class.name } #{ @resource.id } Created",
                )
              end
            end

            def edit
              @resource = the_form_class.new find_resource

              set_redirect
            end

            def update
              @resource = the_form_class.new find_resource
              @resource.update params.permit![resource_class.name.underscore.tr(
                '/', '_'
              ).to_sym]

              # NOTE(DZ): POST is used by form submission. We also use PUT in
              # best-in-place editors
              if @resource.valid? && request.method == 'POST'
                redirect_to(
                  get_redirect,
                  notice: "#{@resource.class.name } #{ @resource.id } Updated",
                )
              end
            end

            private

            def set_redirect
              cookies[:succes_redirect_url] = request.referer
            end

            def get_redirect
              cookies[:succes_redirect_url]
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
