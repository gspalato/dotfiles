import { App } from 'astal/gtk3';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

import Wp from 'gi://AstalWp';

type Props = {
    icons?: string[];
    muteIcon?: string;
    showIcon?: boolean;
    showPercentage?: boolean;
};

export const Volume = (props: Props) => {
    const {
        showIcon = true,
        icons = [' ', ' ', ' '],
        showPercentage = true,
    } = props;

    const wp = Wp.get_default();
    if (!wp) {
        return <></>;
    }

    const speaker = Wp.get_default()?.audio.defaultSpeaker!;
    const text = bind(speaker, 'volume').as((v) => {
        const index = Math.min(icons.length - 1, Math.floor(v * icons.length));

        const icon = icons[index];

        return `${showIcon ? icon : ''}${
            showPercentage ? `${Math.round(v * 100)}%` : ''
        }`;
    });

    const onScroll = (_, e: Astal.ScrollEvent) => {
        print;
        if (e.direction === Gdk.ScrollDirection.UP) {
            speaker.set_volume(speaker.volume + 1);
        } else if (e.direction === Gdk.ScrollDirection.DOWN) {
            speaker.set_volume(speaker.volume - 1);
        }
    };

    return (
        <box visible={!!speaker} className="volume module">
            <label label={text} />
        </box>
    );
};
