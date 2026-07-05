# frozen_string_literal: true

class Views::Posts::NewImage < Views::Base
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::FormWith

  def initialize(post:)
    @post = post
  end

  def view_template
    turbo_frame_tag :remote_dialog_content, loading: :lazy, data: { remote_dialog_target: "frame" } do
      DialogHeader do
        DialogTitle { "Add image" }
      end

      DialogMiddle do
        form_with(model: @post, url: create_image_posts_path, method: :post, id: :connect_form, data: { controller: "new-image-dialog" }) do |f|
          f.hidden_field :collection_id, value: @post.collection_id
          f.file_field(:files, input_attributes)
          div(class: "[&_img]:w-full mt-3", data: { new_image_dialog_target: "preview" })
        end
      end

      DialogFooter do
        Button(variant: :outline, data: { action: "click->dialog#close" }) { "Cancel" }
        Button(form: "connect_form", type: :submit) { "Save" }
      end
    end
  end

  private

  def input_attributes
    {
      multiple: true,
      # direct_upload: true,
      data: {
        remote_dialog_target: "prepopulateInput",
        new_image_dialog_target: "fileInput",
        action: "change->new-image-dialog#handleChange"
      },
      accept: Post::Image::AVAILABLE_CONTENT_TYPES.join(", "),
      class: "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm pt-[7px]"
    }
  end
end
