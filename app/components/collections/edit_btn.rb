module Components
  module Collections
    class EditBtn < Components::Base
      def initialize(collection:)
        @collection = collection
      end

      def view_template(&)
        Dialog do
          DialogTrigger do
            Button(variant: :secondary, size: :sm) { "Edit Collection" }
          end
          DialogContent do
            DialogHeader do
              DialogTitle { "Edit Collection" }
              DialogDescription { "Update the name, description and settings for your collection" }
            end
            DialogMiddle do
              render Components::Collections::Form.new(collection: @collection)
            end
            DialogFooter do
              Button(class: "w-full", type: "submit", form: "collection_form") { "Update collection" }
            end
          end
        end
      end
    end
  end
end
