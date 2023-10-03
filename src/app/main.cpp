#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QTimer>
#include <QThread>
#include <QFontDatabase>
#include <QDebug>


void myMessageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Q_UNUSED(context);
    QString txt;
    switch (type) {
    case QtInfoMsg:
        txt = QString("Info: %1\n").arg(msg);
        break;
    case QtDebugMsg:
        txt = QString("Debug: %1\n").arg(msg);
        break;
    case QtWarningMsg:
        txt = QString("Warning: %1\n").arg(msg);
        break;
    case QtCriticalMsg:
        txt = QString("Critical: %1\n").arg(msg);
        break;
    case QtFatalMsg:
        txt = QString("Fatal: %1\n").arg(msg);
        abort();
    }
    fprintf(stderr, "%s\n", msg.toStdString().c_str());
    fflush(stderr);

    QString logPath = qApp->applicationDirPath() + "\\log.txt";
    QFile logFile(logPath);
    logFile.open(QIODevice::WriteOnly | QIODevice::Append);
    QTextStream ts(&logFile);
    ts << txt;
}

void startTest() {
    QTimer *testTimer = new QTimer();
    QObject::connect(testTimer, &QTimer::timeout, testTimer, [](){
        static int i = 0;

        QString testLogFile = "C:\\tmp\\log.txt";
        QFile logFile(testLogFile);
        logFile.open(QIODevice::WriteOnly | QIODevice::Append);
        QTextStream ts(&logFile);
        ts << "[trace] test info test info tet info" << i++ << "\n";
        ts << "[debug] test info test info tet info" << i++ << "\n";
        ts << "[info] test info test info tet info" << i++ << "\n";
        ts << "[warning] test info test info tet info" << i++ << "\n";
        ts << "[error] test info test info tet info" << i++ << "\n";
        ts << "[fatal] test info test info tet info" << i++ << "\n";
    });
    testTimer->start(300);
}

void loadFonts() {
    int fontId = QFontDatabase::addApplicationFont(":/fonts/Sansation-Regular.ttf");
    if (fontId != -1) {
        QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
        qDebug() << "Load font: " << fontFamilies;
    } else {
        qDebug() << "Failed to load font.";
    }

    fontId = QFontDatabase::addApplicationFont(":/fonts/JosefinSlab-Regular.ttf");
    if (fontId != -1) {
        QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
        qDebug() << "Load font: " << fontFamilies;
    } else {
        qDebug() << "Failed to load font.";
    }

    fontId = QFontDatabase::addApplicationFont(":/fonts/JosefinSlab-Bold.ttf");
    if (fontId != -1) {
        QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
        qDebug() << "Load font: " << fontFamilies;
    } else {
        qDebug() << "Failed to load font.";
    }
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qInstallMessageHandler(myMessageHandler);

    app.setApplicationName(APP_NAME);
    app.setApplicationVersion(GIT_HASH);

    loadFonts();

//    startTest();

    QQmlApplicationEngine engine;
    qDebug() << engine.importPathList();

    engine.rootContext()->setContextProperty("BuildDate", BUILD_DATE);
    engine.rootContext()->setContextProperty("BuildTime", BUILD_TIME);

    QUrl url = QUrl(QStringLiteral("qrc:/qt/qml/Main/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                     [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

