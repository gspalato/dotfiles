import { App, Widget } from 'astal/gtk4';
import { Variable, GLib, bind, exec, Binding } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk4';
import AstalNetwork from 'gi://AstalNetwork';

const network = AstalNetwork.get_default();

export const ConnectionIcon = () => {
    const wifi = bind(network, 'wifi');

    const enumMap = new Map<number, string>([
        [AstalNetwork.Primary.UNKNOWN, 'disconnected'],
        [AstalNetwork.Primary.WIFI, 'wifi'],
        [AstalNetwork.Primary.WIRED, 'wired'],
    ]);

    return Widget.Stack({
        cssClasses: ['connection-icon'],
        visibleChildName: bind(network, 'primary').as(
            (p) => enumMap.get(p) ?? 'disconnected'
        ),
        /* @ts-ignore */
        children: [
            Widget.Label({ name: 'wifi', label: '󰤨' }),
            Widget.Image({
                name: 'wired',
                iconName: 'custom-network-wired-symbolic',
            }),
            Widget.Label({ name: 'disconnected', label: '󰤭' }),
        ],
    });
};

export function ConnectionLabel(props: { reveal: Variable<boolean> }) {
    const { reveal } = props;

    return Widget.Revealer({
        transition_type: Gtk.RevealerTransitionType.SLIDE_RIGHT,
        setup: (revealer: Gtk.Revealer) => {
            reveal.subscribe((show) => {
                revealer.revealChild =
                    network.primary === AstalNetwork.Primary.WIFI
                        ? show
                        : false;
            });
        },
        child: Widget.Label({
            cssClasses: ['connection-name'],
            label: bind(network, 'wifi').as((w) => w?.ssid || ''),
        }),
    });
}

export const Network = () => {
    const visible = bind(network, 'primary').as(
        (p) => p !== AstalNetwork.Primary.UNKNOWN
    );

    const isHovering = Variable(false);

    const onHoverEnter = () => {
        isHovering.set(true);
    };

    const onHoverLeave = () => {
        isHovering.set(false);
    };

    return Widget.Box({
        onHoverEnter,
        onHoverLeave,
        visible,
        cssClasses: ['wifi', 'module', 'space-between-sm-rtl'],
        children: [ConnectionIcon(), ConnectionLabel({ reveal: isHovering })],
    });
};
