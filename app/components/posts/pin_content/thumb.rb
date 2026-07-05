module Components
  module Posts
    class PinContent::Thumb < Components::Pins::Pin::ThumbBase
      def view_template(&)
        if @pin.pinable.is_a?(Post::Url)
          render Components::Posts::Url::PinContent::Thumb.new(pin: @pin)
        elsif @pin.pinable.is_a?(Post::Text)
          render Components::Posts::Text::PinContent::Thumb.new(pin: @pin)
        elsif @pin.pinable.is_a?(Post::Image)
          render Components::Posts::Image::PinContent::Thumb.new(pin: @pin)
        else
          raise "Unknown post type: #{@pin.pinable.class.name}"
        end
      end
    end
  end
end
