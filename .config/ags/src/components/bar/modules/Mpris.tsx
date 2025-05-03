import { App, Widget } from 'astal/gtk4';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk4';

import AstalMpris from 'gi://AstalMpris?version=0.1';
import { truncateString } from '../../../../utils';
import { PlayerIcon } from '../../shared/PlayerIcon';
import Pango from 'gi://Pango?version=1.0';

type Props = {
    separator?: string;
    maxLength?: number;
    showArtist?: boolean;
};

export const Mpris = (props: Props) => {
    const { separator = ' - ', maxLength, showArtist } = props;

    const mpris = AstalMpris.get_default();

    return bind(mpris, 'players').as((ps) => ps[0] ? Widget.Box({
        cssClasses: ['mpris', 'module', 'space-between-ltr'],
        children: [
            PlayerIcon({ player: ps[0] }),
            Widget.Label({
                ellipsize: Pango.EllipsizeMode.END,
                maxWidthChars: 25,
                label: bind(ps[0], 'metadata').as(() => {
                    const text = `${ps[0].title}${showArtist ? separator : ''
                        }${showArtist ? ps[0].artist : ''}`.trim();

                    return text;
                })
            })
        ]
    }) : <></>);
};
