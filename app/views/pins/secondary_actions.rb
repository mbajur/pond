module Views
  module Pins
    class SecondaryActions < Views::Base
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        turbo_frame_tag(dom_id(@pin, :secondary_actions)) do
          DropdownMenuLabel { "Pin options" }

          if policy(@pin.pinable).edit?
            DropdownMenuItem(href: "#", data_action: "click->remote-dialog-btn#openDialog:prevent", data: { controller: :remote_dialog_btn, remote_dialog_btn_url_value: edit_path }) { "Edit post" }
          end

          if policy(@pin).destroy?
            DropdownMenuSeparator()
            DropdownMenuItem(href: pin_path(@pin), data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }) { "Disconnect" }
          end
        end
      end

      private

      def edit_path
        case @pin.pinable
        when Post::Text
          edit_text_post_path(@pin.pinable)
        when Post::Url
          edit_url_post_path(@pin.pinable)
        end
      end
    end
  end
end
