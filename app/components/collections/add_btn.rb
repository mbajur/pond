module Components
  module Collections
    class AddBtn < Components::Base
      def initialize(collection:)
        @collection = collection
      end

      def view_template(&)
        Dialog do
          DialogTrigger do
            Button { "Add Collection" }
          end
          DialogContent do
            DialogHeader do
              DialogTitle { "Add Collection" }
              DialogDescription { "Pick a name, description and settings for your new collection" }
            end
            DialogMiddle do
              render Components::Collections::Form.new(collection: @collection)
            end
            DialogFooter do
              Button(class: "w-full", type: "submit", form: "collection_form") { "Create collection" }
            end
          end
        end
      end
    end
  end
end
