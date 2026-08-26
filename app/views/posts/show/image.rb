module Views
  module Posts
    class Show::Image < Views::Base
      class Content < Components::Base
        include Phlex::Rails::Helpers::LinkTo
        include Phlex::Rails::Helpers::ImageTag

        def initialize(post:)
          @post = post
        end

        def view_template(&)
          render Components::Posts::ShowContent::Content.new do
            source_link_wrap do
              image
            end
          end
        end

        private

        def image
          image_tag(rails_blob_path(@post.files.first.variant(:large)), class: "max-h-full")
        end

        def source_link_wrap(&block)
          if @post.url.present?
            link_to @post.url, rel: :nofollow, class: "h-full justify-center flex flex-col" do
              yield
            end
          else
            div(class: "h-full justify-center flex flex-col") do
              yield
            end
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
