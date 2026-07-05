module Components
  module Posts
    class PinContent::Meta < Components::Pins::Pin::MetaBase
      def view_template(&)
        if @pin.pinable.is_a?(Post::Url)
          render Components::Posts::Url::PinContent::Meta.new(pin: @pin)
        elsif @pin.pinable.is_a?(Post::Text)
          render Components::Posts::Text::PinContent::Meta.new(pin: @pin)
        elsif @pin.pinable.is_a?(Post::Image)
          render Components::Posts::Image::PinContent::Meta.new(pin: @pin)
        else
          raise "Unknown post type: #{@pin.pinable.class.name}"
        end
      end
    end
  end
end
