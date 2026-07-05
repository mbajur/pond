module Components
  class RemoteDialog < Components::Base
    include Phlex::Rails::Helpers::TurboFrameTag
    include Phlex::Rails::Helpers::DOMID

    def view_template(&)
      Dialog(id: :remote_dialog, data: { controller: "remote-dialog", action: "remote-dialog-btn:remote-dialog-btn-clicked@window->dialog#open remote-dialog-btn:remote-dialog-btn-clicked@window->remote-dialog#open remote-dialog-btn:prepopulate@window->remote-dialog#storePrepopulateValue" }) do
        DialogContent do
          turbo_frame_tag :remote_dialog_content, loading: :lazy, data: { remote_dialog_target: "frame", action: "turbo:frame-load->remote-dialog#onFrameLoad" } do
            DialogMiddle do
              p { "Loading..." }
            end
          end
        end
      end
    end
  end
end
