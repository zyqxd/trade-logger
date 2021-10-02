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
