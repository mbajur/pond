module Components
  module Posts
    module Image
      class PinContent::Thumb < Components::Pins::Pin::ThumbBase
        include ActionView::RecordIdentifier

        def view_template(&)
          container do
            image
          end
        end

        private

        def image
          img(src: rails_blob_path(@pin.pinable.files.first.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
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
      end
    end
  end
end
