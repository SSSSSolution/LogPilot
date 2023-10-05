cmake_minimum_required(VERSION 3.16)

project(components)

set(QML_FILES
    DefaultIconButton.qml
    OpenFileButton.qml
    ClipButton.qml
    SearchButton.qml
    DefaultText.qml
    DefaultTextInput.qml
    DefaultTextButton.qml
    LevelComboBox.qml
    DefaultScrollBar.qml
    SettingTabBar.qml
    HueSlider.qml
    ColorGradientPanel.qml
)

qt_add_qml_module(${PROJECT_NAME}
    URI src.modules.${PROJECT_NAME}
    VERSION 1.0
    QML_FILES ${QML_FILES}
)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# install qml module
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}plugin.dll
    ${CMAKE_CURRENT_BINARY_DIR}/qmldir
    DESTINATION ${CMAKE_INSTALL_PREFIX}/qml/src/modules/${PROJECT_NAME}
)
