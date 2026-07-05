module Components
  module Posts
    class CardMeta < Components::Base
      def initialize(title:, datetime:, author:)
        @title = title
        @datetime = datetime
        @author = author
      end

      def view_template(&)
        div(class: "p-1 py-2") do
          title
          time_and_by
        end
      end

      private

      def title
        span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:hidden") {
          plain(@title.presence) || raw("&nbsp;".html_safe)
        }
      end

      def time_and_by
        span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:block hidden") {
          span { "Added " }
          span { timeago(@datetime) }
          span { " ago by #{@author}" }
        }
      end
    end
  end
end
