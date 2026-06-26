module Components
  module Posts
    class ShowContent < Components::Base
      def initialize
        @sidebar_block = nil
        @preview_block = nil
      end

      def view_template(&)
        vanish(&)

        div(class: "grid grid-cols-12 w-full h-full min-h-0") do
          div(class: "overflow-y-auto col-span-12 lg:col-span-9") do
            @preview_block.call if @preview_block
          end

          div(class: "col-span-12 lg:col-span-3 py-4 px-6") do
            @sidebar_block.call if @sidebar_block
          end
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
