import { timeout } from 'astal';
import { App, Widget } from 'astal/gtk3';

export function toggleWindow(windowName: string, delay: number = 300) {
    const window = App.get_window(windowName);
    if (window === null) return;
    if (window.is_visible()) {
        (window.get_child() as Widget.Revealer).revealChild = false;
        timeout(delay, () => window.hide());
    } else {
        window.show();
        (window.get_child() as Widget.Revealer).revealChild = true;
    }
}

export function hideWindow(windowName: string, delay: number = 300) {
    const window = App.get_window(windowName);
    if (window === null) return;
    if (window.is_visible()) {
        (window.get_child() as Widget.Revealer).revealChild = false;
        timeout(delay, () => window.hide());
    }
}
