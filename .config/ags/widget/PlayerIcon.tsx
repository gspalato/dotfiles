import { bind } from 'astal';
import Mpris from 'gi://AstalMpris';
import { Widget, Gtk, App } from 'astal/gtk3';

const media = Mpris.get_default();

type Props = {
    player: Mpris.Player;
    symbolic?: boolean;
    playerIcons?: { [player: string]: string };
    showOnIconlessPlayer?: boolean;
    [key: string]: any;
};

export const PlayerIcon = (props: Props) => {
    const {
        player,
        playerIcons,
        showOnIconlessPlayer = false,
        symbolic = false,
        ...rest
    } = props;

    const defaultIconName = 'emblem-music-symbolic';

    const iconName = bind(player, 'entry').as((entry) => {
        let name = `${entry}${symbolic ? '-symbolic' : ''}`;
        name = Widget.Icon.lookup_icon(name) ? name : defaultIconName;
        return name;
    });

    return new Widget.Icon({
        className: 'player-icon',
        icon: iconName,
        ...rest
    });
};
