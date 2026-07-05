module Components
  module Posts
    module Text
      class PinContent::Meta < Pins::Pin::MetaBase
        include Phlex::Rails::Helpers::TimeAgoInWords
        include ActionView::RecordIdentifier

        private

        def title
          span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:hidden") {
            # Yuck...
            raw "&nbsp;".html_safe
          }
        end
      end
    end
  end
end
