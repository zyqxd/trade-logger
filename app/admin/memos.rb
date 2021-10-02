# frozen_string_literal: true

ActiveAdmin.register Memo, as: 'Memo' do
  MiniForm::ActiveAdmin::UseForm.call self, Memos::Admin::Form

  menu false

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Memo' do
      f.input :memoable_type, as: :select, collection: Memo.memoable_types
      f.input :memoable_id
      f.input :title
      f.input :description, as: :text, input_html: { row: 5 }
    end

    f.actions
  end
end
