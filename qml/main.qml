/*
 * Copyright (C) 2014-2015 Leszek Lesner <leszek@zevenos.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) version 3, or any
 * later version accepted by the membership of KDE e.V. (or its
 * successor approved by the membership of KDE e.V.), which shall
 * act as a proxy defined in Section 6 of version 3 of the license.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.1

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0
import "helper/db.js" as DB

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 800
    visible: true
    property string appIcon: "/usr/share/icons/hicolor/86x86/apps/vplayer.png" //TODO: use xdg somehow
    property string appName: "LLs vPlayer"
    property string version: "0.1"
    property alias mainToolbar: mainToolbar

    PlasmaComponents.PageStack {
        id: mainStack
        anchors.fill: parent
    }
    
    statusBar: ToolBar { // for mobile we use toolbar in status bar as it is closer to fingers of user
        visible: mainStack.depth > 1
        Row {
            id: mainToolbar
            height: parent.height
            width: parent.width
            //
            // Navigation
            //
            PlasmaComponents.ToolButton {
                iconName: "draw-arrow-back"
                //text: "Back" // We don't that do we ?
                onClicked: mainStack.pop();
            }
        }
    }
    
    function addHistory(url,title) {
        //console.debug("Adding " + url);
        historyModel.append({"hurl": url, "htitle": title});
    }

    function add2History(url,title) {
        if (historyModel.containsTitle(title) || historyModel.containsUrl(url)) {
            historyModel.removeUrl(url);
        }
        historyModel.append({"hurl": url, "htitle": title});
    }
    
    ListModel {
        id: historyModel
        
        function containsTitle(htitle) {
            for (var i=0; i<count; i++) {
                if (get(i).htitle == htitle)  {
                    return true;
                }
            }
            return false;
        }
        function containsUrl(hurl) {
            for (var i=0; i<count; i++) {
                if (get(i).hurl == hurl)  {
                    return true;
                }
            }
            return false;
        }
        function removeUrl(hurl) {
            for (var i=0; i<count; i++) {
                if (get(i).hurl == hurl)  {
                    remove(i)
                }
            }
            return;
        }
    }    
    
    Component.onCompleted: { 
        // Intitialize DB
        DB.initialize();
        DB.getHistory();
	mainStack.push(Qt.resolvedUrl("mainPage.qml"))
    }

}