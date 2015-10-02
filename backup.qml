import QtQuick 2.0

Rectangle {
    width: 100
    height: 62

// No platform style alert
    var alertComponent = Qt.createComponent("components/PromptPopup.qml")
    var alertDialog = alertComponent.createObject(webView.chrome,
                                                        {
                                                            "text": data.text,
                                                            "showCancel": false
                                                        })
    alertDialog.show()

// No platform style confirm
    var confirmComponent = Qt.createComponent("components/PromptPopup.qml")
    var confirmDialog = confirmComponent.createObject(webView.chrome,
                                               {
                                                   "text": data.text
                                               })
    confirmDialog.show()



}

