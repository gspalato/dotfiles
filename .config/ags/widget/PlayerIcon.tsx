import { bind } from 'astal';
import Mpris from 'gi://AstalMpris';
import { Widget, Gtk, App } from 'astal/gtk3';

const media = Mpris.get_default();

type Props = {
    player: Mpris.Player;
    symbolic?: boolean;
    playerIcons?: { [player: string]: string };
    [key: string]: any;
};

export const PlayerIcon = (props: Props) => {
    const { player, playerIcons, symbolic = false, ...rest } = props;

    const iconName = bind(player, 'entry').as((entry) => {
        let name = `${entry}${symbolic ? '-symbolic' : ''}`;
        name = Widget.Icon.lookup_icon(name) ? name : 'emblem-music-symbolic';
        return name;
    });

    return <icon className="player-icon" icon={iconName} />;
};
