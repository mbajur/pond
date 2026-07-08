module Components
  module Collections
    class SaveBtn < Components::Base
      def initialize(collection:, **opts)
        @collection = collection
        @size = opts[:size] || :sm
        @variant = opts[:variant] || :secondary
      end

      def view_template(&)
        data = {
          controller: "connect-btn",
          action: "click->connect-btn#openDialog",
          connect_btn_url_value: new_collection_pins_path(@collection)
        }

        Button(data: data, variant: @variant, size: @size) { "Connect" }
      end
    end
  end
end
