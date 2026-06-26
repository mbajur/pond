module Components
  module Posts
    module Image
      class PinContent < Components::Base
        def initialize(pin:)
          @pin = pin
        end

        def view_template(&)
          render Components::Pins::Pin::Thumb.new(pin: @pin)
          Components::Posts::CardLink(href: post_path(@pin.pinable))
          render Components::Pins::Pin::SecondaryActions.new(pin: @pin) if authenticated?
          render Components::Posts::Text::PinContent::PrimaryActions.new(pin: @pin)
          render Components::Pins::Pin::Meta.new(pin: @pin)
        end
      end
    end
  end
end
