module Components
  module Collections
    class Card < Base
      def initialize(collection, **opts)
        @collection = collection
        @pin = opts[:pin]
        @context_menu = opts[:context_menu]
      end

      def view_template(&)
        Components::Posts::Card() do
          Components::Posts::CardLink(href: user_collection_path(@collection.user, @collection))
          Components::Posts::CardContextMenu(url: @context_menu[:url], dom_id: @context_menu[:id]) if show_context_menu?
          Components::Posts::CardThumb(classes: "w-full aspect-square bg-muted flex items-center overflow-hidden p-3") do
            div(class: "text-center w-full") do
              Heading(level: 3, class: "text-sm font-semibold") { @collection.name }
              Components::Collections::MetaInfo(collection: @collection, opts: { show_author: true })
            end
          end
          Components::Posts::CardPrimaryActions() do |pa|
            pa.with_primary { Components::Collections::SaveBtn(collection: @collection, variant: :primary) } if authenticated?
          end
          Components::Posts::CardMeta(
            title: nil,
            datetime: @pin.created_at,
            author: @pin.user
          )
        end
      end

      private

      def show_context_menu?
        @context_menu[:id].present? && @context_menu[:url].present?
      end
    end
  end
end
