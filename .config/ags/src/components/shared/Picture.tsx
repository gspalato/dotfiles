import GObject from "gi://GObject"
import { Gtk, astalify, type ConstructProps } from "astal/gtk4"

type PictureProps = ConstructProps<Gtk.Picture, Gtk.Picture.ConstructorProps>
export const Picture = astalify<Gtk.Picture, Gtk.Picture.ConstructorProps>(Gtk.Picture, {
    // if it is a container widget, define children setter and getter here
    getChildren(self) { return [] },
    setChildren(self, children) { },
})