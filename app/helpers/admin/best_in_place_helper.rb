# frozen_string_literal: true

# # frozen_string_literal: true

module Admin
  module BestInPlaceHelper
    def bip_tag(resource, field, reload: false, **kargs)
      # NOTE(DZ): reload data attribute is used in javascripts/admin.js:10
      data = (kargs[:data] || {}).merge(reload: reload)
      classname = "bip #{kargs[:class]}"

      best_in_place resource, field, **kargs, data: data, class: classname
    end

    def bip_boolean(resource, field, **kargs)
      classname = "status_tag #{resource.public_send(field) ? 'yes' : 'no'}"

      bip_tag resource, field, class: classname, as: :checkbox, **kargs
    end

    def bip_status(resource, field: :status, **kargs)
      resource_class = resource.try(:to_model)&.class || resource.class

      bip_tag(
        resource,
        field,
        class: "status_tag #{resource.public_send(field)}",
        as: :select,
        url: [:admin, resource],
        collection: resource_class.public_send(field.to_s.pluralize),
        **kargs,
      )
    end
  end
end
