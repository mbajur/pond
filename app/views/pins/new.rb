# frozen_string_literal: true

class Views::Pins::New < Views::Base
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::OptionsFromCollectionForSelect
  include Phlex::Rails::Helpers::DOMID

  def initialize(pin:, pinable:)
    @pin = pin
    @pinable = pinable
  end

  def view_template
    turbo_frame_tag :connect_dialog_content, loading: :lazy, data: { connect_dialog_target: "frame" } do
      DialogHeader do
        DialogTitle { title }
        DialogDescription { description }
      end

      DialogMiddle do
        form_with(model: @pin, url: form_url, method: :post, id: :connect_form) do |f|
          f.select :collection_id, {}, { include_blank: "Pick one of your collections" }, class: "border-border bg-transparent text-sm w-full min-w-0 appearance-none rounded-md border py-1 pr-8 pl-2.5 shadow-xs transition-[color,box-shadow] outline-none select-none ring-0 ring-ring/0 placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground focus-visible:outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-2 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:ring-destructive/20 aria-invalid:border-destructive aria-invalid:ring-2 h-9", required: true do
            options_from_collection_for_select(current_user.collections, :id, :name)
          end
        end
      end

      DialogFooter do
        Button(variant: :outline, data: { action: "click->dialog#close" }) { "Cancel" }
        Button(form: "connect_form", type: :submit) { "Save" }
      end
    end
  end

  private

  def form_url
    @pinable.is_a?(Post) ? post_pins_path(@pinable) : collection_pins_path(@pinable)
  end

  def title
    case @pinable
    when Post
      "Connect this post"
    when Collection
      "Connect this collection"
    else
      "Connect this item"
    end
  end

  def description
    case @pinable
    when Post
      "Choose a collection to connect this post to."
    when Collection
      "Choose a collection to connect #{@pinable} collection to."
    else
      "Choose a collection to connect this item to."
    end
  end
end
