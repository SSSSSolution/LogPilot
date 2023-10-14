#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QTimer>
#include <QThread>
#include <QFontDatabase>
#include <QDir>
#include <QDebug>

#ifdef _WIN32
#include <Windows.h>
#include <ShlObj.h>
#endif


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

QString getAppDataDir() {
#ifdef _WIN32
    char path[MAX_PATH];
    if (SUCCEEDED(SHGetFolderPathA(nullptr, CSIDL_LOCAL_APPDATA, nullptr, 0, path))) {
        return QString(path) + "\\" + APP_NAME;
    }
    qWarning() << "Failed to get app's data dir";
    return "";
#endif
    return "";
}

QString g_appDataDir;
QString g_configDir;
QString g_logDir;

bool ensureDirectoryExists(const QString &path) {
    QDir dir(path);
    if (!dir.exists()) {
        if (!dir.mkpath(".")) {
            qCritical() << "Failed to create dir: " << path;
            return false;
        }
    }
    return true;
}

void initAppDataDir() {
    g_appDataDir = QDir(QCoreApplication::applicationDirPath()).filePath("../AppData");
    if (!ensureDirectoryExists(g_appDataDir)) {
        qCritical() << "Failed to create data dir: " << g_appDataDir;
        qCritical() << "The App will only use default settings and will not save any data.";
        g_appDataDir = "";
        return;
    }

    g_configDir = QDir(g_appDataDir).filePath("config");
    if (!ensureDirectoryExists(g_configDir)) {
        qCritical() << "Failed to create config dir: " << g_logDir;
        g_configDir = "";
    }

    g_logDir = QDir(g_appDataDir).filePath("log");
    if (!ensureDirectoryExists(g_logDir)) {
        qCritical() << "Failed to create log dir: " << g_logDir;
        g_logDir = "";
    }
}

void registerGlobalVariableToQmlEngine(QQmlApplicationEngine &engine) {
    engine.rootContext()->setContextProperty("BuildDate", BUILD_DATE);
    engine.rootContext()->setContextProperty("BuildTime", BUILD_TIME);
    qInfo() << "App BUILD Time is: " << BUILD_DATE + QString("-") + BUILD_TIME;


    engine.rootContext()->setContextProperty("AppDataDir", g_appDataDir);
    engine.rootContext()->setContextProperty("AppConfigDir", g_configDir);
    engine.rootContext()->setContextProperty("AppLogDir", g_logDir);

    qInfo() << "App data dir is: " << g_appDataDir;
    qInfo() << "App config dir is: " << g_configDir;
    qInfo() << "App log dir is: " << g_logDir;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName(APP_NAME);
    app.setApplicationVersion(GIT_HASH);
    qInfo() << "App name: " << APP_NAME;
    qInfo() << "App version: " << GIT_HASH;

    initAppDataDir();

    qInstallMessageHandler(myMessageHandler);

    loadFonts();

//    startTest();

    QQmlApplicationEngine engine;
    qDebug() << engine.importPathList();

    registerGlobalVariableToQmlEngine(engine);

    // Get app data dir
    QString appDataDir = getAppDataDir();
    qApp->setProperty("AppDataDir", appDataDir);

    QUrl url = QUrl(QStringLiteral("qrc:/qt/qml/Main/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                     [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

