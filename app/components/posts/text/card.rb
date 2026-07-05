module Components
  module Posts
    class Text::Card < Components::Base
      def initialize(post:)
        @post = post
      end

      def view_template(&)
        Components::Posts::Card() do
          Components::Posts::CardThumb(classes: "w-full aspect-square bg-muted flex overflow-hidden p-3") do
            div(class: "overflow-auto text-sm font-normal [&_p]:mb-3 [&_h3]:scroll-m-20 [&_h3]:font-semibold [&_h3]:tracking-tight [&_h3]:text-lg [&_h3]:mb-2") do
              marksmithed(@post.content).html_safe
            end
          end
          Components::Posts::CardPrimaryActions() do |pa|
            pa.with_primary { Components::Posts::SaveBtn(post: @post) } if authenticated?
          end
          Components::Posts::CardMeta(
            title: @post.title,
            datetime: @post.created_at,
            author: @post.user
          )
        end
      end
    end
  end
end
