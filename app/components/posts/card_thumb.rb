module Components
  module Posts
    class CardThumb < Components::Base
      include Phlex::Rails::Helpers::DOMID

      def initialize(classes: "w-full aspect-square bg-muted flex items-center overflow-hidden")
        @classes = classes
      end

      def view_template(&)
        container do
          yield if block_given?
        end
      end

      private

      def container(&)
        div(class: @classes, &)
      end
    end
  end
end
