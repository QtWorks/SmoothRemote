import QtQuick 2.1

Item
{
    anchors.fill: parent


    Item
    {
        id : arrow_controls
        width : 400 * mainScreen.dpiMultiplier
        height: width

        anchors.centerIn: parent

        Image
        {
            source : "Resources/arrow.png"
            rotation : -90
            scale : left_ma.pressed ? 0.9 : 1

            anchors
            {
                left : parent.left
                verticalCenter : parent.verticalCenter
            }

            MouseArea
            {
                id : left_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(2);
                }
            }
        }
        Image
        {
            source : "Resources/arrow.png"
            scale : up_ma.pressed ? 0.9 : 1

            anchors
            {
                top : parent.top
                horizontalCenter : parent.horizontalCenter
            }

            MouseArea
            {
                id : up_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(0);
                }
            }
        }
        Image
        {
            source : "Resources/arrow.png"
            rotation : 90
            scale : right_ma.pressed ? 0.9 : 1

            anchors
            {
                right : parent.right
                verticalCenter : parent.verticalCenter
            }

            MouseArea
            {
                id : right_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(3);
                }
            }
        }
        Image
        {
            source : "Resources/arrow.png"
            rotation : 180
            scale : down_ma.pressed ? 0.9 : 1

            anchors
            {
                bottom : parent.bottom
                horizontalCenter : parent.horizontalCenter
            }

            MouseArea
            {
                id : down_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(1);
                }
            }
        }

        Rectangle
        {
            anchors.centerIn: parent
            width : 128;
            height : 128
            radius : width
            color : "#2c2c2c"
            scale : validate_ma.pressed ? 0.9 : 1

            MouseArea
            {
                id : validate_ma
                anchors.fill: parent
                onClicked: core.buttonAction(4);
            }
        }
    }
    Item
    {
        width : 128
        height : width
        anchors
        {
            top : arrow_controls.bottom
            right : arrow_controls.left
        }
        scale : back_button_ma.pressed ? 0.9 : 1

        Rectangle
        {
            color : "#2c2c2c"
            rotation : 45
            height: parent.height * 0.5
            width : height
        }
        MouseArea
        {
            id : back_button_ma
            anchors.fill: parent
            onClicked: core.buttonAction(5);
        }
    }
}
