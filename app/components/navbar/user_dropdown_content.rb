module Components
  class Navbar::UserDropdownContent < Components::Base
    include Phlex::Rails::Helpers::LinkTo

    def view_template(&)
      DropdownMenuContent do
        DropdownMenuLabel { "My Account" }
        DropdownMenuItem(href: user_path(current_user.to_param)) { "Profile" }
        DropdownMenuSeparator()
        DropdownMenuItem(href: sign_out_path, data: { turbo_method: :delete }) { "Sign-out" }
      end
    end
  end
end
