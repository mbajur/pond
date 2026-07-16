module Components
  module Posts
    class ShowContent < Components::Base
      CSS_CLASSES = "grid grid-cols-12 w-full h-full min-h-0".freeze

      class Content < Components::Base
        CSS_CLASSES = "overflow-y-auto col-span-12 lg:col-span-9".freeze

        def view_template(&)
          div(class: CSS_CLASSES) do
            div(class: "border-r p-6 w-full h-full flex flex-col items-center justify-center") do
              yield
            end
          end
        end
      end

      class Sidebar < Components::Base
        CSS_CLASSES = "col-span-12 lg:col-span-3 py-4 px-6".freeze

        def view_template(&)
          div(class: CSS_CLASSES) do
            yield
          end
        end
      end

      def initialize
        @sidebar_block = nil
        @preview_block = nil
      end

      def view_template(&)
        vanish(&)

        div(class: CSS_CLASSES) do
          @preview_block.call if @preview_block
          @sidebar_block.call if @sidebar_block
        end
      end

      def with_preview(&block)
        @preview_block = block
        nil
      end

      def with_sidebar(&block)
        @sidebar_block = block
        nil
      end
    end
  end
end
