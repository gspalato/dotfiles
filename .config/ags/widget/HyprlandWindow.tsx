import { App, Widget } from 'astal/gtk3';
import { Variable, GLib, bind, exec } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import Hyprland from 'gi://AstalHyprland?version=0.1';
import { getIconFromClass, truncateString } from '../utils';

type Props = {
    maxLength?: number;
};

export const HyprlandWindow = (props: Props) => {
    const { maxLength } = props;

    const hypr = Hyprland.get_default();
    const focused = bind(hypr, 'focusedClient');
    const icon = Variable.derive([focused], (client) => {
        console.log(client.initialClass, client.class);
    });

    return (
        <box
            className="window module space-between-ltr"
            visible={focused.as(Boolean)}
        >
            {focused.as((client) => {
                if (client === null) return null;

                const iconName = getIconFromClass(client.initialClass);

                return (
                    <>
                        <icon
                            className="window-icon"
                            icon={iconName}
                            visible={!!iconName}
                        />
                        <label
                            label={bind(client, 'title').as((s) =>
                                props.maxLength
                                    ? truncateString(s, props.maxLength)
                                    : s
                            )}
                        />
                    </>
                );
            })}
        </box>
    );
};
