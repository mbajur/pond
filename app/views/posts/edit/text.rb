module Views
  module Posts
    class Edit::Text < Views::Base
      include Phlex::Rails::Helpers::FormWith

      def initialize(post:)
        @post = post
      end

      def view_template
        form_with(model: @post, url: update_text_post_path(@post), method: :patch, id: :post_form, class: Components::Posts::ShowContent::CSS_CLASSES) do |f|
          render Components::Posts::ShowContent::Content.new do
            div(class: "w-4xl max-w-none max-h-full overflow-scroll p-12") do
              f.marksmith :content, enable_file_uploads: false
            end
          end

          render Components::Posts::ShowContent::Sidebar.new do
            div(class: "space-y-6") do
              div(class: "flex flex-col gap-2") do
                f.label :title, class: "empty:hidden text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 peer-aria-disabled:cursor-not-allowed peer-aria-disabled:opacity-70 peer-aria-disabled:pointer-events-none"
                f.text_field :title, class: "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm"
              end

              div(class: "flex flex-col gap-2") do
                f.label :description, class: "empty:hidden text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 peer-aria-disabled:cursor-not-allowed peer-aria-disabled:opacity-70 peer-aria-disabled:pointer-events-none"
                f.text_area :description, rows: 4, class: "flex w-full rounded-md border bg-background px-3 py-1 text-sm shadow-sm transition-colors border-border placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none"
              end

              Components::Ui::Flex(class: "gap-4 mt-6") do
                Button(form: "post_form", type: :submit, class: "flex-1") { "Save" }
                Link(href: post_path(@post), variant: :outline, class: "flex-1") { "Cancel" }
              end
            end
          end
        end
      end
    end
  end
end
