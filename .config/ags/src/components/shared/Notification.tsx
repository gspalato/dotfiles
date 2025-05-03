import { Gtk, Widget } from 'astal/gtk4';
import { Picture } from './Picture';
import AstalNotifd from 'gi://AstalNotifd?version=0.1';
import { createScaledTexture } from '@utils/images';
import Pango from 'gi://Pango';
import { bind, GLib, Variable } from 'astal';

import Adw from 'gi://Adw';

const getFriendlyNotifTimeString = (time: number) => {
    const messageTime = GLib.DateTime.new_from_unix_local(time);
    const oneMinuteAgo = GLib.DateTime.new_now_local().add_seconds(-60)!;

    if (messageTime.compare(oneMinuteAgo) > 0) return 'Now';
    else if (
        messageTime.get_day_of_year() ==
        GLib.DateTime.new_now_local().get_day_of_year()
    )
        return messageTime.format('%H:%M');
    else if (
        messageTime.get_day_of_year() ==
        GLib.DateTime.new_now_local().get_day_of_year() - 1
    )
        return 'Yesterday';
    else return messageTime.format('%d %b');
};

type Props = {
    notification: AstalNotifd.Notification;
    onDismiss: (self: Gtk.Revealer) => void;
};

export const Notification = (props: Props) => {
    const { notification, onDismiss } = props;

    const isActionExpanded = Variable(false);
    const isBodyExpanded = Variable(false);

    const path = notification.image;

    const hasIcon = path !== null;
    const texture = createScaledTexture(75, 75, path);

    const hasTitle =
        notification.summary !== '' && notification.summary !== null;

    const hasBody = notification.body !== '' && notification.body !== null;

    const body = notification.body;
    const bodyPreview = body.length > 30 ? body.slice(0, 27) + '...' : body;
    const needsBodyExpansion = body !== bodyPreview;

    const notificationBodyPreview = Widget.Revealer({
        transitionType: Gtk.RevealerTransitionType.SLIDE_DOWN,
        transitionDuration: 200,
        revealChild: bind(isBodyExpanded).as((v) => !v),
        child: Widget.Box({
            widthRequest: 125,
            child: Widget.Label({
                xalign: 0,
                //useMarkup: true,
                justify: Gtk.Justification.LEFT,
                maxWidthChars: 20,
                wrap: true,
                wrapMode: Gtk.WrapMode.WORD_CHAR,
                naturalWrapMode: Gtk.NaturalWrapMode.WORD,
                label: bodyPreview,
            }),
        }),
    });

    const notificationBodyExpanded = Widget.Revealer({
        transitionType: Gtk.RevealerTransitionType.SLIDE_UP,
        transitionDuration: 200,
        revealChild: bind(isBodyExpanded).as((v) => v),
        child: Widget.Box({
            widthRequest: 125,
            vertical: true,
            spacing: 10,
            children: [
                Widget.Label({
                    xalign: 0,
                    //useMarkup: true,
                    justify: Gtk.Justification.LEFT,
                    maxWidthChars: 20,
                    wrap: true,
                    singleLineMode: false,
                    naturalWrapMode: Gtk.NaturalWrapMode.WORD,
                    wrapMode: Pango.WrapMode.WORD_CHAR,
                    label: body,
                }),
            ],
        }),
    });

    const actionButtons = Widget.Revealer({
        revealChild: bind(isActionExpanded).as((v) => v),
        child: Widget.Box({
            spacing: 10,
            children: [
                Widget.Button({
                    hexpand: true,
                    cssClasses: ['notification-action-button'],
                    onClicked: () => notification.dismiss(),
                    child: Widget.Label({
                        label: 'Close',
                    }),
                }),
                ...notification.actions.map((action) =>
                    Widget.Button({
                        hexpand: true,
                        cssClasses: ['notification-action-button'],
                        onClicked: () => notification.invoke(action.id),
                        child: Widget.Label({
                            label: action.label,
                        }),
                    })
                ),
            ],
        }),
    });

    const widget = Widget.Revealer({
        name: String(notification.id),
        revealChild: false,
        child: Widget.Button({
            widthRequest: 300,
            onButtonPressed(self, state) {
                // Left click
                if (state.get_button() === 1) {
                    if (needsBodyExpansion)
                        isBodyExpanded.set(!isBodyExpanded.get());
                }

                // Right click to dismiss
                if (state.get_button() === 3) {
                    onDismiss(self.parent as Gtk.Revealer);
                }
            },
            child: new Adw.Clamp({
                maximumSize: 300,
                child: Widget.Box({
                    cssClasses: ['notification'],
                    hexpand: true,
                    vertical: true,
                    spacing: bind(isActionExpanded).as((v) => (v ? 15 : 0)),
                    children: [
                        Widget.Box({
                            spacing: hasIcon ? 15 : 0,
                            hexpand: true,
                            children: [
                                hasIcon
                                    ? Picture({
                                          cssClasses: ['notification-icon'],
                                          heightRequest: 75,
                                          widthRequest: 75,
                                          paintable: texture,
                                      })
                                    : Widget.Box({}),
                                Widget.Box({
                                    cssClasses: ['notification-info'],
                                    spacing: hasTitle && hasBody ? 5 : 0,
                                    vertical: true,
                                    valign: Gtk.Align.CENTER,
                                    hexpand: true,
                                    children: [
                                        Widget.Box({
                                            spacing: 10,
                                            hexpand: true,
                                            halign: Gtk.Align.START,
                                            valign: Gtk.Align.CENTER,
                                            children: [
                                                hasTitle
                                                    ? Widget.Label({
                                                          xalign: 0,
                                                          valign: Gtk.Align
                                                              .CENTER,
                                                          halign: Gtk.Align
                                                              .START,
                                                          hexpand: true,
                                                          wrap: false,
                                                          cssClasses: [
                                                              'notification-title',
                                                          ],
                                                          label: notification.summary,
                                                          ellipsize:
                                                              Pango
                                                                  .EllipsizeMode
                                                                  .END,
                                                      })
                                                    : Widget.Box(),
                                                //Widget.Label({
                                                //    valign: Gtk.Align.CENTER,
                                                //    halign: Gtk.Align.END,
                                                //    cssClasses: [
                                                //        'notification-datetime',
                                                //    ],
                                                //    label: getFriendlyNotifTimeString(
                                                //        notification.time
                                                //    )!,
                                                //}),
                                            ],
                                        }),
                                        Widget.Box({
                                            spacing: 0,
                                            vertical: true,
                                            children: [
                                                notificationBodyPreview,
                                                notificationBodyExpanded,
                                            ],
                                        }),
                                    ],
                                }),
                            ],
                        }),
                        //actionButtons,
                    ],
                }),
            }),
        }),
    });

    return widget;
};
