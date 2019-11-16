import QtQuick 2.8
import QtQuick.Window 2.2

import "blackjack_model.js" as M

Window {
    id: window
    visible: true
    width: 1000
    height: 680
    color: "forestgreen"
    property var model: new M.Model()
    property int currentPlayerIndex : 0
    property int currentDealerIndex : 0
    property int sum : 0
    property int dealerSum : 0
    property string winnerText : ""
    title: qsTr("Blackjack")

    function update() {
        var mdl = model
        model = new M.Model()
        model = mdl
    }

    function showGameOver() {
        if (window.model.gameOver() === 1)
            winnerText = "You won!"
        else
            winnerText = "You lost :("

        gameOver.state = "opaque"
        gameOverAnimation.start()
        buttonRepeater.itemAt(0).state = "disactive"
        buttonRepeater.itemAt(1).state = "disactive"
    }

    function hitClicked() {
        var elem = playerRow.itemAt(currentPlayerIndex)
        elem.x = currentPlayerIndex*60 + 150
        window.model.takeOne(true, currentPlayerIndex)
        window.currentPlayerIndex += 1

        if (window.sum >= 21)
            showGameOver()

        if (window.currentPlayerIndex == 10)
            window.standClicked()
    }

    function dealerHits() {
        var elem = dealerRow.itemAt(currentDealerIndex)
        elem.x = currentDealerIndex*60 + 150
        window.currentDealerIndex += 1
    }

    function standClicked() {
        var hitsNumber = window.model.dealerPlays()
        for (var i = 0; i < hitsNumber; ++i)
            dealerHits()

        showGameOver()
    }

    Text {
        id: title
        width: 150
        height: 50
        color: "navy"
        anchors {
            horizontalCenter : parent.horizontalCenter
            top : parent.top
            topMargin : parent.height/30
        }
        text: "Blackjack"
        antialiasing: true
        rotation: 2
        fontSizeMode: Text.VerticalFit
        font.pixelSize: 40
    }

    Text {
        id: gameOver
        color: "#d38bd1"
        state: "transparent"

        anchors {
            horizontalCenter : parent.horizontalCenter
            bottom : parent.bottom
            bottomMargin: parent.height/4
        }
        text: winnerText
        antialiasing: true
        rotation: 2
        fontSizeMode: Text.VerticalFit
        font.pixelSize: 40
        states: [
            State {
                name: "transparent"
                PropertyChanges { target: gameOver; opacity: 0.0 }
            },

            State {
                name: "opaque"
                PropertyChanges { target: gameOver; opacity: 1.0}
            }
        ]

        transitions: [
            Transition {
                from: "transparent"
                to: "opaque"
                NumberAnimation { properties: "opacity"; duration: 2000}
            },
            Transition {
                from: "opaque"
                to: "transparent"
                NumberAnimation { target: gameOver; duration: 2000}
            }
        ]
    }

    SequentialAnimation {
           id: gameOverAnimation
           running: false
           loops: Animation.Infinite
           ColorAnimation { target: gameOver; property: "color"; to: "#b380ff"; duration: 200}
           ColorAnimation { target: gameOver; property: "color"; to: "#ff33ff"; duration: 200}
           ColorAnimation { target: gameOver; property: "color"; to: "#ff884d"; duration: 200}
           ColorAnimation { target: gameOver; property: "color"; to: "#99ff66"; duration: 200}
           ColorAnimation { target: gameOver; property: "color"; to: "#4dd2ff"; duration: 200}
       }

    Column {
        id: buttonColumn
        spacing : 30
        y: window.height - 200
        Repeater {
            id: buttonRepeater
            model: 2 /*[
            {'color': "red", 'text' : "HIT", 'onClicked' : hitClicked()},
            {'color': "blue", 'text' : "STAND", 'onClicked' : standClicked()}
            ]*/

            Rectangle {
                id: hitRectangle
                color : index == 0 ? "red" : "blue"
                radius: 4
                state: "active"

                x: 30
                height : 50
                width: height*2

                Text {
                    anchors.centerIn: hitRectangle
                    text: index == 0 ? "HIT" : "STAND"
                    font.pixelSize: 26
                    color: "white"
                }

                MouseArea {
                    id: hitMouseArea
                    focus:true
                    anchors.fill : parent
                    onPressed: color = (index == 0 ? "darkred" : "darkblue")
                    onReleased: color = (index == 0 ? "red" : "blue")
                    onClicked: {
                       index == 0 ? hitClicked() : standClicked()
                    }
                }

                states: [
                    State {
                        name: "active"
                        PropertyChanges {target: hitRectangle; color: (index == 0 ? "red" : "blue"); enabled: true}
                    },
                    State {
                        name: "disactive"
                        PropertyChanges {target: hitRectangle; color: (index == 0 ? "darkred" : "darkblue"); enabled: false}
                    }
                ]

                transitions: [
                    Transition {
                        from: "active"
                        to: "disactive"
                        SmoothedAnimation { properties: "color"; easing.type: "OutInBack"; duration: 2000}
                    }
                ]
            }
        }
    }

    /*MouseArea {
        id: startMouseArea
        Rectangle {
            id: startRectangle
            color : "yellow"
            radius: 4
            anchors.fill : parent
            Text {
                anchors.centerIn: startRectangle
                text: "START"
                font.pixelSize: 20
                color: "black"
            }
        }
        x: 30
        y: window.height - 3*(height + 20)
        height : 50
        width: height*2

        focus:true
        onClicked: {
            currentPlayerIndex = 0
            currentDealerIndex = 0
            sum = 0
            dealerSum = 0
            winnerText = undefined
            gameOver.state = "transparent"
            window.model = new M.Model()
            window.model.shuffle()
            window.hitClicked()
            window.hitClicked()
                console.log("dealer start" + window.model.getDealerSum())
            window.model.takeOne(false, currentDealerIndex + 11)
            window.dealerHits()
            dealerSum = window.model.getDealerSum()
                console.log("dealer after start" + window.model.getDealerSum())
            window.update()
        }
    }*/

    Text {
        id: dealerInfo
        text:  "DEALER SUM: " + window.dealerSum + "\n\nPLAYER SUM: " + window.sum
        font.pixelSize: 30
        color: "gold"
        y: parent.height/3
        anchors {
            right: parent.right
            rightMargin: 30
        }
    }

    Repeater {
       id: playerRow
       x: 30
       y: 40
       width: 650
       height: 500
       model: 11

       Rectangle {
           id: playerCard
           readonly property int value: window.model.getCard(index)  //playerRow.outerIndex === 0 ? window.model.getCard(index+11) : window.model.getCard(index)

           x: parent.x + 30
           y: parent.y + 260
           width: 100
           height: width * 1.5
           radius: 8

           Image {
               id: cardImage
               anchors.fill: parent
               source: window.model.getCardPicture(index)
           }

           Behavior on x {
               ParallelAnimation {

                   PropertyAnimation {
                       duration: 600
                       easing.type: Easing.InOutBack
                   }

                   SequentialAnimation {
                       PauseAnimation {
                           duration: 200
                       }

                       RotationAnimation {
                           target: playerCard
                           direction: RotationAnimation.Clockwise
                           to: rotation + 360
                           duration: 400
                       }
                   }

                   NumberAnimation {
                       target: playerCard
                       property: "x"
                       duration: 600
                       easing.type: Easing.InOutQuad
                   }
               }
           }
       }
   }

    Rectangle {
        id: playerDeck

        x: parent.x + 29
        y: parent.y + 259
        width: 102
        height: width * 1.5
        radius: 8
        border {
            color : "white"
            width : 3
        }

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#a42489"
            }
            GradientStop {
                position: 1
                color: "#641449"
            }
        }
    }

    Repeater {
        id: dealerRow
        x: playerRow.x
        y: playerRow.y + 100
        width: playerRow.width
        height: playerRow.height

        model: 11

        Rectangle {
            id: dealerCard
            property int dealerIndex : index + 11
            readonly property int value: window.model.getCard(dealerIndex)

            x: parent.x + 30
            y: parent.y + 100
            width: 100
            height: width * 1.5
            radius: 8

            Image {
                id: dealerCardImage
                anchors.fill: parent
                source: window.model.getCardPicture(dealerIndex)
            }

            Behavior on x {
                ParallelAnimation {
                    id: dealerCardsAnimation
                    PropertyAnimation {
                        duration: 600
                        easing.type: Easing.InOutBack
                    }

                    SequentialAnimation {
                        PauseAnimation {
                            duration: 200
                        }

                        RotationAnimation {
                            target: dealerCard
                            direction: RotationAnimation.Clockwise
                            to: rotation + 360
                            duration: 400
                        }
                    }

                    NumberAnimation {
                        target: dealerCard
                        property: "x"
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    Rectangle {
        id: dealerDeck

        x: parent.x + 29 //+ index*60 + 60
        y: parent.y + 99
        width: 102
        height: width * 1.5
        radius: 8
        border {
            color : "white"
            width : 3
        }

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#a42489"
            }

            GradientStop {
                position: 1
                color: "#641449"
            }
        }
    }

    Component.onCompleted: {
        window.model.shuffle()
        window.hitClicked()
        window.hitClicked()
        window.model.takeOne(false, currentDealerIndex + 11)
        window.dealerHits()
        window.update()
    }
}
