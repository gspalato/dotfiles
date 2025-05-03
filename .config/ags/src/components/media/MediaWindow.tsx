import { bind, exec } from 'astal';
import { App, Astal, Gdk, Gtk, Widget } from 'astal/gtk4';
import Mpris from 'gi://AstalMpris';
import { toggleWindow } from '../../utils/window';

import { APP_NAME } from '../../config/data';
import Pango from 'gi://Pango?version=1.0';
import { MediaControls } from './components/MediaControls';
import { Picture } from '../shared/Picture';
import { createScaledTexture } from '../../utils/images';
import Adw from 'gi://Adw?version=1';

export interface MediaWidgetProps {
    player: Mpris.Player;
    children?: Gtk.Widget[];
}

const media = Mpris.get_default();

const CoverArt = ({ player }: MediaWidgetProps) => {
    return bind(player, 'coverArt').as((path) => {
        const texture = createScaledTexture(250, 250, path);

        return Picture({
            cssClasses: ['cover-art'],
            hexpand: false,
            heightRequest: 250,
            widthRequest: 250,
            contentFit: Gtk.ContentFit.COVER,
            paintable: texture,
        });
    });
};

const TrackInfo = ({ player }: MediaWidgetProps) => {
    return Widget.Box({
        cssClasses: ['track-info'],
        vertical: true,
        children: [
            new Adw.Clamp({
                halign: Gtk.Align.CENTER,
                maximumSize: 250,
                child: Widget.Label({
                    cssClasses: ['track-name'],
                    halign: Gtk.Align.CENTER,
                    hexpand: false,
                    xalign: 0.5,
                    ellipsize: Pango.EllipsizeMode.END,
                    label: bind(player, 'title') ?? '',
                }),
            }),
            Widget.Label({
                cssClasses: ['artist-name'],
                halign: Gtk.Align.CENTER,
                hexpand: true,
                ellipsize: Pango.EllipsizeMode.END,
                label: bind(player, 'artist') ?? '',
            }),
        ],
    });
};

const PositionSlider = ({ player }: MediaWidgetProps) => {
    if (!player) {
        return Widget.Box();
    }

    const updatePosition = bind(player, 'position').as((p) =>
        player.length > 0 ? p / player.length : 0
    );

    const lengthStr = (length: number) => {
        const min = Math.floor(length / 60);
        const sec = Math.floor(length % 60);
        const sec0 = sec < 10 ? '0' : '';
        return `${min}:${sec0}${sec}`;
    };

    return Widget.Box({
        vertical: true,
        children: [
            Widget.Slider({
                cssClasses: ['position-slider'],
                drawValue: false,
                hexpand: true,
                onChangeValue: (self) =>
                    (player.position = player.length * self.value),
                value: bind(updatePosition),
            }),
            Widget.Box({
                cssClasses: ['position-label'],
                hexpand: true,
                children: [
                    Widget.Label({
                        label: bind(player, 'position').as((position) =>
                            lengthStr(position)
                        ),
                        halign: Gtk.Align.START,
                        hexpand: true,
                    }),
                    Widget.Label({
                        label: bind(player, 'length').as((position) =>
                            lengthStr(position)
                        ),
                        halign: Gtk.Align.END,
                        hexpand: true,
                    }),
                ],
            }),
        ],
    });
};

const MediaContainer = () => {
    const update = bind(media, 'players').as((players) => {
        const player =
            players.find((p) => p.get_entry() === 'spotify') ?? players[0];

        if (!player) {
            return Widget.Box();
        }

        return Widget.Box({
            onHoverLeave(self) {
                //toggleWindow('media-menu');
            },
            cssClasses: ['media-menu-container'],
            vertical: true,
            vexpand: true,
            children: [
                // @ts-expect-error
                CoverArt({ player }),
                TrackInfo({ player }),
                PositionSlider({ player }),
                MediaControls({ player }),
            ],
        });
    });

    return update;
};

export const MediaWindow = () => {
    return Widget.Window({
        name: 'media-menu',
        anchor: Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT,
        visible: false,
        application: App,
        namespace: APP_NAME,
        child: Widget.Revealer({
            transitionType: Gtk.RevealerTransitionType.SLIDE_RIGHT,
            child: MediaContainer(),
        }),
        setup(self) {
            self.set_default_size(-1, -1);
        },
    });
};
