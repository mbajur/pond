module Components
  module Pins
    class Pin::PrimaryActions < Components::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::DOMID

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        # @todo properly distribute action container and title continer. Do not rely on bottom pdding, yuck
        div(class: "absolute bottom-0 left-0 right-0 bottom-0 p-2 pb-10 hidden group-hover:block") do
          div(class: "flex place-content-between w-full") do
            Components::Posts::ConnectBtn(post: @pin.pinable) if authenticated?
            Components::Posts::SourceBtn(href: source_url, classes: "ml-auto") if source_url.present?
          end
        end
      end
    end
  end
end
