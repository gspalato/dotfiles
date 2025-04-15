import { App } from 'astal/gtk3';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import Hyprland from 'gi://AstalHyprland?version=0.1';
import { truncateString } from '../utils';

type Props = {
    maxLength?: number;
};

export const HyprlandWindow = (props: Props) => {
    const { maxLength } = props;

    const hypr = Hyprland.get_default();
    const focused = bind(hypr, 'focusedClient');

    return (
        <box className="window module" visible={focused.as(Boolean)}>
            {focused.as(
                (client) =>
                    client && (
                        <label
                            label={bind(client, 'title').as((s) =>
                                props.maxLength
                                    ? truncateString(s, props.maxLength)
                                    : s
                            )}
                        />
                    )
            )}
        </box>
    );
};
