import GObject from 'gi://GObject';
import { Gtk, astalify, type ConstructProps } from 'astal/gtk4';
import Adw from 'gi://Adw?version=1';

type ClampProps = ConstructProps<Adw.Clamp, Adw.Clamp.ConstructorProps>;

export const Clamp = astalify<Adw.Clamp, Adw.Clamp.ConstructorProps>(
    Adw.Clamp,
    {
        // if it is a container widget, define children setter and getter here
        getChildren(self) {
            return [];
        },
        setChildren(self, children) {},
    }
);
