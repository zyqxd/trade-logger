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

            def new
              @resource = the_form_class.new
              @resource.attributes = params.permit(*@resource.attribute_names)

              set_redirect_url
            end

            def create
              @resource = the_form_class.new
              @resource.update params.permit![resource_class.name.underscore.tr(
                '/', '_'
              ).to_sym]

              return unless @resource.valid?

              redirect_to(
                redirect_url.presence || admin_root_path,
                notice: "#{@resource.class.name} #{@resource.to_param} Created",
              )
            end

            def edit
              @resource = the_form_class.new find_resource

              set_redirect_url
            end

            def update
              @resource = the_form_class.new find_resource
              @resource.update params.permit![resource_class.name.underscore.tr(
                '/', '_'
              ).to_sym]

              # NOTE(DZ): POST is used by form submission. We also use PUT in
              # best-in-place editors
              return unless @resource.valid? && request.method == 'POST'

              redirect_to(
                redirect_url.presence || admin_root_path,
                notice: "#{@resource.class.name} #{@resource.to_param} Updated",
              )
            end

            private

            def set_redirect_url
              cookies[:succes_redirect_url] = request.referer
            end

            def redirect_url
              cookies.delete(:succes_redirect_url)
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
