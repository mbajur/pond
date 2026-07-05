module Components
  module Posts
    class CardContextMenu < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(url:, dom_id:)
        @url = url
        @dom_id = dom_id
      end

      def view_template(&)
        div(class: "absolute top-2 right-2 hidden group-hover:block") do
          DropdownMenu(options: { placement: "bottom-start" }) do
            DropdownMenuTrigger(class: "w-full") do
              Button(variant: :outline, size: :sm) { "More" }
            end
            DropdownMenuContent do
              turbo_frame_tag(@dom_id, src: @url, loading: :lazy) do
                DropdownMenuLabel { "Loading..." }
              end
            end
          end
        end
      end
    end
  end
end
