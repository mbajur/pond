module Components
  module Pins
    class Pin < Components::Base
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::TurboStreamFrom

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        div(class: "flex flex-col group relative pin", id: dom_id(@pin)) do
          turbo_stream_from(@pin, :card)

          if @pin.pinable_type == "Post"
            render Components::Posts::PinContent.new(pin: @pin)
          elsif @pin.pinable_type == "Collection"
            render Components::Collections::PinContent.new(pin: @pin)
          end
        end
      end
    end
  end
end
