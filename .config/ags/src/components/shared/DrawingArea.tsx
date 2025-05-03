import GObject from 'gi://GObject';
import { Gtk, astalify, type ConstructProps } from 'astal/gtk4';

type DrawingAreaProps = ConstructProps<
    Gtk.DrawingArea,
    Gtk.DrawingArea.ConstructorProps
>;

export const DrawingArea = astalify<
    Gtk.DrawingArea,
    Gtk.DrawingArea.ConstructorProps
>(Gtk.DrawingArea, {
    // if it is a container widget, define children setter and getter here
    getChildren(self) {
        return [];
    },
    setChildren(self, children) {},
});
