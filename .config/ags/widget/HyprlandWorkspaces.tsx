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

/*
export const HyprlandWorkspaces = () => {
    const hyprland = Hyprland.get_default();

    const getButtonClass = (i: number) => {
        const className = Variable.derive(
            [bind(hyprland, 'focusedWorkspace'), bind(hyprland, 'workspaces')],
            (currentWorkspace, workspaces) => {
                if (currentWorkspace === null) return '';

                if (currentWorkspace.id === i) {
                    return 'focused';
                } else {
                    const workspaceIDs = workspaces.map((w) => w.id);
                    if (workspaceIDs.includes(i)) {
                        return 'active';
                    } else {
                        return '';
                    }
                }
            }
        );
        return className;
    };

    return (
        <box className="module workspaces">
            {Array.from({ length: 5 }, (_, i) => (
                <button
                    className={bind(getButtonClass(i + 1))}
                    valign={Gtk.Align.CENTER}
                    halign={Gtk.Align.CENTER}
                    onClick={() =>
                        hyprland.dispatch('workspace', (i + 1).toString())
                    }
                >
                    <label
                        label={''}
                        css={bind(hyprland, 'focusedWorkspace').as(
                            (currentWorkspace) =>
                                i + 1 === currentWorkspace.id
                                    ? 'min-width: 20px;'
                                    : 'min-width: 1px;'
                        )}
                    />
                </button>
            ))}
        </box>
    );
};
*/

export const HyprlandWorkspaces = (props: Props) => {
    const { icons, showEmpty = true, currentIcon } = props;

    const hypr = Hyprland.get_default();

    return (
        <box className="workspaces module">
            <box className="workspaces-container">
                {bind(hypr, 'workspaces').as((wss) =>
                    wss
                        .filter((ws) => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
                        .sort((a, b) => a.id - b.id)
                        .map((ws) => (
                            <button
                                className={bind(hypr, 'focusedWorkspace').as(
                                    (fw) => (ws === fw ? 'focused' : '')
                                )}
                                onClicked={() => ws.focus()}
                                vexpand={false}
                            >
                                {bind(hypr, 'focusedWorkspace').as((fw) =>
                                    ws === fw
                                        ? currentIcon
                                        : icons?.[ws.id] ||
                                          icons?.['*'] ||
                                          ws.id
                                )}
                            </button>
                        ))
                )}
            </box>
        </box>
    );
};
