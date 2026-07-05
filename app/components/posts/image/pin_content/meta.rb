module Components
  module Posts
    module Image
      class PinContent::Meta < Pins::Pin::MetaBase
        include Phlex::Rails::Helpers::TimeAgoInWords
        include ActionView::RecordIdentifier

        private

        def title
          span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:hidden") {
            @pin.pinable.title || "Untitled"
          }
        end
      end
    end
  end
end
