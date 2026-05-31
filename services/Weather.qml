pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick

import Quickshell

import qs.modules.common

Singleton {
    id: root
    property int interval: Config.options.services.weather.interval
    property var xhr: null
    property string latitude: Config.options.services.geoLocation.latitude
    property string longitude: Config.options.services.geoLocation.longitude
    property string temperature: "0"
    property int weatherCode: 0
    property bool isDay: true
    property string icon: getIcon(weatherCode)
    property var dailyForecast: dailyFetch.time.map((day, index) => {
        return {
            weatherCode: dailyFetch.weather_code[index],
            temperature_2m_max: dailyFetch.temperature_2m_max[index].toFixed(1),
            temperature_2m_min: dailyFetch.temperature_2m_min[index].toFixed(1)
        };
    }).filter((item, index) => index < 4)
    property var dailyFetch: []

    function getWeather() {
        if (root.xhr === null) {
            root.xhr = new XMLHttpRequest();
        }
        root.xhr.open("GET", `https://api.open-meteo.com/v1/forecast?latitude=${root.latitude}&longitude=${root.longitude}&daily=weather_code,temperature_2m_max,temperature_2m_min&current=temperature_2m,weather_code,is_day&timezone=auto`);
        root.xhr.setRequestHeader("Content-Type", "application/json");
        root.xhr.onreadystatechange = function () {
            if (root.xhr.readyState === XMLHttpRequest.DONE) {
                let json = JSON.parse(root.xhr.responseText);
                root.temperature = json.current.temperature_2m;
                root.weatherCode = json.current.weather_code;
                root.isDay = json.current.is_day;
                root.dailyFetch = json.daily;
            }
        };
        root.xhr.send();
    }
    Timer {
        id: weatherTimer
        running: true
        interval: root.interval
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.getWeather();
        }
    }

    function getIcon(code) {
        switch (code) {
        case 0:
            return root.isDay ? "sun" : "moon-star";
            break;
        case 1:
            return "cloud";
            break;
        case 2:
            return "cloudy";
            break;
        case 3:
            return "cloudy";
            break;
        case 45:
            return "cloud-fog";
            break;
        case 48:
            return "cloud-fog";
            break;
        case 51:
            return "cloud-drizzle";
            break;
        case 53:
            return "cloud-drizzle";
            break;
        case 55:
            return "cloud-drizzle";
            break;
        case 56:
            return "cloud-drizzle";
            break;
        case 57:
            return "cloud-drizzle";
            break;
        case 61:
            return "cloud-rain";
            break;
        case 63:
            return "cloud-rain";
            break;
        case 65:
            return "cloud-rain";
            break;
        case 66:
            return "cloud-rain";
            break;
        case 67:
            return "cloud-rain";
            break;
        case 71:
            return "cloud-snow";
            break;
        case 73:
            return "cloud-snow";
            break;
        case 75:
            return "cloud-snow";
            break;
        case 77:
            return "snowflake";
            break;
        case 80:
            return "cloud-rain";
            break;
        case 81:
            return "cloud-rain";
            break;
        case 82:
            return "cloud-rain";
            break;
        case 85:
            return "cloud-snow";
            break;
        case 86:
            return "cloud-snow";
            break;
        case 95:
            return "zap";
            break;
        case 96:
            return "zap";
            break;
        }
    }
}
