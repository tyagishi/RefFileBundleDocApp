# SwiftUI App template
## basic feature
- document-based app
- use ReferenceFileDocument as document type
- use bundle/package as document

## branch: main
- simple document-based app
- document contents is fixed (2 files in package)

## branch: filesystem
- document-based app
- document can contain files like file-system
- at save, check changes in file then update FileWrapper

## branch: filesystemWithGRDB
- document-based app
- document has "grdb.sqlite" file for GRDB file
- document still has other text files
