module Components
  module Collections
    class PinContent::Thumb < Pins::Pin::ThumbBase
      include Phlex::Rails::Helpers::SimpleFormat

      def view_template(&)
        container do
          div(class: "text-center") do
            Heading(level: 3, class: "text-sm font-semibold") { @pin.pinable.name }
            Components::Collections::MetaInfo(collection: @pin.pinable, opts: { show_author: true })
          end
        end
      end

      private

      def core_container_classes
        super + " p-3"
      end

      def pinable_description
        @pin.pinable.description
      end
    end
  end
end
