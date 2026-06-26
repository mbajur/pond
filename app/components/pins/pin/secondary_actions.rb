module Components
  module Pins
    class Pin::SecondaryActions < Components::Base
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        div(class: "absolute z-8 top-2 right-2 hidden group-hover:block") do
          DropdownMenu(options: { placement: "bottom-start" }) do
            DropdownMenuTrigger(class: "w-full") do
              Button(variant: :outline, size: :sm) { "More" }
            end
            DropdownMenuContent do
              turbo_frame_tag(dom_id(@pin, :secondary_actions), src: secondary_actions_pin_path(@pin), loading: :lazy) do
                DropdownMenuLabel { "Loading..." }
              end
            end
          end
        end
      end
    end
  end
end
