module Components
  module Posts
    class ConnectBtn < Components::Base
      include Phlex::Rails::Helpers::LinkTo

      def initialize(post:)
        @post = post
      end

      def view_template(&)
        data = {
          controller: "connect-btn",
          action: "click->connect-btn#openDialog",
          connect_btn_url_value: new_post_pins_path(@post)
        }

        Button(data: data, size: :sm, variant: :secondary) { "Connect" }
      end
    end
  end
end
