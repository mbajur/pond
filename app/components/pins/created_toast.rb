# frozen_string_literal: true

module Components
  module Pins
    class CreatedToast < Components::Base
      def view_template(&)
        render RubyUI::ToastItem.new(variant: :success) do
          render RubyUI::ToastIcon.new(variant: :success)
          render RubyUI::ToastTitle.new { "Pin saved to inbox" }
          render RubyUI::ToastAction.new(label: "Edit")
          render RubyUI::ToastCancel.new(label: "Undo")
        end
      end
    end
  end
end
