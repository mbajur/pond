# frozen_string_literal: true

class Views::Posts::NewText < Views::Base
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::FormWith

  def initialize(post:)
    @post = post
  end

  def view_template
    turbo_frame_tag :remote_dialog_content, loading: :lazy, data: { remote_dialog_target: "frame" } do
      DialogHeader do
        DialogTitle { "Add post" }
      end

      DialogMiddle do
        form_with(model: @post, url: create_text_posts_path, method: :post, id: :connect_form) do |f|
          f.hidden_field :collection_id, value: @post.collection_id
          f.marksmith :content, autofocus: true, placeholder: "What's on your mind?", enable_file_uploads: false, data_attributes: { remote_dialog_target: "prepopulateInput" }
        end
      end

      DialogFooter do
        Button(variant: :outline, data: { action: "click->dialog#close" }) { "Cancel" }
        Button(form: "connect_form", type: :submit) { "Save" }
      end
    end
  end
end
