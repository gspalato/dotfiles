import { Widget } from "astal/gtk3";
import Cairo from 'cairo';
import GLib from "gi://GLib";
import Hyprland from "gi://AstalHyprland?version=0.1";
import cairo from "cairo";
import { bind } from "astal";

const hyprland = Hyprland.get_default();
const maxWorkspaces = 10;

type Props = {
    size?: number;
    activeWidth?: number;
    spacing?: number;
}

export const Workspaces = (monitor: number, props: Props) => {
    const {
        size = 10,
        activeWidth = 20,
        spacing = 7,
    } = props;

    let currentWorkspace = hyprland.get_monitor(monitor).activeWorkspace.id;
    let targetWorkspace = currentWorkspace;
    let animProgress = 1.0;

    const da = new Widget.DrawingArea({
        visible: true,
        hexpand: false,
        vexpand: false,
    });

    const redraw = () => da.queue_draw();

    const animate = () => {
        if (currentWorkspace === targetWorkspace) return;

        animProgress += 0.1;
        if (animProgress >= 1.0) {
            currentWorkspace = targetWorkspace;
            animProgress = 1.0;
        }

        redraw();
        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 16, () => {
            animate();
            return GLib.SOURCE_REMOVE;
        });
    };

    da.connect("draw", (_, cr: cairo.Context) => {
        const width = da.get_allocated_width();
        const height = da.get_allocated_height();

        const workspacesToShow = Math.max(5, hyprland.workspaces.length); // Show at least 5 workspaces.
        const totalWidth = workspacesToShow * (size + spacing);
        da.set_size_request(totalWidth, height);

        let accumulatedWidth = 0; // To adjust spacing for each workspace

        // Loop through the workspaces and draw their indicators
        for (let i = 0; i < workspacesToShow; i++) {
            const isActive = i + 1 === currentWorkspace;
            const isTarget = i + 1 === targetWorkspace;

            // Calculate the animation progress for the active workspace indicator
            const progress = isTarget ? animProgress : (i + 1 === currentWorkspace ? 1 - animProgress : 0);

            // Calculate the x position dynamically based on workspace width and spacing
            const x = accumulatedWidth;
            const y = height / 2 - (size / 2);

            // Determine the width of the workspace indicator
            const w = size + (activeWidth - size) * progress;  // Dynamic width for active workspace

            // Draw the workspace indicator
            if (isTarget) {
                cr.setSourceRGBA(1, 1, 1, 1);  // Active workspace is highlighted
                // Draw pill shape for active workspace
                const cornerRadius = size / 2;  // Rounded corners
                cr.roundedRectangle(x, y, w, size, cornerRadius);
            } else {
                cr.setSourceRGBA(0.5, 0.5, 0.5, 1);  // Inactive workspaces are dimmed
                // Draw circle for inactive workspaces
                cr.arc(x + w / 2, y + (size / 2), size / 2, 0, 2 * Math.PI);
            }

            cr.fill();

            // Accumulate the width for the next workspace indicator
            accumulatedWidth += w + spacing;
        }

        return false;
    });

    // Cairo function to draw a rounded rectangle
    cairo.Context.prototype.roundedRectangle = function (x, y, width, height, radius) {
        this.moveTo(x + radius, y);
        this.lineTo(x + width - radius, y);
        this.arc(x + width - radius, y + radius, radius, 1.5 * Math.PI, 2 * Math.PI);
        this.lineTo(x + width, y + height - radius);
        this.arc(x + width - radius, y + height - radius, radius, 0, 0.5 * Math.PI);
        this.lineTo(x + radius, y + height);
        this.arc(x + radius, y + height - radius, radius, 0.5 * Math.PI, Math.PI);
        this.lineTo(x, y + radius);
        this.arc(x + radius, y + radius, radius, Math.PI, 1.5 * Math.PI);
        this.closePath();
    };

    // Hook Hyprland to track workspace changes
    hyprland.connect("notify::monitors", () => {
        const newId = hyprland.get_monitor(monitor).activeWorkspace.id;
        if (newId !== targetWorkspace) {
            targetWorkspace = newId;
            animProgress = 0.0;
            animate();
        }
    });

    bind(hyprland.get_monitor(monitor), "activeWorkspace").as(w => w.id).subscribe((id) => {
        if (id !== targetWorkspace) {
            targetWorkspace = id;
            animProgress = 0.0;
            animate();
        }
    });

    return da;
};


/*
import { Widget } from "astal/gtk3"

const Workspaces = (monitor: number) => {
    return new Widget.DrawingArea({
        className: 'workspaces module',
        hexpand: true,
        vexpand: true,
        setup: (self) => {
            self.set_size_request(
                bars * barWidth + (bars - 1) * padding,
                barHeight
            );

            self.connect('draw', (_, cr: Cairo.Context) => {
                const values = cava.get_values();
                self.queue_draw();

                const context = self.get_style_context();
                const h = self.get_allocated_height();
                const w = self.get_allocated_width();

                // Primary color fetched from CSS.
                const fg = context.get_property(
                    'color',
                    Gtk.StateFlags.NORMAL
                ) as any;

                cr.setSourceRGBA(fg.red, fg.green, fg.blue, fg.alpha);
            }
    })
}
*/