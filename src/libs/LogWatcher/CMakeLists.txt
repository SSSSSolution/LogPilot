cmake_minimum_required(VERSION 3.16)

project(LogWatcher)

add_library(${PROJECT_NAME} SHARED
	include/LogWatcher/LogWatcher.h
	src/LogWatcher.cpp
)

target_include_directories(${PROJECT_NAME} PUBLIC
	${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(${PROJECT_NAME} PUBLIC
	Qt6::Core
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
     LOG_WATCHER_DLL_BUILD
)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
