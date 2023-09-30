cmake_minimum_required(VERSION 3.16)

project(LogPilot)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_compile_options("/W3;/WX;/EHsc")
add_compile_options("$<$<CONFIG:DEBUG>:/Zi;/Od;/RTC1;/MDd>")
add_compile_options("$<$<CONFIG:RELEASE>:/O2;/Ob2;/MD;/DNDEBUG>")


if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/install_debug)
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
  set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/install_release)
endif()


find_package(Qt6 REQUIRED COMPONENTS Core Widgets Qml Quick Core5Compat)
qt_standard_project_setup(REQUIRES 6.5)

list(APPEND QML_DIRS "${CMAKE_CURRENT_BINARY_DIR}/src/modules")
set(QML_IMPORT_PATH "${QML_DIRS}" CACHE STRING "" FORCE)


include(GNUInstallDirs)

include_directories(src/libs/WinExport)

add_subdirectory(src/libs)
add_subdirectory(src/modules)
add_subdirectory(src/app)

