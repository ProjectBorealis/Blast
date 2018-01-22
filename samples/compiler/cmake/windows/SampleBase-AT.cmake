# Copy the dlls from the deps

ADD_CUSTOM_COMMAND(TARGET SampleBase POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E copy_if_different 
	${PXSHAREDSDK_DLLS} ${PHYSXSDK_DLLS} ${SHADOW_LIB_DLL} ${HBAO_PLUS_DLL} ${D3DCOMPILER_DLL} ${NVTOOLSEXT_DLL}
	${BL_EXE_OUTPUT_DIR}
)
