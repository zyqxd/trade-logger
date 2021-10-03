# frozen_string_literal: true

ActiveAdmin.register Plan do
  menu priority: 1

  permit_params(*Plan.column_names)

  config.filters = false

  index do
    id_column
    column :name
    column :trade_entries_count
    actions
  end

  show do
    panel 'Plan' do
      attributes_table_for resource do
        row :name
        row :timeframes, class: 'text'
        row :edge, class: 'text'
        row :risk_management, class: 'text'
        row :enter_strategy, class: 'text'
        row :exit_strategy, class: 'text'
        row :requirements, class: 'text'
        row :notes, class: 'text'
        row :created_at
        row :updated_at
      end
    end

    panel 'Entries' do
      div class: 'panel_actions' do
        link_to 'New Trade', new_admin_trade_entry_path(plan_id: resource.id)
      end
      table_for resource.trade_entries.order(created_at: :desc) do
        column :id
        column :coin
        column :status do |entry|
          bip_status entry, reload: true
        end
        column :kind do |entry|
          bip_kind entry, reload: true
        end
        column :amount
        column :profit
        column :actions do |entry|
          link_to 'View', admin_trade_entry_path(entry)
        end
      end
    end
  end

  form do |f|
    f.inputs 'Plan' do
      f.input :name, required: true

      f.input :timeframes,
              as: :text,
              hint: 'What time frame will your analysis be based on?',
              input_html: { rows: 3 }

      f.input :edge,
              as: :text,
              hint: 'What will be the main source of edge?',
              input_html: { rows: 3 }

      f.input :risk_management,
              as: :text,
              hint: 'What defines a risk management parameter?',
              input_html: { rows: 3 }

      f.input :enter_strategy,
              as: :text,
              hint: 'How will positions be entered?',
              input_html: { rows: 3 }

      f.input :exit_strategy,
              as: :text,
              hint: 'How will positions be exited?',
              input_html: { rows: 3 }

      f.input :requirements,
              as: :text,
              hint: 'Required to take entry',
              input_html: { rows: 3 }

      f.input :notes,
              as: :text,
              hint: 'Anything else you want to reference',
              input_html: { rows: 3 }
    end

    f.actions
  end
end
