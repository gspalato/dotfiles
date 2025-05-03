import { Gtk } from 'astal/gtk4';
import { bind } from 'astal';
import { MediaWidgetProps } from '../../bar/modules/Media';
import Mpris from 'gi://AstalMpris';
import { Widget } from 'astal/gtk4';

const Play = ({ player }: MediaWidgetProps) => {
    return Widget.Button({
        cssClasses: ['play-button'],
        onClicked: () => player.play_pause(),
        child: Widget.Image({
            iconName: bind(player, 'playbackStatus').as((status) =>
                status === Mpris.PlaybackStatus.PLAYING
                    ? 'custom-media-pause-symbolic'
                    : 'custom-media-play-symbolic'
            )
        })
    })
};

const Next = ({ player }: MediaWidgetProps) => {
    return Widget.Button({
        cssClasses: ['next-button'],
        onClicked: () => player.next(),
        child: Widget.Image({
            heightRequest: 20,
            widthRequest: 20,
            iconName: "custom-media-skip-next-symbolic"
        })
    })
};

const Previous = ({ player }: MediaWidgetProps) => {
    return Widget.Button({
        cssClasses: ['previous-button'],
        onClicked: () => player.previous(),
        child: Widget.Image({
            iconName: "custom-media-skip-prev-symbolic"
        })
    })
};

/*
const Shuffle = ({ player }: MediaWidgetProps) => {
    return (
        <button
            className={bind(player, 'shuffleStatus').as((status) =>
                status === Mpris.Shuffle.ON
                    ? 'shuffle-button active'
                    : 'shuffle-button'
            )}
            onClick={() => player.shuffle()}
            visible={bind(player, 'shuffleStatus').as(
                (status) => status !== Mpris.Shuffle.UNSUPPORTED
            )}
        >
            <icon icon="custom-media-shuffle-symbolic" />
        </button>
    );
};

const Loop = ({ player }: MediaWidgetProps) => {
    return Widget.Button({
        cssClasses: bind(player, 'loopStatus').as((status) =>
            ['loop-button', status !== Mpris.Loop.NONE
                ? 'active'
                : '']
        ),

        onClick: () => player.loop(),
        visible:
            bind(player, 'loopStatus').as(
                (status) => status !== Mpris.Loop.UNSUPPORTED
            ),
        child: Widget.Image({
            iconName: bind(player, 'loopStatus').as((status) =>
                status === Mpris.Loop.TRACK
                    ? 'custom-media-repeat-song-symbolic'
                    : 'custom-media-repeat-symbolic'
            )
        })
    })
};
*/

export const MediaControls = ({ player }: MediaWidgetProps) => {
    return Widget.Box({
        cssClasses: ['media-controls'],
        hexpand: true,
        halign: Gtk.Align.CENTER,
        children: [
            Previous({ player }),
            Play({ player }),
            Next({ player })
        ]
    })
};
