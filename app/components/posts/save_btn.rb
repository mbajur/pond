module Components
  module Posts
    class SaveBtn < Components::Base
      def initialize(post:)
        @post = post
      end

      def view_template(&)
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
