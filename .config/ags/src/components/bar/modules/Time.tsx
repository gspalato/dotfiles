import { App, Widget } from 'astal/gtk4';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk4';
import { toggleWindow } from '../../../utils/window';

type Props = {
    format?: string;
};

export const Time = (props: Props) => {
    const { format = '%H:%M' } = props;

    const time = Variable<string>('').poll(
        1000,
        () => GLib.DateTime.new_now_local().format(format)!
    );

    return Widget.Button({
        onClicked: () => toggleWindow('dashboard-menu'),
        cssClasses: ['time', 'module'],
        onDestroy: () => time.drop(),
        valign: Gtk.Align.CENTER,
        halign: Gtk.Align.CENTER,
        label: time(),
    })
};
