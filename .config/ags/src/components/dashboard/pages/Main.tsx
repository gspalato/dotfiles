import { App, Astal, Gdk, Gtk, hook, Widget } from 'astal/gtk4';
import { Avatar } from '../../shared/Avatar';
import { bind, exec, GLib, Variable } from 'astal';
import { VolumeIcon } from '../../shared/VolumeIcon';

import Tray from 'gi://AstalTray';
import Wp from 'gi://AstalWp';
import Notifd, { AstalNotifd } from 'gi://AstalNotifd?version=0.1';
import { Picture } from '@components/shared/Picture';
import { Notification } from '@components/shared/Notification';
import { ScrolledWindow } from '@components/shared/ScrolledWindow';
import Adw from 'gi://Adw?version=1';

const tray = Tray.get_default();
const audio = Wp.get_default()?.get_audio();
const notifd = Notifd.get_default();

const SlidersSection = () => {
    const sliders = {
        volume: {
            icon: VolumeIcon(),
            value: bind(audio?.defaultSpeaker!, 'volume').as(Number),
            set: (vol: number) => audio?.defaultSpeaker.set_volume(vol),
            min: 0,
            max: 1,
        },
        //brightness: {
        //    icon: Widget.Image({ iconName: 'custom-brightness-full-symbolic' }),
        //    value: 0, //bind(brightness).as(Number),
        //    set: (brightness: number) => {},
        //    //exec(['brightnessctl', 's', `${brightness}`]),
        //    min: 10,
        //    max: 100,
        //},
    };

    return Widget.Box({
        vertical: true,
        hexpand: true,
        valign: Gtk.Align.CENTER,
        cssClasses: ['dashboard-sliders'],
        spacing: 15,
        children: Object.values(sliders).map((s) =>
            Widget.Box({
                cssClasses: ['section'],
                hexpand: true,
                child: Widget.Box({
                    valign: Gtk.Align.CENTER,
                    spacing: 10,
                    children: [
                        s.icon,
                        Widget.Slider({
                            cssClasses: ['slider'],
                            hexpand: true,
                            visible: true,
                            value: s.value,
                            min: s.min,
                            max: s.max,
                            onChangeValue: (self) => {
                                s.set(self.value);
                            },
                        }),
                    ],
                }),
            })
        ),
    });
};

const TraySection = () => {
    return Widget.Box({
        hexpand: true,
        cssClasses: ['dashboard-tray', 'section'],
        spacing: 10,
        children: [
            Widget.Image({
                halign: Gtk.Align.START,
                iconName: 'custom-ellipsis-symbolic',
            }),
            Widget.Box({
                hexpand: true,
                halign: Gtk.Align.END,
                spacing: 5,
                children: bind(tray, 'items').as((items) =>
                    items.map((i) =>
                        Widget.Button({
                            iconName: i.iconName,
                            onClicked: (self) =>
                                i.activate(
                                    self.get_bounds()[1],
                                    self.get_bounds()[2]
                                ),
                        })
                    )
                ),
            }),
        ],
    });
};

const NotificationSection = () => {
    const listedNotificationCount = Variable(0);

    const notificationList = Widget.Box({
        cssClasses: ['notifications-list'],
        vexpand: true,
        hexpand: true,
        vertical: true,
        spacing: 10,
        children: [],
        widthRequest: 380,
    });

    // Hook into notifd to handle new notifications.
    const handleNewNotification = (id: number) => {
        const n = notifd.get_notification(id);
        print('notified id ', id);

        // Handle notification add.
        const newNotification = Notification({
            notification: n,
            onDismiss(self) {
                n.dismiss();
                handleDismissNotification(self);
            },
        });

        notificationList.prepend(newNotification);
        newNotification.revealChild = true;

        listedNotificationCount.set(listedNotificationCount.get() + 1);
    };

    const handleDismissNotification = (obj: Gtk.Revealer) => {
        obj.revealChild = false;

        // Remove after animation completes
        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 300, () => {
            notificationList.remove(obj);
            listedNotificationCount.set(listedNotificationCount.get() - 1);

            return GLib.SOURCE_REMOVE;
        });
    };

    notifd.connect('notified', (_, id) => {
        handleNewNotification(id);
        listedNotificationCount.set(listedNotificationCount.get() + 1);
    });

    // Load already existing notifications.
    notifd.notifications.map((n) => {
        handleNewNotification(n.id);
        listedNotificationCount.set(listedNotificationCount.get() + 1);
    });

    return Widget.Box({
        hexpand: true,
        cssClasses: ['dashboard-notifications', 'section'],
        spacing: 10,
        vertical: true,
        children: [
            Widget.Box({
                spacing: 5,
                children: [
                    Widget.Image({
                        iconName: 'custom-notifications-symbolic',
                    }),
                    Widget.Label({
                        hexpand: true,
                        label: 'Notifications',
                        halign: Gtk.Align.START,
                    }),
                ],
            }),
            /*
            bind(listedNotificationCount).as((c) => {
                return Widget.Box({
                    children: [
                        new Gtk.ScrolledWindow({
                            visible: c > 0,
                            minContentWidth: 380,
                            maxContentHeight: 5 * (105 + 10) - 10,
                            propagateNaturalWidth: true,
                            propagateNaturalHeight: true,
                            child: notificationList,
                        }),
                        Widget.Label({
                            visible: c == 0,
                            cssClasses: ['empty-notification-label'],
                            vexpand: true,
                            label: 'No notifications',
                        }),
                    ],
                });
            }),
            */
            new Gtk.ScrolledWindow({
                minContentWidth: 380,
                maxContentHeight: 5 * (105 + 10) - 10,
                propagateNaturalWidth: true,
                propagateNaturalHeight: true,
                child: notificationList,
            }),
        ],
    });
};

const Dashboard = () => {
    // State
    const username = exec("bash -c 'echo $USER'");

    const confirmationDialogText = Variable('');
    const isConfirmationDialogOpen = Variable(false);
    let confirmationDialogAction = () => {};

    const resetConfirmationDialogState = () => {
        confirmationDialogAction = () => {};
        confirmationDialogText.set('');
        isConfirmationDialogOpen.set(false);
    };

    const ConfirmationDialog = Widget.Revealer({
        transitionDuration: 200,
        transitionType: Gtk.RevealerTransitionType.SLIDE_DOWN,
        revealChild: bind(isConfirmationDialogOpen),
        child: Widget.Box({
            cssClasses: ['dashboard-confirmation-dialog', 'section'],
            child: Widget.Box({
                vertical: true,
                spacing: 5,
                children: [
                    Widget.Label({
                        cssClasses: ['dashboard-confirmation-dialog-label'],
                        halign: Gtk.Align.CENTER,
                        label: bind(confirmationDialogText),
                    }),
                    Widget.Box({
                        cssClasses: ['dashboard-confirmation-dialog-buttons'],
                        hexpand: true,
                        spacing: 5,
                        children: [
                            Widget.Button({
                                hexpand: true,
                                label: 'Yes',
                                onClicked: () => {
                                    resetConfirmationDialogState();
                                    confirmationDialogAction();
                                },
                            }),
                            Widget.Button({
                                hexpand: true,
                                label: 'No',
                                onClicked: () => resetConfirmationDialogState(),
                            }),
                        ],
                    }),
                ],
            }),
        }),
    });

    const HeaderButton = (icon: string, action: () => void) => {
        return Widget.Button({
            onClicked: action,
            cssClasses: ['dashboard-header-button'],
            halign: Gtk.Align.CENTER,
            valign: Gtk.Align.CENTER,
            child: Widget.Image({
                halign: Gtk.Align.CENTER,
                valign: Gtk.Align.CENTER,
                iconName: icon,
            }),
        });
    };

    const Header = Widget.Box({
        cssClasses: ['dashboard-main-header'],
        vertical: true,
        hexpand: true,
        spacing: bind(isConfirmationDialogOpen).as((v) => (v ? 15 : 0)),
        children: [
            Widget.Box({
                spacing: 20,
                children: [
                    Widget.Box({
                        spacing: 10,
                        hexpand: true,
                        halign: Gtk.Align.START,
                        children: [
                            Avatar({ cssClasses: ['apply-border'] }),
                            Widget.Label({
                                cssClasses: ['dashboard-main-header-greeting'],
                                maxWidthChars: 25,
                                label: `Hello, ${username}!`,
                            }),
                        ],
                    }),
                    Widget.Box({
                        cssClasses: ['dashboard-main-header-buttons'],
                        spacing: 5,
                        halign: Gtk.Align.END,
                        children: [
                            HeaderButton('custom-shutdown-symbolic', () => {
                                confirmationDialogText.set(
                                    'Are you sure you want to shutdown?'
                                );
                                confirmationDialogAction = () =>
                                    exec("bash -c 'shutdown -P now'");
                                isConfirmationDialogOpen.set(
                                    !isConfirmationDialogOpen.get()
                                );
                            }),
                        ],
                    }),
                ],
            }),
            ConfirmationDialog,
        ],
    });

    return Widget.Box({
        name: 'dashboard-main',
        cssClasses: ['dashboard-main'],
        spacing: 15,
        vertical: true,
        children: [
            Header,
            SlidersSection(),
            TraySection(),
            NotificationSection(),
        ],
    });
};

export default Dashboard;
