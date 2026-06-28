module Views
  module Posts
    class Show::Sidebar < Views::Base
      include Phlex::Rails::Helpers::LinkTo

      def initialize(post:, pins:)
        @post = post
        @pins = pins
      end

      def view_template(&)
        Heading(level: 4, class: "inline") { @post.title || "Untitled" }
        Text(as: "p", size: "sm", weight: "muted", class: "mt-2") { @post.description || "No description" }
        Text(size: "1", class: "text-muted-foreground mt-3 italic") do
          meta_info
        end

        div(class: "mt-4 gap-3 flex") do
          Components::Posts::ConnectBtn(post: @post) if authenticated?
          Components::Posts::SourceBtn(href: @post.url, classes: "ml-auto") if @post.url.present?
        end

        if @pins.any?
          Heading(level: 6, as: :h3, class: "mt-6") { "Collections" }

          @pins.each do |pin|
            link_to(user_collection_path(pin.collection.user, pin.collection), class: "flex items-center justify-between mt-2 border-b pb-1") do
              div(class: "flex items-center gap-2") do
                Text(size: "1", class: "text-muted-foreground truncate") { pin.collection.name }
                Text(size: "1", class: "text-muted-foreground") { pin.collection.pins_count }
              end

              div(class: "flex items-center gap-2") do
                Text(size: "1", class: "text-muted-foreground truncate") { pin.user.to_s }
              end
            end
          end
        end
      end

      private

      def meta_info
        Text(size: "1", class: "text-muted-foreground mt-2 italic") do
          plain "created "
          timeago(@post.created_at)
          plain " ago by #{@post.user}"

          if @post.updated_at
            plain ", updated "
            timeago(@post.updated_at)
            plain " ago"
          end

          plain "."
        end
      end
    end
  end
end
