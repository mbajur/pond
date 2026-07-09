module Components
  module Posts
    class Image::Card < Components::Base
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
            pa.with_primary { Components::Posts::SaveBtn(post: @post, size: :sm) }
          end
          Components::CardMeta(
            title: @post.title,
            datetime: @post.created_at,
            author: @post.user
          )
        end
      end

      private

      def image
        img(src: rails_blob_path(@post.files.first.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
      end

      def show_context_menu?
        @context_menu[:id].present? && @context_menu[:url].present?
      end
    end
  end
end
