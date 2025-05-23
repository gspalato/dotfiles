import { bind, Binding, Variable } from "astal";
import { Astal, Gdk, hook, Widget } from "astal/gtk4";
import type GLib from "gi://GLib";

import Hyprland from 'gi://AstalHyprland?version=0.1';

const hyprland = Hyprland.get_default();

const WorkspaceIndicator = (active: Binding<boolean>) =>
    Widget.Box({
        cssClasses: active.as((active) => ['workspace-indicator', active ? "active" : ""]),
        vexpand: false,
        visible: true,
    });

const maxWorkspaces = 25;

export const Workspaces = (monitor: number) =>
    Widget.Box({
        visible: true,
        cssClasses: ['module'],
        onScroll: (self, dx, dy) => {
            const reverse = false;

            const callback = () => { };

            if (dy < 0) {
                if (reverse)
                    hyprland.message_async("dispatch workspace -1", callback);
                else {
                    const mon = hyprland.get_monitor(monitor);
                    if (mon && mon.activeWorkspace.id >= maxWorkspaces) return;
                    hyprland.message_async("dispatch workspace +1", callback);
                }
            } else if (dy > 0) {
                if (reverse) {
                    const mon = hyprland.get_monitor(monitor);
                    if (mon && mon.activeWorkspace.id >= maxWorkspaces) return;
                    hyprland.message_async("dispatch workspace +1", callback);
                } else {
                    hyprland.message_async("dispatch workspace -1", callback);
                }
            }
        },
        child: Widget.Box({
            visible: true,
            cssClasses: ["workspaces"],
            setup(self) {
                const calc_workspace_count = () => {
                    return Math.max(
                        5,
                        Math.min(
                            maxWorkspaces,
                            Math.max(1, ...hyprland.workspaces.map((ws) => ws.id)),
                        ),
                    );
                };

                const shown_active_workspace = Variable(1);
                let target_active_workspace = 1;
                let workspace_ticker: null | GLib.Source = null;

                const smooth_active_workspace = Variable.derive(
                    [
                        bind(hyprland.get_monitor(monitor), "activeWorkspace").as(w => w.id),
                        bind(shown_active_workspace),
                    ],
                    (real_active, shown_active) => {
                        target_active_workspace = real_active;

                        const step_amount = Math.abs(shown_active - real_active);
                        if (step_amount === 0) return shown_active;

                        if (workspace_ticker !== null) clearInterval(workspace_ticker);

                        workspace_ticker = setInterval(() => {
                            const current = shown_active_workspace.get();
                            if (target_active_workspace > current)
                                shown_active_workspace.set(current + 1);
                            else if (target_active_workspace < current)
                                shown_active_workspace.set(current - 1);
                            else {
                                clearInterval(workspace_ticker!);
                                workspace_ticker = null;
                            }
                        }, (50 + Math.min(Math.max(step_amount - 1, 0), 2) * 50) / step_amount);

                        return target_active_workspace > shown_active ? shown_active + 1 :
                            target_active_workspace < shown_active ? shown_active - 1 :
                                shown_active;
                    },
                );

                // Inicializa os indicadores com base nos workspaces já existentes
                const initial_count = calc_workspace_count();
                for (let i = 0; i < initial_count; i++) {
                    self.append(
                        WorkspaceIndicator(bind(smooth_active_workspace).as((active) => active === i + 1)),
                    );
                }

                hook(
                    self,
                    hyprland,
                    "workspace-added",
                    (self) => {
                        const old_count = self.children.length;
                        const new_count = calc_workspace_count();
                        for (let i = old_count; i < new_count; i++) {
                            self.append(
                                WorkspaceIndicator(bind(smooth_active_workspace).as((active) => active === i + 1)),
                            );
                        }
                    },
                );

                hook(
                    self,
                    hyprland,
                    "workspace-removed",
                    (self) => {
                        const old_count = self.children.length;
                        const new_count = calc_workspace_count();
                        for (let i = old_count; i > new_count; i--) {
                            self.remove(self.children[i - 1]);
                        }
                    },
                );
            },
        }),
    });
