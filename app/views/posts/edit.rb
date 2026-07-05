# frozen_string_literal: true

class Views::Posts::Edit < Views::Base
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::FormWith

  def initialize(post:)
    @post = post
  end

  def view_template
    turbo_frame_tag :remote_dialog_content, loading: :lazy, data: { remote_dialog_target: "frame" } do
      DialogHeader do
        DialogTitle { "Edit post" }
      end

      DialogMiddle do
        form_with(model: @post, url: update_text_post_path(@post), method: :patch, id: :post_form) do |f|
          f.marksmith :content, enable_file_uploads: false
        end
      end

      DialogFooter do
        Button(variant: :outline, data: { action: "click->dialog#close" }) { "Cancel" }
        Button(form: "post_form", type: :submit) { "Save" }
      end
    end
  end
end
