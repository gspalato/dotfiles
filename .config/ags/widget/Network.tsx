import { App, Widget } from 'astal/gtk3';
import { Variable, GLib, bind, exec, Binding } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';
import AstalNetwork from 'gi://AstalNetwork';

const network = AstalNetwork.get_default();

export const ConnectionIcon = () => {
    const wifi = bind(network, 'wifi');

    const enumMap = new Map<number, string>([
        [AstalNetwork.Primary.UNKNOWN, 'disconnected'],
        [AstalNetwork.Primary.WIFI, 'wifi'],
        [AstalNetwork.Primary.WIRED, 'wired'],
    ]);

    return new Widget.Stack({
        className: 'connection-icon',
        shown: bind(network, 'primary').as(
            (p) => enumMap.get(p) ?? 'disconnected'
        ),
        children: [
            new Widget.Label({ name: 'wifi', label: '󰤨' }),
            new Widget.Icon({ name: 'wired', icon: 'custom-network-wired-symbolic' }),
            new Widget.Label({ name: 'disconnected', label: '󰤭' })
        ]
    });
};

export function ConnectionLabel(props: { reveal: Variable<boolean> }) {
    const { reveal } = props;

    const setup = (revealer: Widget.Revealer) => {
        reveal.subscribe((show) => {
            revealer.revealChild = network.primary === AstalNetwork.Primary.WIFI ? show : false;
        });
    };

    return new Widget.Revealer({
        transition_type: Gtk.RevealerTransitionType.SLIDE_RIGHT,
        setup: (revealer: Widget.Revealer) => {
            reveal.subscribe((show) => {
                revealer.revealChild = network.primary === AstalNetwork.Primary.WIFI ? show : false;
            });
        },
        child: new Widget.Label({
            className: 'connection-name',
            label: bind(network, 'wifi').as(w => w.ssid)
        })
    });
}

type Props = {
    css?: Binding<string> | string;
}

export const Network = (props: Props) => {
    const { css } = props;

    const visible = bind(network, 'primary').as(p => p !== AstalNetwork.Primary.UNKNOWN);

    const isHovering = Variable(false);

    const onHover = () => {
        isHovering.set(true);
    };

    const onHoverLost = () => {
        isHovering.set(false);
    };

    return new Widget.EventBox({
        className: 'module-event',
        onHover,
        onHoverLost,
        child: new Widget.Box({
            visible,
            className: 'wifi module space-between-sm-rtl',
            css,
            children: [
                ConnectionIcon(),
                ConnectionLabel({ reveal: isHovering })
            ]
        })
    })
}