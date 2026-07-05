module Components
  module Posts
    module Image
      class PinContent::PrimaryActions < Components::Pins::Pin::PrimaryActions
        private

        def source_url
          @pin.pinable&.url
        end
      end
    end
  end
end
