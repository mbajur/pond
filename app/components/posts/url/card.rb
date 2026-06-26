module Components
  module Posts
    class Url::Card < Components::Base
      include Phlex::Rails::Helpers::DOMID

      def initialize(post:)
        @post = post
      end

      def view_template(&)
        Components::Posts::Card() do
          Components::Posts::CardLink(href: post_path(@post))
          Components::Posts::CardThumb() { image }
          Components::Posts::CardPrimaryActions() do |pa|
            pa.with_primary { Components::Posts::SaveBtn(post: @post) } if authenticated?
            pa.with_secondary do
              Components::Posts::CardSourceLink(url: @post.url)
            end
          end
          Components::Posts::CardMeta(
            title: @post.title || @post.url_cache.title,
            datetime: @post.created_at,
            author: @post.user
          )
        end
      end

      private

      def image
        if @post.screenshot.attached?
          screenshot_image
        elsif @post.url_cache.thumb.attached?
          thumb_image
        end
      end

      def screenshot_image
        img(src: rails_blob_path(@post.screenshot.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
      end

      def thumb_image
        img(src: rails_blob_path(@post.url_cache.thumb.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
      end
    end
  end
end
