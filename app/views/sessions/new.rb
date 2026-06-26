# frozen_string_literal: true

class Views::Sessions::New < Views::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::TurboFrameTag

  def view_template
    turbo_frame_tag(:session_form) do
      Heading(level: 2) { "Sign in to pond" }
      Text(size: "2", class: "text-muted-foreground") { "Enter the email address associated with your account and we'll send you a sign-in code." }

      form_with url: join_path, method: :post, class: "flex flex-col gap-4 mt-6" do |f|
        div(class: "mb-3") do
          f.email_field(:email_address, placeholder: "name@example.com",
                                        autocomplete: "email",
                                        autofocus: true,
                                        class: "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm")
        end

        Button(type: :submit) { "Let's go!" }
      end
    end
  end
end
