# Włączenie komunikatów diagnostycznych dla aplikacji KDE

```
QT_LOGGING_RULES="*.debug=true" konsole
```

Przykład
```
QT_LOGGING_RULES="*.debug=true" konsole
qt.qpa.screen: Output DP1 is not connected
qt.qpa.screen: Output DP2 is not connected
qt.qpa.screen: Output HDMI1 is not connected
qt.qpa.screen: Output VIRTUAL1 is not connected
qt.qpa.screen: adding QXcbScreen(0x17709a0, name="eDP1", geometry=1366x768+0+0, availableGeometry=1366x728+0+40, devicePixelRatio=1.0, logicalDpi=QPai
r(96.1,96.1), physicalSize=344.0x194.0mm, screenNumber=0, virtualSize=1366x768 (1366.0x768.0mm), orientation=Qt::ScreenOrientation(LandscapeOrientatio
n), depth=24, refreshRate=60.0, root=f5, windowManagerName="KWin") (Primary: true )
qt.qpa.screen: primary output is "eDP1"
qt.qpa.input.devices: XInput version 2.2 is available and Qt supports 2.2 or greater
qt.qpa.input.devices: input device  Virtual core XTEST pointer ID 4
qt.qpa.input.devices:    has 10 buttons
qt.qpa.input.devices:    has valuator "Rel X" recognized? true
...
```