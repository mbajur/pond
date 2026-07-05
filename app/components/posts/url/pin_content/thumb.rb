module Components
  module Posts
    module Url
      class PinContent::Thumb < Components::Pins::Pin::ThumbBase
        include ActionView::RecordIdentifier

        def view_template(&)
          container do
            if image?
              image
            else
              div do
                marksmithed(@pin.post.content).html_safe
              end
            end
          end
        end

        private

        def image
          if @pin.options.thumb_source == "screenshot"
            if @pin.pinable.screenshot.attached?
              screenshot_image
            elsif @pin.pinable.thumb.attached?
              thumb_image
            end
          else
            if @pin.pinable.thumb.attached?
              thumb_image
            elsif @pin.pinable.screenshot.attached?
              screenshot_image
            end
          end
        end

        # I had to overwrite the default rails helper to be able render that partial outside of a view context.
        # Is there a better way to do this?
        def rails_blob_path(variant)
          if ENV["CDN_HOST"].present?
            Rails.application.routes.url_helpers.rails_storage_proxy_url(variant, host: ENV["CDN_HOST"])
          else
            Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true)
          end
        end

        def screenshot_image
          img(src: rails_blob_path(@pin.pinable.screenshot.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
        end

        def thumb_image
          img(src: rails_blob_path(@pin.pinable.thumb.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
        end

        def image?
          @pin.pinable.content.blank?
        end

        def core_container_classes
          if image?
            super
          else
            super + " p-3"
          end
        end
      end
    end
  end
end
