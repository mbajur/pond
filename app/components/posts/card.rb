module Components
  module Posts
    class Card < Components::Base
      include Phlex::Rails::Helpers::DOMID

      def view_template(&)
        div(class: "flex flex-col group relative") do
          yield
        end
      end
    end
  end
end
