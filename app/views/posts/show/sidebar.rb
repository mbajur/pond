module Views
  module Posts
    class Show::Sidebar < Views::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::ButtonTo

      def initialize(post:, pins:)
        @post = post
        @pins = pins
      end

      def view_template(&)
        render Components::Posts::ShowContent::Sidebar.new do
          Heading(level: 4, class: "inline") { @post.title || "Untitled" }
          Text(as: "p", size: "sm", weight: "muted", class: "mt-2") { @post.description || "No description" }
          Text(size: "1", class: "text-muted-foreground mt-3 italic") do
            meta_info
          end

          div(class: "mt-4 gap-3 flex") do
            Components::Ui::Flex(class: "gap-2") do
              Components::Posts::ConnectBtn(post: @post) if authenticated?

              if show_more_button?
                DropdownMenu(options: { placement: "bottom-end" }) do
                  DropdownMenuTrigger do
                    Button(variant: :secondary, size: :sm) { "…" }
                  end
                  DropdownMenuContent do
                    DropdownMenuLabel { "More actions" }
                    DropdownMenuSeparator
                    DropdownMenuItem(href: edit_post_path(@post)) { "Edit" } if can_edit?
                    button_to "Delete", post_path(@post), method: :delete, data: { turbo_confirm: "Are you sure?" }, class: "w-full relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground aria-selected:bg-accent aria-selected:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50" if can_destroy?
                  end
                end
              end
            end
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

      def show_more_button?
        can_edit? || can_destroy?
      end

      def can_edit?
        policy(@post).edit?
      end

      def can_destroy?
        policy(@post).destroy?
      end
    end
  end
end
