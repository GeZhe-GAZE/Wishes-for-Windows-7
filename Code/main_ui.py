from PySide2.QtCore import QUrl
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide2.QtGui import QGuiApplication, QIcon
from WishesBackend import Backend
from WishesQmlAPI import QCard, QCardPool, QWishResult, CardQueryParams
import sys


MAIN_QML_FILE = r"UI/Main.qml"


def registerWishesType():
    qmlRegisterType(QCard, "Wishes", 1, 0, "QCard") # type: ignore
    qmlRegisterType(QCardPool, "Wishes", 1, 0, "QCardPool") # type: ignore
    qmlRegisterType(QWishResult, "Wishes", 1, 0,"QWishResult") # type: ignore
    qmlRegisterType(Backend, "Wishes", 1, 0, "Backend") # type: ignore
    qmlRegisterType(CardQueryParams, "Wishes", 1, 0, "CardQueryParams") # type: ignore

  
def main():
    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon("Wishes.ico"))
    engine = QQmlApplicationEngine()
    registerWishesType()

    backend = Backend()
    engine.rootContext().setContextProperty("backend", backend)
    
    engine.load(QUrl(MAIN_QML_FILE))

    if not engine.rootObjects():
        sys.exit(-1)

    if backend.init_error_flag:
        backend.errorHappened.emit(*backend.init_error_content)     # type: ignore

    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
