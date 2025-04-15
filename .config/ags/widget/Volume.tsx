import { App, Widget } from 'astal/gtk3';
import { Variable, GLib, bind, exec } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import Wp from 'gi://AstalWp';

const audio = Wp.get_default()?.get_audio();

const VolumeIcon = () => {
    const volumeThresholds = [101, 67, 34, 1, 0];

    const setupStack = (stack: Widget.Stack) => {
        if (!audio) return;
        audio.get_default_speaker()?.connect('notify', (speaker) => {
            if (speaker.get_mute()) {
                stack.shown = '0';
                return;
            }

            stack.shown = volumeThresholds
                .find((threshold) => threshold <= speaker.volume * 100)!
                .toString();
        });
    };

    return (
        <box className="barIcon">
            <stack setup={setupStack}>
                <icon name="101" icon="audio-volume-overamplified-symbolic" />
                <icon name="67" icon="audio-volume-high-symbolic" />
                <icon name="34" icon="audio-volume-medium-symbolic" />
                <icon name="1" icon="audio-volume-low-symbolic" />
                <icon name="0" icon="audio-volume-muted-symbolic" />
            </stack>
        </box>
    );
};

export function VolumePercentLabel(props: { reveal: Variable<boolean> }) {
    const { reveal } = props;

    const setup = (revealer: Widget.Revealer) => {
        reveal.subscribe((show) => {
            revealer.revealChild = show;
        });
    };

    return (
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            setup={setup}
        >
            <label
                className="volume-percentage"
                label={bind(audio?.defaultSpeaker, 'volume').as(
                    (p) => `${Math.round(p * 100)}%`
                )}
            />
        </revealer>
    );
}

type Props = {
    icons?: string[];
    muteIcon?: string;
    showIcon?: boolean;
    showPercentage?: boolean;
};

export const Volume = (props: Props) => {
    const {
        showIcon = true,
        icons = ['', '', ''],
        showPercentage = true,
    } = props;

    const wp = Wp.get_default();
    if (!wp) {
        return <></>;
    }

    const isHovering = Variable(false);

    const onHover = () => {
        isHovering.set(true);
    };

    const onHoverLost = () => {
        isHovering.set(false);
    };

    const speaker = Wp.get_default()?.audio.defaultSpeaker!;

    const onScroll = (_: any, e: Astal.ScrollEvent) => {
        if (e.direction === Gdk.ScrollDirection.UP || e.delta_y < 0) {
            speaker.set_volume(
                Math.max(0, Math.min(1, speaker.get_volume() + 0.05))
            );
        } else if (e.direction === Gdk.ScrollDirection.DOWN || e.delta_y > 0) {
            speaker.set_volume(
                Math.max(0, Math.min(1, speaker.get_volume() - 0.05))
            );
        }
    };

    return (
        <eventbox
            className="module-event"
            onHover={onHover}
            onHoverLost={onHoverLost}
            onScroll={onScroll}
        >
            <box visible={!!speaker} className="module volume">
                <VolumeIcon />
                <VolumePercentLabel reveal={isHovering} />
            </box>
        </eventbox>
    );
};
