import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMozEmbed.Browser 1.0

ApplicationWindow {
    id: window

    initialPage: Component {
        Page {
            WebPage {
                width: parent.width
                height: parent.height
                //url: "http://www.google.com/"
                /*onViewInitialized: {
                    console.log("view initialized" + height + width);
                    url = "http://www.google.com/"
                }*/
                /*onLoadedChanged: {
                    console.log("LOADED CHANGED *******************************")
                }*/
            }
        }
    }
}
