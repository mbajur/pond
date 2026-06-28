module Components
  module Posts
    class Url::Thumb < PostCard::ThumbBase
      def view_template(&)
        container do
          image
        end
      end

      private

      def image
        if @post.screenshot.attached?
          screenshot_image
        elsif @post.thumb.attached?
          thumb_image
        end
      end

      def screenshot_image
        img(src: rails_blob_path(@post.screenshot.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
      end

      def thumb_image
        img(src: rails_blob_path(@post.thumb.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
      end
    end
  end
end
