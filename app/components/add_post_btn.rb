module Components
  class AddPostBtn < Components::Base
    include Phlex::Rails::Helpers::LinkTo

    def view_template(&)
      DropdownMenu(data: { controller: "add-post-btn" }, options: { placement: "bottom-end" }) do
        DropdownMenuTrigger(class: "w-full") do
          Button(variant: :primary, size: :sm) { "+ Add" }
        end

        DropdownMenuContent do
          DropdownMenuLabel { "What do you want to add?" }

          add_url_item if policy(Post::Url).new?
          add_text_item if policy(Post::Text).new?
          add_image_item if policy(Post::Image).new?
        end
      end
    end

    private

    def add_url_item
      DropdownMenuItem(
        href: "#",
        data_action: "click->remote-dialog-btn#openDialog:prevent",
        data: {
          controller: "remote-dialog-btn",
          add_post_btn_target: "urlBtn",
          remote_dialog_btn_url_value: new_url_posts_path(post_url: { collection_id: Current.collection&.id })
        }
      ) { "Link" }
    end

    def add_text_item
      DropdownMenuItem(
        href: "#",
        data_action: "click->remote-dialog-btn#openDialog:prevent",
        data: {
          controller: "remote-dialog-btn",
          add_post_btn_target: "textBtn",
          remote_dialog_btn_url_value: new_text_posts_path(post_text: { collection_id: Current.collection&.id })
        }
      ) { "Text" }
    end

    def add_image_item
      DropdownMenuItem(
        href: "#",
        data_action: "click->remote-dialog-btn#openDialog:prevent",
        data: {
          controller: "remote-dialog-btn",
          add_post_btn_target: "imageBtn",
          remote_dialog_btn_url_value: new_image_posts_path(post_image: { collection_id: Current.collection&.id })
        }
      ) { "Image" }
    end
  end
end
