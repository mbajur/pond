module Components
  module Ui
    class Flex < Components::Base
      def initialize(opts = {})
        @opts = opts
      end

      def view_template(&)
        div(class: "flex #{@opts[:class]}") do
          yield if block_given?
        end
      end
    end
  end
end
