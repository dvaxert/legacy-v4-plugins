import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root

    property var pluginApi: null

    readonly property var ps: pluginApi?.pluginSettings ?? ({})

    spacing: Style.marginM

    // ── Bar metric ───────────────────────────────────────────────
    NComboBox {
        id: barMetricCombo
        Layout.fillWidth: true
        label: pluginApi?.tr("settings.barMetric")
        description: pluginApi?.tr("settings.barMetricDesc")
        model: [
            { key: "auto",    name: pluginApi?.tr("settings.barMetric-auto")    },
            { key: "session", name: pluginApi?.tr("settings.barMetric-session") },
            { key: "weekly",  name: pluginApi?.tr("settings.barMetric-weekly")  },
            { key: "cost",    name: pluginApi?.tr("settings.barMetric-cost")    }
        ]
        currentKey: ps.barMetric ?? "auto"
    }

    // ── Display mode ─────────────────────────────────────────────
    NToggle {
        id: displayToggle
        Layout.fillWidth: true
        label: pluginApi?.tr("settings.alwaysShow")
        description: pluginApi?.tr("settings.alwaysShowDesc")
        checked: (ps.displayMode ?? "alwaysShow") === "alwaysShow"
    }

    // ── Refresh interval ─────────────────────────────────────────
    NComboBox {
        id: pollCombo
        Layout.fillWidth: true
        label: pluginApi?.tr("settings.pollInterval")
        description: pluginApi?.tr("settings.pollIntervalDesc")
        model: [
            { key: "30000",  name: pluginApi?.tr("settings.poll-30s") },
            { key: "60000",  name: pluginApi?.tr("settings.poll-1m")  },
            { key: "300000", name: pluginApi?.tr("settings.poll-5m")  },
            { key: "900000", name: pluginApi?.tr("settings.poll-15m") }
        ]
        currentKey: String(ps.pollInterval ?? 60000)
    }

    // ── Daily budget ─────────────────────────────────────────────
    NTextInput {
        id: budgetInput
        Layout.fillWidth: true
        label: pluginApi?.tr("settings.dailyBudget")
        description: pluginApi?.tr("settings.dailyBudgetDesc")
        text: String(ps.dailyBudget ?? 0)
    }

    function saveSettings() {
        if (!pluginApi) return;
        const b = parseFloat(budgetInput.text);
        pluginApi.pluginSettings.barMetric    = barMetricCombo.currentKey;
        pluginApi.pluginSettings.displayMode  = displayToggle.checked ? "alwaysShow" : "alwaysHide";
        pluginApi.pluginSettings.pollInterval = parseInt(pollCombo.currentKey, 10) || 60000;
        pluginApi.pluginSettings.dailyBudget  = (Number.isFinite(b) && b >= 0) ? b : 0;
        pluginApi.saveSettings();
    }
}
