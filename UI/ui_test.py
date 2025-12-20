from PySide2.QtGui import QGuiApplication
from PySide2.QtCore import QUrl, QObject, Property, Signal
from PySide2.QtQml import QQmlApplicationEngine
import sys


class Backend(QObject):
    nameChanged = Signal(str)

    def __init__(self) -> None:
        super().__init__()
        self._name = "test"

    @Property(str, notify=nameChanged)
    def name(self) -> str:
        return self._name

    @name.setter
    def name(self, value):
        if value != self._name:
            self._name = value
            self.nameChanged.emit(value)


backend = Backend()
app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
engine.rootContext().setContextProperty("backend", backend)
engine.load(QUrl(r"UI/Main.qml"))
#view.setSource(QUrl(r"UI/Main.qml"))
#view.show()

if not engine.rootObjects():
    sys.exit(-1)
sys.exit(app.exec_())