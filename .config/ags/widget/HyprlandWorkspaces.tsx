import { App } from 'astal/gtk3';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import Hyprland from 'gi://AstalHyprland?version=0.1';

type Props = {
    icons?: Record<number | '*', string>;
    persistentWorkspaces?: number[];
    showEmpty?: boolean;
    currentIcon?: string;
};

export const HyprlandWorkspaces = (props: Props) => {
    const { icons, showEmpty = true, currentIcon } = props;

    const hypr = Hyprland.get_default();

    return (
        <box className="workspaces module">
            {bind(hypr, 'workspaces').as((wss) =>
                wss
                    .filter((ws) => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
                    .sort((a, b) => a.id - b.id)
                    .map((ws) => (
                        <button
                            className={bind(hypr, 'focusedWorkspace').as((fw) =>
                                ws === fw ? 'focused' : ''
                            )}
                            onClicked={() => ws.focus()}
                            vexpand={false}
                        >
                            {bind(hypr, 'focusedWorkspace').as((fw) =>
                                ws === fw
                                    ? currentIcon
                                    : icons?.[ws.id] || icons?.['*'] || ws.id
                            )}
                        </button>
                    ))
            )}
        </box>
    );
};
