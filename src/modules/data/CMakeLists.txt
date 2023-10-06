cmake_minimum_required(VERSION 3.16)

project(data)

set(QML_FILES
    DataServiceHub.qml
    LogSession.qml
)

set_source_files_properties(DataServiceHub.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

set(CPP_FILES
    LogMsg.h
    LogData.h
    LogData.cpp
    LogWatcherService.h
    LogWatcherService.cpp
    FpsItem.h
    FpsItem.cpp
    FileIO.h
    FileIO.cpp
    LogConfigModel.h
    LogConfigModel.cpp
)

qt_add_qml_module(${PROJECT_NAME}
    URI src.modules.${PROJECT_NAME}
    VERSION 1.0
    SOURCES ${CPP_FILES}
    QML_FILES ${QML_FILES}
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    DATA_DLL_BUILD
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::Core5Compat
    LogWatcher
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
