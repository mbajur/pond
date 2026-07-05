module Components
  module Posts
    module Text
      class PinContent::Thumb < Components::Pins::Pin::ThumbBase
        include ActionView::RecordIdentifier

        def view_template(&)
          container do
            div(class: "overflow-auto text-sm font-normal [&_p]:mb-3 [&_h3]:scroll-m-20 [&_h3]:font-semibold [&_h3]:tracking-tight [&_h3]:text-lg [&_h3]:mb-2") do
              marksmithed(@pin.post.content).html_safe
            end
          end
        end

        private

        def core_container_classes
          "w-full aspect-square bg-muted flex overflow-hidden p-3"
        end
      end
    end
  end
end
