cmake_minimum_required(VERSION 3.16)

project(log_pilot)

qt_add_executable(${PROJECT_NAME}
	main.cpp
    app.rc
)

qt_add_resources(${PROJECT_NAME} "assets"
    PREFIX "/"
    FILES
        ../../assets/images/bg.png
        ../../assets/images/log-pilot.svg
        ../../assets/icons/open-file.svg
        ../../assets/icons/clip.svg
        ../../assets/icons/search.svg
        ../../assets/icons/setting.svg
        ../../assets/icons/down-arrow.svg
        ../../assets/icons/scroll-down.svg
        ../../assets/fonts/Sansation-Regular.ttf
        ../../assets/fonts/JosefinSlab-Regular.ttf
        ../../assets/fonts/JosefinSlab-Bold.ttf
        ../../assets/configs/LogPilotConfig.json
    BASE "../../assets"
)

qt_add_shaders(${PROJECT_NAME} "shaders"
    PREFIX "/"
    FILES
        ../../assets/shaders/blur.frag
    BASE "../../assets"
)

qt_add_qml_module(${PROJECT_NAME}
    URI Main
    VERSION 1.0
    QML_FILES
        Main.qml
)

set_target_properties(${PROJECT_NAME} PROPERTIES
        WIN32_EXECUTABLE TRUE
)

target_compile_definitions(${PROJECT_NAME} PRIVATE QT_QML_DEBUG)

target_link_libraries(${PROJECT_NAME} PRIVATE
	Qt6::Core
	Qt6::Quick
        data
)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE "APP_NAME=\"Log Pilot\""
)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

if (CMAKE_BUILD_TYPE STREQUAL "Release")
    qt_generate_deploy_qml_app_script(
        TARGET ${PROJECT_NAME}
        OUTPUT_SCRIPT deploy_script
        NO_UNSUPPORTED_PLATFORM_ERROR
        DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
        NO_COMPILER_RUNTIME
    )
    install (SCRIPT ${deploy_script})
endif()
