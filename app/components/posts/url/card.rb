module Components
  module Posts
    class Url::Card < Components::Base
      def initialize(post:, **opts)
        @post = post
        @context_menu = opts[:context_menu] || {}
      end

      def view_template(&)
        Components::Card() do
          Components::CardLink(href: post_path(@post))
          Components::CardThumb() { image }
          Components::CardContextMenu(url: @context_menu[:url], dom_id: @context_menu[:id]) if show_context_menu?
          Components::CardPrimaryActions() do |pa|
            pa.with_primary { Components::Posts::SaveBtn(post: @post, size: :sm) } if authenticated?
            pa.with_secondary do
              Components::CardSourceLink(url: @post.url)
            end
          end
          Components::CardMeta(
            title: title,
            datetime: @post.created_at,
            author: @post.user
          )
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

      def show_context_menu?
        @context_menu[:id].present? && @context_menu[:url].present?
      end

      def title
        @post.title || @post.url.gsub(/http(s)\:\/\//, "") || "Untitled"
      end
    end
  end
end
