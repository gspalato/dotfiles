import { timeout } from 'astal';
import { App, Gtk, Widget } from 'astal/gtk4';

export function toggleWindow(windowName: string, delay: number = 300) {
    const window = App.get_window(windowName);
    if (window === null) return;
    if (window.is_visible()) {
        (window.get_child() as Gtk.Revealer).revealChild = false;
        timeout(delay, () => window.hide());
    } else {
        window.show();
        (window.get_child() as Gtk.Revealer).revealChild = true;
    }
}

export function hideWindow(windowName: string, delay: number = 300) {
    const window = App.get_window(windowName);
    if (window === null) return;
    if (window.is_visible()) {
        (window.get_child() as Gtk.Revealer).revealChild = false;
        timeout(delay, () => window.hide());
    }
}
