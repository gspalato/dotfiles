import { App } from 'astal/gtk3';
import { Variable, GLib, bind } from 'astal';
import { Astal, Gtk, Gdk } from 'astal/gtk3';

type Props = {
    format?: string;
};

export const Time = (props: Props) => {
    const { format = '%H:%M' } = props;

    const time = Variable<string>('').poll(
        1000,
        () => GLib.DateTime.new_now_local().format(format)!
    );

    return (
        <label
            className="time module"
            onDestroy={() => time.drop()}
            label={time()}
        />
    );
};
