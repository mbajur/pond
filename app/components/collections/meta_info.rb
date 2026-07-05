module Components
  module Collections
    class MetaInfo < Components::Base
      include Phlex::Rails::Helpers::TimeAgoInWords
      include Phlex::Rails::Helpers::Pluralize

      def initialize(collection:, opts: {})
        @collection = collection
        @opts = opts
      end

      def view_template(&)
        Text(size: "1", class: "text-muted-foreground mt-2 italic") do
          plain "private, " if @collection.private

          plain "started "
          timeago(@collection.created_at)
          plain " ago"

          if @collection.changed_at
            plain ", updated "
            timeago(@collection.changed_at)
            plain " ago"
          end

          plain ", containing #{pluralize(@collection.pins_count, "pin")}."
          plain " Run by #{@collection.user}." if @opts[:show_author]
        end
      end
    end
  end
end
