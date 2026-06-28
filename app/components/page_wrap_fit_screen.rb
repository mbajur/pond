module Components
  class PageWrapFitScreen < Components::Base
    def view_template(&)
      SidebarWrapper do
        MobileSidebar(collapsible: :icon) do
          SidebarHeader(class: "px-5 py-5 mb-0 pb-2 border-t-[1px] border-white") do
            span(class: "text-sm italic font-medium") { "● pond" }
          end

          SidebarGroup do
            SidebarMenuItem do
              form(action: search_path, method: :get) do
                input(type: :search, placeholder: "Search...", name: :q, value: helpers.params[:q], class: "flex h-9 w-full rounded-full border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm")
              end
            end
          end

          SidebarContent do
            SidebarGroup do
              SidebarMenu do
                SidebarMenuItem do
                  SidebarMenuButton(as: :a, href: feed_path) do
                    # search_icon()
                    span { "Feed" }
                  end
                end
                SidebarMenuItem do
                  SidebarMenuButton(as: :a, href: discover_path) do
                    # home_icon()
                    span { "Discover" }
                  end
                end
              end
            end
          end

          if authenticated?
            SidebarGroup do
              SidebarGroupLabel { "My Account" }

              SidebarMenu do
                SidebarMenuItem do
                  SidebarMenuButton(as: :a, href: user_path(current_user.to_param)) do
                    span { current_user.to_s }
                  end

                  DropdownMenu() do
                    SidebarMenuAction(
                      data: {
                        ruby_ui__dropdown_menu_target: "trigger",
                        action: "click->ruby-ui--dropdown-menu#toggle"
                      }
                    ) do
                      Components::Icons::Ellipsis()
                    end

                    render Components::Navbar::UserDropdownContent.new()
                  end
                end
              end
            end
          end

          SidebarRail()
        end

        SidebarInset do
          div(class: "flex flex-col h-screen") do
            Components::Navbar(position: :static, width: :full)

            yield
          end
        end
      end
    end
  end
end
