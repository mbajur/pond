module Components
  module Posts
    class CardPrimaryActions < Components::Base
      def initialize
        @primary_block = nil
        @secondary_block = nil
      end

      def view_template(&)
        vanish(&)

        # @todo properly distribute action container and title continer. Do not rely on bottom pdding, yuck
        div(class: "absolute bottom-0 left-0 right-0 bottom-0 p-2 pb-10 hidden group-hover:block") do
          div(class: "flex place-content-between w-full") do
            @primary_block.call if @primary_block
            @secondary_block.call if @secondary_block
          end
        end
      end

      def with_primary(&block)
        @primary_block = block
        nil
      end

      def with_secondary(&block)
        @secondary_block = block
        nil
      end
    end
  end
end
