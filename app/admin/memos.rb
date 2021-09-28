# frozen_string_literal: true

ActiveAdmin.register Memo, as: 'Memo' do
  permit_params(*Memo.column_names)

  controller do
    def new
      @resource = Memo.new
      @resource.memoable_id = params[:memoable_id]
      @resource.memoable_type = params[:memoable_type]
    end
  end

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
