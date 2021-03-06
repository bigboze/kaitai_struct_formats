meta:
  id: android_opengl_shaders_cache
  title: com.android.opengl.shaders_cache file
  application: Android
  license: Apache-2.0
  endian: le

doc: |
  Android apps using directly or indirectly OpenGL cache compiled shaders into com.android.opengl.shaders_cache file.
doc-ref: https://android.googlesource.com/platform/frameworks/native/+/master/opengl/libs/EGL/FileBlobCache.cpp

seq:
  - id: signature
    contents: ["EGL$"]
  - id: crc32
    type: u4
    doc: crc32 of `contents`
  - id: contents
    type: cache
    size-eos: true

types:
  alignment:
    seq:
      - id: alignment
        size: "(_io.pos + 3) & ~3 - _io.pos"
        doc: garbage from memory
  string:
    seq:
      - id: length
        type: u4
        -orig-id: mBuildIdLength
      - id: str
        type: strz
        encoding: ascii
        size: length
        -orig-id: mBuildId, buildId
      - id: alignment
        type: alignment
  cache:
    doc-ref: https://android.googlesource.com/platform/frameworks/native/+/master/opengl/libs/EGL/BlobCache.cpp
    seq:
      - id: signature
        -orig-id: mMagicNumber, blobCacheMagic
        contents: ["$bB_"]
      - id: version
        type: u4
        -orig-id: mBlobCacheVersion, blobCacheVersion
      - id: device_version
        type: u4
        -orig-id: mDeviceVersion, blobCacheDeviceVersion
      - id: count_of_entries
        type: u4
        -orig-id: mNumEntries
      - id: build_id
        type: string
        -orig-id: mBuildIdLength, mBuildId, buildId
        if: version >= 3 # hypothesis, needs deeper investigation
      - id: entries
        type: entry
        repeat: expr
        repeat-expr: count_of_entries
    types:
      entry:
        seq:
          - id: key_size
            type: u4
            -orig-id: mKeySize, keySize
          - id: value_size
            type: u4
            -orig-id: mValueSize, valueSize
          - id: key
            size: key_size
          - id: value
            size: value_size
          - id: alignment
            type: alignment
