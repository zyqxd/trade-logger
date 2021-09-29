# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def extension(extension_module, *args)
      extension_module.define(self, *args)
    end

    def belongs_to_polymorphic(name, allowed_classes:, **options)
      belongs_to name, polymorphic: true, **options

      validates(
        "#{name}_type",
        inclusion: {
          in: allowed_classes.map(&:name),
          allow_nil: !options[:optional].nil?,
        },
      )

      define_singleton_method("#{name}_types") { allowed_classes }

      define_singleton_method("with_#{name}") do |type|
        type = case type
               when Class then type.name
               when String then type
               else type.class.name
               end
        where(arel_table["#{name}_type".to_sym].eq(type))
      end

      allowed_classes.each do |model|
        scope "with_#{name}_#{model.name.underscore.tr('/', '_')}", lambda {
          where(arel_table["#{name}_type".to_sym].eq(model.name))
        }
      end
    end
  end
end
