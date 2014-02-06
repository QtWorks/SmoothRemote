import QtQuick 2.2

Item
{
    anchors.fill: parent
    property bool shown : true;
    property QtObject selectedArtist : null;
    signal artistSelected();

    ListModel {id : artist_index}

    function build_artist_index()
    {
        for (var i = 0; i < 26; i++)
            artist_index.append({"display" : String.fromCharCode(65 + i), "artistIdx" : -1});
        for (i = 0; i < artists_cover_flow.model.count; i++)
        {
            var idx = artist_index.get(artists_cover_flow.model.get(i).artist.charAt(0).toUpperCase().charCodeAt(0) - 65);
            if (idx.artistIdx === -1 || idx.artistIdx > i)
                idx.artistIdx = i;
        }
    }

    ListViewFlow
    {
        id : artists_cover_flow
        model : core.audioArtistsModel
        leftToRight: true
        onModelChanged : {index_timer.start()}
        flickDeceleration: 40
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
            bottom : parent.bottom
        }
        Timer
        {
            id : index_timer
            interval : 4000
            running : false
            repeat: false
            onTriggered: build_artist_index();
        }
        delegate : Component {
            Image
            {
                id : artist_delegate
                height : mainScreen.portrait ? PathView.view.width * 0.25 : PathView.view.height * 0.4
                width : height
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property real delScale : PathView.onPath ? (isCurrentItem) ? 1.25 : PathView.delScale : 0

                Behavior on delScale {SpringAnimation {spring : 5; damping: 1; epsilon: 0.005}}

                onIsCurrentItemChanged :
                {
                    if (isCurrentItem)
                        artist_idx_listview.currentIndex = model.artist.charAt(0).toUpperCase().charCodeAt(0) - 65;
                }
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                onStatusChanged : if (status === Image.Ready) pic_anim.start();
                NumberAnimation {id : pic_anim; target : artist_delegate; property : "scale"; from : 0; to : delScale; duration : 500; easing.type: Easing.InOutQuad}
                scale : delScale
                z : isCurrentItem ? 1 : 0
                transform: Rotation {
                    angle : 45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }
                source : model.thumbnailUrl
                smooth : true
                Text
                {
                    id : del_text
                    font.pointSize: 20
                    style: parent.isCurrentItem ? Text.Sunken : Text.Outline
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#cc2200"
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    text : model.artist
                    width : 2 * parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    anchors
                    {
                        top : parent.bottom
                        left : mainScreen.portrait ? undefined : parent.left
                        right : !mainScreen.portrait ? undefined : parent.right
                    }
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        if (isCurrentItem)
                        {
                            selectedArtist = model;
                            artistSelected();
                        }
                        else
                            artists_cover_flow.currentIndex = index;
                    }
                }
            }
        }
    }

    ListViewFlow
    {
        id : artist_idx_listview
        pathItemCount: mainScreen.portrait ? 8 : 15
        cacheItemCount: 10
        anchors
        {
            left : parent.horizontalCenter
            right : parent.right
            top : parent.top
            bottom : parent.verticalCenter
        }
        flickDeceleration: 150
        model : artist_index

        onMovingChanged :
        {
            if (!moving && currentItem.idx !== -1)
                artists_cover_flow.positionViewAtIndex(currentItem.idx, PathView.Center);
        }

        delegate : Component {
            Item
            {
                width : 100
                height : width
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property int idx : model.artistIdx
                z : isCurrentItem ? 1 : 0

                transform: Rotation {
                    angle : 45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }
                Text
                {
                    text : model.display
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    anchors.centerIn: parent
                    style: Text.Sunken
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#ff2200"
                    font.pointSize: 45
                    font.family : "Helvetica";
                    font.bold: true
                    scale : parent.isCurrentItem ? 1.5 : 0.8
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        console.log("Going to " + model.artistIdx);
                        if (artistIdx !== -1)
                        {
                            artists_cover_flow.positionViewAtIndex(model.artistIdx, PathView.Center);
                            artist_idx_listview.currentIndex = index;
                        }
                    }
                }
            }
        }
    }
}
