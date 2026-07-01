# frozen_string_literal: true

class Views::Sessions::Create < Views::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::TurboFrameTag

  def view_template
    turbo_frame_tag(:session_form) do
      Heading(level: 2) { "Check your email" }
      Text(size: "2", class: "text-muted-foreground") {
        "If an account with that email exists, we've sent a verification code. Enter it below:"
      }

      form_with url: verify_auth_code_path, method: :post, class: "flex flex-col gap-4 mt-6" do |f|
        div(class: "mb-3") do
          f.text_field(:auth_code, placeholder: "••••••", autocomplete: "one-time-code", required: true, autofocus: true, class: input_classes)
        end

        Button(type: :submit) { "Verify the code" }
      end

      Text(size: "2", class: "text-muted-foreground mt-3") {
        "The code will work for 15 minutes."
      }
    end
  end

  private

  def input_classes
    "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm"
  end
end
