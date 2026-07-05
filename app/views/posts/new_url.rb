# frozen_string_literal: true

class Views::Posts::NewUrl < Views::Base
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
        form_with(model: @post, url: create_url_posts_path, method: :post, id: :connect_form) do |f|
          f.hidden_field :collection_id, value: @post.collection_id

          f.url_field(:url, placeholder: "Enter URL...", required: true, class: "w-full mb-2 text-xl border py-2 px-3", autocomplete: "off", autofocus: true, data: { add_pin_dialog_target: "urlInput", remote_dialog_target: "prepopulateInput" })
          Text(size: "1", class: "text-muted-foreground") { "TIP: Paste a URL anywhere on PPP to quickly add a pin." }
        end
      end

      DialogFooter do
        Button(variant: :outline, data: { action: "click->dialog#close" }) { "Cancel" }
        Button(form: "connect_form", type: :submit) { "Save" }
      end
    end
  end
end
