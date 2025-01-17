#
# Build AuthoringTool common
#

SET(AUTHORTINGTOOL_SOURCE_DIR ${PROJECT_SOURCE_DIR}/AuthoringTool/src)
SET(TOOLS_COMMON_SOURCE_DIR ${PROJECT_SOURCE_DIR}/common)

SET(EXT_AUTHORING_INCLUDE_DIR ${BLAST_ROOT_DIR}/sdk/extensions/authoring/include)
SET(TK_INCLUDE_DIR ${BLAST_ROOT_DIR}/sdk/toolkit/include)

FIND_PACKAGE(PHYSXSDK REQUIRED)
FIND_PACKAGE(PXSHAREDSDK REQUIRED)
FIND_PACKAGE(tclap $ENV{PM_tclap_VERSION} REQUIRED)
FIND_PACKAGE(tinyObjLoader $ENV{PM_tinyObjLoader_VERSION} REQUIRED)
FIND_PACKAGE(FBXSDK $ENV{PM_FBXSDK_VERSION} REQUIRED)


# Include here after the directories are defined so that the platform specific file can use the variables.
include(${PROJECT_CMAKE_FILES_DIR}/${TARGET_BUILD_PLATFORM}/AuthoringTool.cmake)

SET(COMMON_FILES
	${AUTHORTINGTOOL_PLATFORM_COMMON_FILES}
	
	${AUTHORTINGTOOL_SOURCE_DIR}/AuthoringTool.cpp
	${AUTHORTINGTOOL_SOURCE_DIR}/SimpleRandomGenerator.h
	${TOOLS_COMMON_SOURCE_DIR}/BlastDataExporter.h
	${TOOLS_COMMON_SOURCE_DIR}/BlastDataExporter.cpp
)

ADD_EXECUTABLE(AuthoringTool 
	${COMMON_FILES}
)

set_target_properties(AuthoringTool 
	PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX}
	CHECKED_POSTFIX ${CMAKE_CHECKED_POSTFIX}
	RELEASE_POSTFIX ${CMAKE_RELEASE_POSTFIX}
	PROFILE_POSTFIX ${CMAKE_PROFILE_POSTFIX}
)

SOURCE_GROUP("src" FILES ${COMMON_FILES})

# Target specific compile options

TARGET_INCLUDE_DIRECTORIES(AuthoringTool 
	PRIVATE ${AUTHORTINGTOOL_PLATFORM_INCLUDES}

	PRIVATE ${TOOLS_COMMON_SOURCE_DIR}
	PRIVATE ${EXT_AUTHORING_INCLUDE_DIR}
	PRIVATE ${TK_INCLUDE_DIR}
	PRIVATE ${BLAST_ROOT_DIR}/sdk/common
	PRIVATE ${BLAST_ROOT_DIR}/sdk/extensions/common/include
	
	PRIVATE ${PHYSXSDK_INCLUDE_DIRS}
	PRIVATE ${PXSHAREDSDK_INCLUDE_DIRS}
	PRIVATE ${TCLAP_INCLUDE_DIRS}
	PRIVATE ${TINYOBJLOADER_INCLUDE_DIRS}
	PRIVATE ${FBXSDK_INCLUDE_DIRS}
)

TARGET_COMPILE_DEFINITIONS(AuthoringTool 
	PRIVATE ${AUTHORTINGTOOL_COMPILE_DEFS}
)

SET_TARGET_PROPERTIES(AuthoringTool PROPERTIES 
	PDB_NAME_DEBUG "AuthoringTool${CMAKE_DEBUG_POSTFIX}"
	PDB_NAME_CHECKED "AuthoringTool${CMAKE_CHECKED_POSTFIX}"
	PDB_NAME_PROFILE "AuthoringTool${CMAKE_PROFILE_POSTFIX}"
	PDB_NAME_RELEASE "AuthoringTool${CMAKE_RELEASE_POSTFIX}"
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${BL_LIB_OUTPUT_DIR}/debug"
    LIBRARY_OUTPUT_DIRECTORY_DEBUG "${BL_DLL_OUTPUT_DIR}/debug"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${BL_EXE_OUTPUT_DIR}/debug"
    ARCHIVE_OUTPUT_DIRECTORY_CHECKED "${BL_LIB_OUTPUT_DIR}/checked"
    LIBRARY_OUTPUT_DIRECTORY_CHECKED "${BL_DLL_OUTPUT_DIR}/checked"
    RUNTIME_OUTPUT_DIRECTORY_CHECKED "${BL_EXE_OUTPUT_DIR}/checked"
    ARCHIVE_OUTPUT_DIRECTORY_PROFILE "${BL_LIB_OUTPUT_DIR}/profile"
    LIBRARY_OUTPUT_DIRECTORY_PROFILE "${BL_DLL_OUTPUT_DIR}/profile"
    RUNTIME_OUTPUT_DIRECTORY_PROFILE "${BL_EXE_OUTPUT_DIR}/profile"
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${BL_LIB_OUTPUT_DIR}/release"
    LIBRARY_OUTPUT_DIRECTORY_RELEASE "${BL_DLL_OUTPUT_DIR}/release"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${BL_EXE_OUTPUT_DIR}/release"
)

# Do final direct sets after the target has been defined
TARGET_LINK_LIBRARIES(AuthoringTool
	PRIVATE NvBlast NvBlastTk NvBlastExtSerialization NvBlastExtTkSerialization NvBlastExtPxSerialization NvBlastExtPhysX NvBlastExtExporter NvBlastExtAuthoring
	PRIVATE ${FBXSDK_LIBRARIES}
)

# Copy the dlls from the deps

ADD_CUSTOM_COMMAND(TARGET AuthoringTool POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E copy_if_different 
	${APEXSDK_DLLS} ${PHYSXSDK_DLLS}
	${BL_EXE_OUTPUT_DIR}
	$<TARGET_FILE_DIR:AuthoringTool>
)

