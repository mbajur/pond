module Components
  module Posts
    class Text::Card < Components::Base
      def initialize(post:, **opts)
        @post = post
        @context_menu = opts[:context_menu] || {}
      end

      def view_template(&)
        Components::Card() do
          Components::CardLink(href: post_path(@post))
          Components::CardContextMenu(url: @context_menu[:url], dom_id: @context_menu[:id]) if show_context_menu?
          Components::CardThumb(classes: "w-full aspect-square bg-muted flex overflow-hidden p-3") do
            div(class: "overflow-auto text-sm font-normal [&_p]:mb-3 [&_h3]:scroll-m-20 [&_h3]:font-semibold [&_h3]:tracking-tight [&_h3]:text-lg [&_h3]:mb-2") do
              marksmithed(@post.content).html_safe
            end
          end
          Components::CardPrimaryActions() do |pa|
            pa.with_primary { Components::Posts::SaveBtn(post: @post, size: :sm) } if authenticated?
          end
          Components::CardMeta(
            title: @post.title,
            datetime: @post.created_at,
            author: @post.user
          )
        end
      end

      private

      def show_context_menu?
        @context_menu[:id].present? && @context_menu[:url].present?
      end
    end
  end
end
