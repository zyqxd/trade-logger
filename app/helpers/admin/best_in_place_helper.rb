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

    def bip_status(resource, **kargs)
      resource_class = resource.try(:to_model)&.class || resource.class

      bip_tag(
        resource,
        status,
        class: "status_tag #{resource.status}",
        as: :select,
        url: [:admin, resource],
        collection: resource_class.statuses,
        **kargs,
      )
    end

    def bip_kind(resource, **kargs)
      bip_tag(
        resource,
        :long?,
        class: resource.kind.to_s,
        as: :checkbox,
        url: [:toggle_kind, :admin, resource],
        **kargs,
      )
    end
  end
end
