#
# Build NvBlastExtShaders Common
#


SET(COMMON_SOURCE_DIR ${PROJECT_SOURCE_DIR}/common)
SET(SHADERS_EXT_SOURCE_DIR ${PROJECT_SOURCE_DIR}/extensions/shaders/source)
SET(SHADERS_EXT_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/extensions/shaders/include)

FIND_PACKAGE(PXSHAREDSDK ${PM_physxsdk_VERSION} REQUIRED)
FIND_PACKAGE(PHYSXSDK ${PM_pxshared_VERSION} REQUIRED)
FIND_PACKAGE(CAPNPROTOSDK $ENV{PM_CapnProto_VERSION} REQUIRED)

# Include here after the directories are defined so that the platform specific file can use the variables.
include(${PROJECT_CMAKE_FILES_DIR}/${TARGET_BUILD_PLATFORM}/NvBlastExtShaders.cmake)

SET(COMMON_FILES
	${BLASTEXT_PLATFORM_COMMON_FILES}
	
	${COMMON_SOURCE_DIR}/NvBlastAssert.cpp
	${COMMON_SOURCE_DIR}/NvBlastAssert.h
)

SET(PUBLIC_FILES
	${SHADERS_EXT_INCLUDE_DIR}/NvBlastExtDamageShaders.h
)

SET(EXT_SOURCE_FILES
	${SHADERS_EXT_SOURCE_DIR}/NvBlastExtDamageShaders.cpp
	${SHADERS_EXT_SOURCE_DIR}/NvBlastExtDamageAcceleratorInternal.h
	${SHADERS_EXT_SOURCE_DIR}/NvBlastExtDamageAcceleratorAABBTree.h
	${SHADERS_EXT_SOURCE_DIR}/NvBlastExtDamageAcceleratorAABBTree.cpp
	${SHADERS_EXT_SOURCE_DIR}/NvBlastExtDamageAccelerators.cpp
)

ADD_LIBRARY(NvBlastExtShaders ${BLAST_EXT_SHARED_LIB_TYPE} 
	${COMMON_FILES}
	${PUBLIC_FILES}

	${EXT_SOURCE_FILES}
)

SOURCE_GROUP("common" FILES ${COMMON_FILES})
SOURCE_GROUP("public" FILES ${PUBLIC_FILES})
SOURCE_GROUP("src" FILES ${EXT_SOURCE_FILES})


# Target specific compile options

TARGET_INCLUDE_DIRECTORIES(NvBlastExtShaders 
	PRIVATE ${BLASTEXT_PLATFORM_INCLUDES}

	PUBLIC ${PROJECT_SOURCE_DIR}/lowlevel/include
	PUBLIC ${SHADERS_EXT_INCLUDE_DIR}

	PRIVATE ${SHADERS_EXT_SOURCE_DIR}
	PRIVATE ${PROJECT_SOURCE_DIR}/common

	PRIVATE ${PXSHAREDSDK_INCLUDE_DIRS}
	PRIVATE ${PHYSXSDK_INCLUDE_DIRS}
)

TARGET_COMPILE_DEFINITIONS(NvBlastExtShaders
	PRIVATE ${BLASTEXT_COMPILE_DEFS}
)

# Warning disables for Capn Proto
TARGET_COMPILE_OPTIONS(NvBlastExtShaders
	PRIVATE ${BLASTEXT_PLATFORM_COMPILE_OPTIONS}
)

SET_TARGET_PROPERTIES(NvBlastExtShaders PROPERTIES 
	PDB_NAME_DEBUG "NvBlastExtShaders${CMAKE_DEBUG_POSTFIX}"
	PDB_NAME_CHECKED "NvBlastExtShaders${CMAKE_CHECKED_POSTFIX}"
	PDB_NAME_PROFILE "NvBlastExtShaders${CMAKE_PROFILE_POSTFIX}"
	PDB_NAME_RELEASE "NvBlastExtShaders${CMAKE_RELEASE_POSTFIX}"
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
# TARGET_LINK_LIBRARIES(NvBlastExtShaders NvBlast ${PHYSXSDK_LIBRARIES} ${APEXSDK_LIBRARIES} ${PXSHAREDSDK_LIBRARIES})
TARGET_LINK_LIBRARIES(NvBlastExtShaders 
	PUBLIC NvBlast NvBlastGlobals
	PUBLIC ${BLASTEXT_PLATFORM_LINKED_LIBS}
)
