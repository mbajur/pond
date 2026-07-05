module Components
  module Posts
    class PostCard::MetaBase < Components::Base
      include Phlex::Rails::Helpers::DOMID

      def initialize(post:)
        @post = post
      end

      def view_template(&)
        div(class: "p-1 py-2 #{dom_id(@post, :meta)}") do
          title
          time_and_by
        end
      end

      private

      def time_and_by
        span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:block hidden") {
          span { "Added " }
          span { timeago(@post.created_at) }
          span { " ago by #{@post.user}" }
        }
      end
    end
  end
end
