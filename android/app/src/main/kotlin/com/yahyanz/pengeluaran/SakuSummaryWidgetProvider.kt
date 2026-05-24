package com.yahyanz.pengeluaran

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class SakuSummaryWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.saku_summary_widget).apply {
                val openApp = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.saku_widget_container, openApp)
                setTextViewText(
                    R.id.saku_widget_balance,
                    widgetData.getString("balance", "Rp 12.000.000"),
                )
                setTextViewText(
                    R.id.saku_widget_expense,
                    widgetData.getString("expense", "Rp 75.000"),
                )
                setTextViewText(
                    R.id.saku_widget_latest,
                    widgetData.getString("latest", "Makanan - 30.000"),
                )
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
