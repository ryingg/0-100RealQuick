#include "topitunes.h"
// itunes object made to parse itunes xml, can easily be refactored into other feeds
// top itunes qobject with network access and song list object
TopItunes::TopItunes(QObject *parent) : QObject(parent) {
    QNetworkAccessManager *networkAccessManager = new QNetworkAccessManager(this);
    connect(networkAccessManager, SIGNAL(finished(QNetworkReply*)),this, SLOT(fileIsReady(QNetworkReply*))); // call fileisready after loaded
    networkAccessManager->get(QNetworkRequest(QUrl(ITUNES_URL))); // get reply from url
}

// song list accessor
QList<QObject*> TopItunes::songList() {
    return m_songList;
}

// slot to build song list from file
void TopItunes::fileIsReady( QNetworkReply * reply) {
//    qDebug("file ready");
    QTemporaryFile temp_file;
    temp_file.open();
    temp_file.write(reply->readAll());
    temp_file.seek(0); //go to the begining

    QXmlStreamReader reader(&temp_file); // create xml stream reader from file
    int count = 0; // count items
    while (!reader.atEnd() && !reader.hasError()) {
      reader.readNext();
      if (reader.isStartElement()) {
          if(reader.name() == "entry") {
              while(reader.name()!="title") {
                  reader.readNextStartElement();
              }
              count++;
              QColor col;
              if(count%2)
                col = QColor("#eee");
              else
                col = QColor("#ddd");
              TopItunes::m_songList.append(new Song("Item "+QString::number(count), reader.readElementText(), col));
          }
      }
    }

    qDebug() << "length" << TopItunes::m_songList.length();
    emit songListCreated(); // finished appending data
}
