import { bind } from 'astal';
import { App, Astal, Gdk, Gtk, Widget } from 'astal/gtk3';
import Mpris from 'gi://AstalMpris';
import { toggleWindow } from '../utils/window';

import { APP_NAME } from '../config/data';
import Pango from 'gi://Pango?version=1.0';
import { MediaControls } from './MediaControls';

export interface MediaWidgetProps {
    player: Mpris.Player;
    children?: Gtk.Widget[];
}

const media = Mpris.get_default();

const CoverArt = ({ player }: MediaWidgetProps) => {
    return (
        <box
            className="cover-art"
            hexpand={false}
            css={bind(player, 'coverArt').as(
                (path) => `background-image: url("${path}");`
            )}
        />
    );
};

const TrackInfo = ({ player }: MediaWidgetProps) => {
    return (
        <box className="track-info" vertical={true}>
            <label
                className="track-name"
                justify={Gtk.Justification.CENTER}
                xalign={0}
                hexpand
                ellipsize={Pango.EllipsizeMode.END}
                label={bind(player, 'title')}
            />
            <label
                className="artist-name"
                justify={Gtk.Justification.CENTER}
                xalign={0}
                hexpand
                label={bind(player, 'artist')}
            />
        </box>
    );
};

const PositionSlider = ({ player }: MediaWidgetProps) => {
    const updatePosition = bind(player, 'position').as((p) =>
        player.length > 0 ? p / player.length : 0
    );

    const lengthStr = (length: number) => {
        const min = Math.floor(length / 60);
        const sec = Math.floor(length % 60);
        const sec0 = sec < 10 ? '0' : '';
        return `${min}:${sec0}${sec}`;
    };

    return (
        <box vertical={true}>
            <slider
                className="position-slider"
                drawValue={false}
                hexpand={true}
                onDragged={({ value }) => {
                    player.position = player.length * value;
                }}
                value={bind(updatePosition)}
            />
            <box className="position-label" hexpand={true}>
                <label
                    label={bind(player, 'position').as((position) =>
                        lengthStr(position)
                    )}
                    halign={Gtk.Align.START}
                    hexpand={true}
                />
                <label
                    label={bind(player, 'length').as((length) =>
                        lengthStr(length)
                    )}
                    halign={Gtk.Align.END}
                    hexpand={true}
                />
            </box>
        </box>
    );
};

const MediaContainer = () => {
    const update = bind(media, 'players').as((players) => {
        const player =
            players.find((p) => p.get_entry() === 'spotify') ?? players[0];

        if (!player) {
            return '';
        }

        return (
            <box className="media-box" vertical={true} vexpand>
                <CoverArt player={player} />
                <TrackInfo player={player} />
                <PositionSlider player={player} />
                <MediaControls player={player} />
            </box>
        );
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
