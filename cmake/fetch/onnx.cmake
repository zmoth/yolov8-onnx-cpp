message(STATUS "Fetch onnxruntime")

Include(FetchContent)

set(ONNX_VERSION "1.15.1")

if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  set(ONNX_URL "https://github.com/microsoft/onnxruntime/releases/download/v${ONNX_VERSION}/onnxruntime-win-x64-${ONNX_VERSION}.zip")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    set(ONNX_URL "https://github.com/microsoft/onnxruntime/releases/download/v${ONNX_VERSION}/onnxruntime-linux-aarch64-${ONNX_VERSION}.tgz")
  else()
    set(ONNX_URL "https://github.com/microsoft/onnxruntime/releases/download/v${ONNX_VERSION}/onnxruntime-linux-x64-${ONNX_VERSION}.tgz")
  endif()
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "arm64")
    set(ONNX_URL "https://github.com/microsoft/onnxruntime/releases/download/v${ONNX_VERSION}/onnxruntime-osx-arm64-${ONNX_VERSION}.tgz")
  else()
    set(ONNX_URL "https://github.com/microsoft/onnxruntime/releases/download/v${ONNX_VERSION}/onnxruntime-osx-x86_64-${ONNX_VERSION}.tgz")
  endif()
else()
  message(FATAL_ERROR "Unsupported CMake System Name '${CMAKE_SYSTEM_NAME}' (expected 'Windows', 'Linux' or 'Darwin')")
endif()

FetchContent_Declare(onnxruntime
  URL ${ONNX_URL}
  GIT_SHALLOW true
  DOWNLOAD_EXTRACT_TIMESTAMP true
)
FetchContent_MakeAvailable(onnxruntime)

message(STATUS "[${PROJECT_NAME}] ONNXRUNTIME_VERSION: ${ONNX_VERSION}, ONNXRUNTIME_DIR: ${onnxruntime_SOURCE_DIR}")

target_include_directories(${PROJECT_NAME} PRIVATE "${onnxruntime_SOURCE_DIR}/include")

if(WIN32)
  file(GLOB ONNXRUNTIME_BIN_FILES "${onnxruntime_SOURCE_DIR}/lib/*.dll")

  add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo $<TARGET_FILE_DIR:${PROJECT_NAME}>
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${ONNXRUNTIME_BIN_FILES}
    $<TARGET_FILE_DIR:${PROJECT_NAME}>
  )

  target_link_libraries(${PROJECT_NAME} PRIVATE "${onnxruntime_SOURCE_DIR}/lib/onnxruntime.lib")
elseif(APPLE)
  file(GLOB ONNXRUNTIME_BIN_FILES "${onnxruntime_SOURCE_DIR}/lib/libonnxruntime*.dylib")
  file(COPY ${ONNXRUNTIME_BIN_FILES} DESTINATION ${CMAKE_BINARY_DIR}/bin)

  target_link_libraries(${PROJECT_NAME} PRIVATE "${onnxruntime_SOURCE_DIR}/lib/libonnxruntime.dylib")
elseif(LINUX)
  file(GLOB ONNXRUNTIME_BIN_FILES "${onnxruntime_SOURCE_DIR}/lib/libonnxruntime.so*")
  file(COPY ${ONNXRUNTIME_BIN_FILES} DESTINATION ${CMAKE_BINARY_DIR}/bin)

  target_link_libraries(${PROJECT_NAME} PRIVATE "${onnxruntime_SOURCE_DIR}/lib/libonnxruntime.so")
endif()

if(DEFINED ONNXRUNTIME_BIN_FILES)
  # install(FILES ${ONNXRUNTIME_BIN_FILES} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
