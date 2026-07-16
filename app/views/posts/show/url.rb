module Views
  module Posts
    class Show::Url < Views::Base
      class Content < Views::Base
        include Phlex::Rails::Helpers::LinkTo
        include Phlex::Rails::Helpers::ImageTag

        def initialize(post:)
          @post = post
        end

        def view_template(&)
          render Components::Posts::ShowContent::Content.new do
            link_to @post.url, class: "h-full flex flex-col justify-center" do
              image
            end
          end
        end

        private

        def image
          if @post.screenshot.attached?
            image_tag(rails_blob_path(@post.screenshot), class: "max-h-full")
          elsif @post.thumb.attached?
            image_tag(rails_blob_path(@post.thumb), class: "max-h-full")
          end
        end
      end

      def initialize(post:, pins:)
        @post = post
        @pins = pins
      end

      def view_template(&)
        Components::Posts::ShowContent() do |sc|
          sc.with_preview do
            render Content.new(post: @post)
          end

          sc.with_sidebar do
            render Views::Posts::Show::Sidebar.new(post: @post, pins: @pins)
          end
        end
      end
    end
  end
end
