import { Gtk } from 'astal/gtk3';
import { bind } from 'astal';
import { MediaWidgetProps } from './Media';
import Mpris from 'gi://AstalMpris';

const Play = ({ player }: MediaWidgetProps) => {
    return (
        <button className="play-button" onClick={() => player.play_pause()}>
            <icon
                icon={bind(player, 'playbackStatus').as((status) =>
                    status === Mpris.PlaybackStatus.PLAYING
                        ? 'custom-media-pause-symbolic'
                        : 'custom-media-play-symbolic'
                )}
            />
        </button>
    );
};

const Next = ({ player }: MediaWidgetProps) => {
    return (
        <button
            className="next-button"
            onClick={() => player.next()}
            visible={bind(player, 'canGoNext')}
        >
            <icon icon="custom-media-skip-next-symbolic" />
        </button>
    );
};

const Previous = ({ player }: MediaWidgetProps) => {
    return (
        <button
            className="previous-button"
            onClick={() => player.previous()}
            visible={bind(player, 'canGoPrevious')}
        >
            <icon icon="custom-media-skip-prev-symbolic" />
        </button>
    );
};

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
    return (
        <button
            className={bind(player, 'loopStatus').as((status) =>
                status !== Mpris.Loop.NONE
                    ? 'loop-button active'
                    : 'loop-button'
            )}
            onClick={() => player.loop()}
            visible={bind(player, 'loopStatus').as(
                (status) => status !== Mpris.Loop.UNSUPPORTED
            )}
        >
            <icon
                icon={bind(player, 'loopStatus').as((status) =>
                    status === Mpris.Loop.TRACK
                        ? 'custom-media-repeat-song-symbolic'
                        : 'custom-media-repeat-symbolic'
                )}
            />
        </button>
    );
};

export const MediaControls = ({ player }: MediaWidgetProps) => {
    return (
        <box
            className="media-controls"
            hexpand={true}
            halign={Gtk.Align.CENTER}
        >
            <Previous player={player} />
            <Play player={player} />
            <Next player={player} />
        </box>
    );
};
