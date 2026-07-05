module Components
  module Posts
    class PostCard::PrimaryActionsBase < Components::Base
      include Phlex::Rails::Helpers::DOMID

      def initialize(post:)
        @post = post
      end

      def view_template(&)
        # @todo properly distribute action container and title continer. Do not rely on bottom pdding, yuck
        div(class: "absolute bottom-0 left-0 right-0 bottom-0 p-2 pb-10 hidden group-hover:block") do
          div(class: "flex place-content-between w-full") do
            save if authenticated?

            Link(href: source_url, variant: :primary, rel: :nofollow, class: "ml-auto") { "Source ↗" }
          end
        end
      end

      private

      def save
        data = {
          controller: "connect-btn",
          action: "click->connect-btn#openDialog",
          connect_btn_url_value: new_post_pins_path(@post)
        }

        Button(data: data) { "Connect" }
      end
    end
  end
end
