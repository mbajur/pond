module Views
  module Posts
    class Show::Text < Views::Base
      def initialize(post:, pins:)
        @post = post
        @pins = pins
      end

      def view_template(&)
        Components::Posts::ShowContent() do |sc|
          sc.with_preview do
            render Components::Posts::ShowContent::Content.new do
              div(class: "bg-secondary prose w-4xl max-w-none max-h-full overflow-scroll prose-h1:font-bold prose-h2:font-bold p-12") do
                raw marksmithed(@post.content).html_safe
              end
            end
          end

          sc.with_sidebar do
            render Views::Posts::Show::Sidebar.new(post: @post, pins: @pins)
          end
        end
      end
    end
  end
end
