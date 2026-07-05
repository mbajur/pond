module Components
  module Icons
    class CircleUserRound < Phlex::SVG
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
          class: "lucide lucide-circle-user-round-icon lucide-circle-user-round"
        ) do
          path(d: "M17.925 20.056a6 6 0 0 0-11.851.001")
          circle(cx: "12", cy: "11", r: "4")
          circle(cx: "12", cy: "12", r: "10")
        end
      end
    end
  end
end
