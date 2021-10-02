# frozen_string_literal: true

# # frozen_string_literal: true

module Admin
  module BestInPlaceHelper
    def bip_tag(resource, field, reload: false, **kargs)
      locked = resource.respond_to?(:locked?) ? resource.locked? : false
      return resource.public_send(field) if locked

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

      if resource.respond_to?(:locked?) ? resource.locked? : false
        content_tag(
          'span',
          resource.status,
          class: "status_tag #{resource.status}",
        )
      else
        bip_tag(
          resource,
          :status,
          class: "status_tag #{resource.status}",
          as: :select,
          url: [:admin, resource],
          collection: resource_class.statuses,
          **kargs,
        )
      end
    end

    def bip_kind(resource, **kargs)
      if resource.respond_to?(:locked?) ? resource.locked? : false
        content_tag 'span', resource.kind, class: "status_tag #{resource.kind}"
      else
        bip_tag(
          resource,
          :short?,
          class: "status_tag #{resource.kind}",
          as: :checkbox,
          url: [:toggle_kind, :admin, resource],
          collection: %w[long short],
          **kargs,
        )
      end
    end
  end
end
