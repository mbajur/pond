module Components
  module Icons
    class Menu < Phlex::SVG
      def view_template
        svg(
          xmlns: "http://www.w3.org/2000/svg",
          width: "24",
          height: "24",
          viewBox: "0 0 24 24",
          fill: "none",
          stroke: "currentColor",
          stroke_width: "2",
          stroke_linecap: "round",
          stroke_linejoin: "round",
          class: "lucide lucide-menu-icon lucide-menu"
        ) do
          path(d: "M4 5h16")
          path(d: "M4 12h16")
          path(d: "M4 19h16")
        end
      end
    end
  end
end
