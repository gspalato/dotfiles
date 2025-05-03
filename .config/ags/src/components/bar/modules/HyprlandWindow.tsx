import { Astal, Gtk, Gdk, App, Widget } from 'astal/gtk4';
import { Variable, GLib, bind, exec } from 'astal';

import Hyprland from 'gi://AstalHyprland?version=0.1';
import { getIconFromClass } from '../../../../utils';
import Pango from 'gi://Pango?version=1.0';

type Props = {
    maxLength?: number;
};

export const HyprlandWindowInner = (props: Props & { isFocused: Variable<boolean> }) => {
    const { isFocused, maxLength = 25 } = props;

    const hypr = Hyprland.get_default();
    const focused = bind(hypr, 'focusedClient');

    return focused.as((client: any) => {
        if (client === null) return [];

        const iconName = getIconFromClass(client.initialClass);

        return [
            Widget.Image({
                cssClasses: ['window-icon'],
                iconName: iconName,
                visible: !!iconName
            }),
            Widget.Label({
                ellipsize: Pango.EllipsizeMode.END,
                max_width_chars: maxLength,
                label: bind(client, 'title').as(String)
            })
        ];
    })
}

export const HyprlandWindow = (props: Props) => {
    const { maxLength = 25 } = props;

    const hypr = Hyprland.get_default();
    const focused = bind(hypr, 'focusedClient');

    return Widget.Box({
        cssClasses: ['window', 'module', 'space-between-ltr'],
        visible: bind(focused).as(Boolean),
        children: focused.as((client: any) => {
            if (client === null) return [];

            const iconName = getIconFromClass(client.initialClass);

            return [
                Widget.Image({
                    cssClasses: ['window-icon'],
                    iconName: iconName,
                    visible: !!iconName
                }),
                Widget.Label({
                    ellipsize: Pango.EllipsizeMode.END,
                    max_width_chars: maxLength,
                    label: bind(client, 'title').as(String)
                })
            ];
        })
    });
};
