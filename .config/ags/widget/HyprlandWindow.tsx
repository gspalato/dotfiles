import { App, Widget } from 'astal/gtk3';
import { Variable, GLib, bind, exec } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import Hyprland from 'gi://AstalHyprland?version=0.1';
import { getIconFromClass, truncateString } from '../utils';
import Pango from 'gi://Pango?version=1.0';

type Props = {
    maxLength?: number;
};

export const HyprlandWindow = (props: Props) => {
    const { maxLength = 25 } = props;

    const hypr = Hyprland.get_default();
    const focused = bind(hypr, 'focusedClient');

    return (
        <box
            className="window module space-between-ltr"
            visible={focused.as(Boolean)}
        >
            {focused.as((client) => {
                if (client === null) return undefined;

                const iconName = getIconFromClass(client.initialClass);

                return [
                    <>
                        <icon
                            className="window-icon"
                            icon={iconName}
                            visible={!!iconName}
                        />
                        <label
                            ellipsize={Pango.EllipsizeMode.END}
                            maxWidthChars={maxLength}
                            label={bind(client, 'title').as(String)}
                        />
                    </>,
                ];
            })}
        </box>
    );
};
