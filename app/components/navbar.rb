module Components
  class Navbar < Components::Base
    include Phlex::Rails::Helpers::LinkTo

    def initialize(params:)
      @params = params
    end

    def view_template(&)
      header(class: "grid grid-cols-3 h-16 shrink-0 items-center gap-2 border-b px-5 container fixed bg-white top-0 left-0 right-0 lg:border-0!") do
        div(class: "col-span-2 lg:col-span-1") do
          Link(href: root_path, variant: :link, class: "italic px-0 mr-3") do
            "● pond"
          end
        end

        div(class: "lg:col-span-1 hidden lg:block") do
          form(action: search_path, method: :get, class: "w-xs mx-auto") do
            input(type: "search", name: "q", placeholder: "Search...", value: @params[:q], class: "text-center flex h-9 w-full rounded-full border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm")
          end
        end

        div(class: "col-span-1") do
          div(class: "flex gap-3 items-center justify-end") do
            if authenticated?
              Link(href: user_path(current_user), class: "px-0 lg:hidden") { Components::Icons::CircleUserRound() }

              DropdownMenu(options: { placement: "bottom-end" }, class: "hidden lg:block") do
                DropdownMenuTrigger(class: "w-full") do
                  Button(variant: :link, class: "px-0 lg:px-4") { current_user.to_s }
                end

                render Components::Navbar::UserDropdownContent.new()
              end
            else
              Link(href: join_path, variant: :link) { "Join" }
            end

            Components::AddPostBtn()

            SidebarTrigger(class: "ml-3 lg:hidden")
          end
        end
      end
    end
  end
end
