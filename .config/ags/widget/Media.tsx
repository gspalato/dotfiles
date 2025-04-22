import { bind, Variable } from 'astal';
import { Gtk, Widget } from 'astal/gtk3';
import Pango from 'gi://Pango?version=1.0';
import Mpris from 'gi://AstalMpris?version=0.1';
import { PlayerIcon } from './PlayerIcon';
import { CavaSpectrum } from './Cava';
import { toggleWindow } from '../utils/window';

const media = Mpris.get_default();

export interface MediaWidgetProps {
    player: Mpris.Player;
    children?: Gtk.Widget[];
}

export const NowPlaying = (props: {
    shouldShow: Variable<boolean>;
    player: Mpris.Player;
}) => {
    const { player, shouldShow } = props;

    const currentTrack = Variable('');

    const setup = (revealer: Widget.Revealer) => {
        const triggerTitleTimeoutReveal = (title: string) => {
            console.log('title changed:', title);
            currentTrack.set(title);

            if (!title || title === '') {
                currentTrack.set('');
                return;
            }

            revealer.revealChild = true;
            const timeoutTrack = currentTrack.get();
            setTimeout(() => {
                if (timeoutTrack === currentTrack.get())
                    if (revealer) revealer.revealChild = false;
            }, 3000);
        };

        bind(player, 'title').subscribe(triggerTitleTimeoutReveal);

        Variable.derive([shouldShow, currentTrack]).subscribe(
            ([show, track]) => {
                if (track === '' || !track) revealer.revealChild = false;
                else revealer.revealChild = show;
            }
        );

        // Check if something is playing when the app starts.
        // If it is, then trigger the timeout animation.
        const initialTitle = player.title;
        if (
            initialTitle &&
            initialTitle !== '' &&
            player.entry
        ) {
            currentTrack.set(initialTitle);
            triggerTitleTimeoutReveal(initialTitle);
        }

        /*
        shouldShow.subscribe((show) => {
            const track = currentTrack.get();
            if (track === '' || !track) revealer.revealChild = false;
            else revealer.revealChild = show;
        });
        */
    };

    const titleBind = Variable.derive(
        [bind(player, 'title'), bind(player, 'artist')],
        (title, artist) => `${title}`
    );

    return new Widget.Revealer({
        transition_type: Gtk.RevealerTransitionType.SLIDE_RIGHT,
        setup,
        halign: Gtk.Align.START,
        valign: Gtk.Align.CENTER,
        child: new Widget.Box({
            className: 'space-between-ltr',
            children: [
                PlayerIcon({ player }),
                new Widget.Label({
                    className: 'now-playing',
                    ellipsize: Pango.EllipsizeMode.END,
                    maxWidthChars: 20,
                    label: titleBind()
                }),
            ]
        })
    });
};

export const Media = () => {
    const activePlayer = Variable(false);
    const isHovering = Variable(false);

    const onHover = () => {
        isHovering.set(true);
    };

    const onHoverLost = () => {
        isHovering.set(false);
    };

    const onClick = () => {
        if (activePlayer.get()) toggleWindow('media-menu');
    };

    return new Widget.EventBox({
        visible: !!activePlayer,
        onHover,
        onHoverLost,
        onClick,
        child: new Widget.Box({
            className: 'media module space-between-ltr',
            valign: Gtk.Align.CENTER,
            children: bind(media, 'players').as((players) => {
                players = media.get_players();
                if (players.length === 0) {
                    activePlayer.set(false);
                    return [];
                }

                const player =
                    players.find((p) => p.get_entry() === 'spotify') ??
                    players[0];

                console.log('currentplayer', player.entry, player.title);

                if (!player.entry) {
                    activePlayer.set(false);
                } else {
                    activePlayer.set(true);
                }

                return [
                    NowPlaying({ player, shouldShow: isHovering }),
                    CavaSpectrum({ framerate: 240 })
                ];
            })
        })
    })
};
