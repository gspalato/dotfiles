import { bind } from 'astal';
import { App, Astal, Gdk, Gtk, Widget } from 'astal/gtk3';
import Mpris from 'gi://AstalMpris';
import { toggleWindow } from '../utils/window';

import { APP_NAME } from '../config/data';

export interface MediaWidgetProps {
    player: Mpris.Player;
    children?: Gtk.Widget[];
}

const media = Mpris.get_default();

const MediaContainer = () => {
    const update = bind(media, 'players').as((players) => {
        const player =
            players.find((p) => p.get_entry() === 'spotify') ?? players[0];

        if (!player) {
            return '';
        }

        return <box className="media-box" vertical={true}></box>;
    });

    return update;
};

export const MediaWindow = () => {
    const handleHoverLost = (
        widget: Widget.EventBox,
        event: Astal.HoverEvent
    ) => {
        const x = Math.round(event.x);
        const y = Math.round(event.y);
        const w = widget.get_allocation().width - 15;
        const h = widget.get_allocation().height - 15;
        if (x <= 15 || x >= w || y <= 0 || y >= h) {
            toggleWindow('media-menu');
        }
    };

    return (
        <window
            name="media-menu"
            anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT}
            visible={false}
            application={App}
            namespace={APP_NAME}
        >
            <revealer
                revealChild={false}
                transitionType={Gtk.RevealerTransitionType.CROSSFADE}
            >
                <eventbox onHoverLost={handleHoverLost}>
                    {MediaContainer()}
                </eventbox>
            </revealer>
        </window>
    );
};
