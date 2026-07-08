module Components
  module Pins
    class Pin < Components::Base
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::TurboStreamFrom

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        div(class: "pin") do
          if @pin.pinable_type == "Post"
            render Components::Posts::CardFactory.new(@pin.pinable, context_menu: { id: dom_id(@pin, :secondary_actions), url: secondary_actions_pin_path(@pin) })
          elsif @pin.pinable_type == "Collection"
            render Components::Collections::Card.new(@pin.pinable, pin: @pin, context_menu: { id: dom_id(@pin, :secondary_actions), url: secondary_actions_pin_path(@pin) })
          end
        end
      end
    end
  end
end
