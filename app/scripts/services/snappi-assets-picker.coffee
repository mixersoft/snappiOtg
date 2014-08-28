'use strict'

###*
 # @ngdoc service
 # @name snappiOtgApp.snappiAssetsPicker
 # @description
 # # snappiAssetsPicker
 # Factory in the snappiOtgApp.
###
angular.module('snappiOtgApp')
  .factory( 'snappiAssetsPicker', [
    '$q',
    '$rootScope'
    '$timeout'
    ($q, $rootScope, $timeout)->
      Camera = Camera || 
      {  # stub for HTML5 testing
        DestinationType: 
          FILE_URI:0
          IMAGE_URI: 1
        PictureSourceType:
          PHOTOLIBRARY: 0
        PopoverArrowDirection:
          ARROW_UP: 0
      }


      _defaults = {
        targetWidth : 320
        quality: 85
        thumbnail: true
      }
      options = _.extend _.defaults, $rootScope.camera


      # Service logic
      _defaultCameraOptions = {
        fromPhotoLibrary:
          quality: options.quality
          destinationType: Camera.DestinationType.FILE_URI
          # destinationType: Camera.DestinationType.DATA_URL
          sourceType: Camera.PictureSourceType.PHOTOLIBRARY
          correctOrientation: true # Let Cordova correct the picture orientation (WebViews don't read EXIF data properly)
          targetWidth: options.targetWidth
          thumbnail: options.thumbnail
          popoverOptions: 
              x: 268
              y: 0
              width: 500
              height: 400
              popoverWidth: 500
              popoverHeight: 624
              arrowDir: Camera.PopoverArrowDirection.ARROW_UP
          # iPad camera roll popover position
            # width: 768
            # height: 
            # arrowDir: Camera.PopoverArrowDirection.ARROW_UP
        fromCamera:
          quality: options.quality
          destinationType: Camera.DestinationType.IMAGE_URI
          correctOrientation: true
          targetWidth: options.targetWidth
      }

      # private
      _fileStoreReady = null

      # usage: _initFileStore().then (o)
      _initFileStore = ()->
        return _fileStoreReady if _fileStoreReady

        dfd0 = $q.defer()
        _fileStoreReady = dfd0.promise
        ### pattern: 
        (o)->
          dfd = $q.defer()
          asyncFn (retval)->
            dfd.resolve {
              retval: reval
            }
          return dfd.promise
        ###
        steroids.on "ready", ()->
          dfd = $q.defer()
          if _.isFunction(window.requestFileSystem)
            window.requestFileSystem  LocalFileSystem.PERSISTENT
              , 50000*1024
              , (fs)-> 
                $snappiAssetsPicker.log "Success: requestFileSystem PERSISTENT=" + fs.root.fullPath
                dfd.resolve( {
                    directoryEntry:
                      'root': fs.root
                    })
              , (ev)->
                $snappiAssetsPicker.log "Error: requestFileSystem failed. "+ev.target.error.code
                dfd.resolve( {
                    directoryEntry:
                      'root': null
                    })
          else dfd.resolve({
                directoryEntry:
                  'root': null
                })
          dfd.promise.then (o)->
            $snappiAssetsPicker.log "0. got o.directoryEntry.root"
            return o if o.directoryEntry['root']?

            $snappiAssetsPicker.log "1. failed o.root, trying userFilesPath"
            # else get directoryEntry for steroids.app.userFilesPath  
            dfd = $q.defer()
            window.resolveLocalFileSystemURI steroids.app.userFilesPath
              , (directoryEntry)->
                dfd.resolve {
                  directoryEntry:
                    root: directoryEntry
                }
              , ()->
                self.fileError
                throw "Error:  resolveLocalFileSystemURI steroids.app.userFilesPath"
            return dfd.promise
          .then (o)->
            # get preview directoryEntry
            dfd = $q.defer()
            # # use directoryEntry.getDirectory() to create preview directoryEntry
            o.directoryEntry['preview'] = o.directoryEntry['root']  # placeholder, resolve immediately
            dfd.resolve(o)
            $snappiAssetsPicker.log "1. got o.directoryEntry.preview"
            return dfd.promise  
          .then (o)->
            # final resolve
            $snappiAssetsPicker.log "2. got o.directoryEntry final resolve"
            dfd0.resolve o 
            return 
            # o = {
            #   root: directoryEntry
            #   preview: directoryEntry
            # }
          return
            
        return dfd0.promise

      _pipelinePromises = {
        # all methods to be used with promise API, e.g. then method()
        getLocalFilesystem : (o)->
          ### expecting o = 
              directoryEntry:
                root: File.DirectoryEntry
                preview: File.DirectoryEntry
          ###
          return { 'directoryEntry': o.directoryEntry }  # _.pluck o "directoryEntry"


        getPreviewAsDataURL : (o, options, extension='JPG', label='preview')->
          ### this method uses snappi.assetspicker.getById() to resize dataURL
          call: then (o)->
              return getPreviewAsDataURL(o, uuid, extension, options)

          expecting o = 
            uuid: 
            orig_ext:
            data: 
            directoryEntry:

          return {
            directoryEntry
            dataURL: 
              '[label]': DataURL
          }
          ###
          dfd = $q.defer()

          # $snappiAssetsPicker.log {
          #   msg: "**** _initFileStore() ******"
          #   root: o.directoryEntry.root.fullPath 
          #   preview: o.directoryEntry.preview.fullPath 
          # }
          options = _.defaults options, {
            quality: 75
            targetWidth: 640
          }

          

          
          if extension == 'PNG' 
            options.encodingType = navigator.camera.EncodingType.PNG 
            mimeType = 'image/png'
          else 
            options.encodingType = navigator.camera.EncodingType.JPEG
            mimeType = 'image/jpeg'


          # noop, just format retval and return
          if options.destinationType == navigator.camera.DestinationType.DATA_URL && o.data
            o.dataURL = o.dataURL || {}
            o.dataURL[label] = "data:" + mimeType + ";base64," + o.data
            $snappiAssetsPicker.log "getPreviewAsDataURL(): already dataurl=" + o.dataURL[label][0..100]
            dfd.resolve o
            return dfd.promise

          # destinationType == FILE_URI
          options.destinationType = navigator.camera.DestinationType.DATA_URL  # force!
          $snappiAssetsPicker.log options

          window.plugin?.snappi?.assetspicker?.getById o.uuid
            , o.orig_ext
            , (data)->
              $snappiAssetsPicker.log "getPreviewAsDataURL(): getById() for DATA_URL, data="+data.data[0..100]
              o.dataURL = o.dataURL || {}
              o.dataURL[label] = "data:" + mimeType + ";base64," + data.data
              return dfd.resolve o
            , (message)->
              dfd.reject("Error assetspicker.getbyId() to dataURL")
            , options
          return dfd.promise  

        writeDataURL2File : (o, version='preview')->
          ### 
          call: then (o)->
              return writeDataURL2File(o, filename)

          expecting o = 
            uuid: 
            directoryEntry:
              root: File.DirectoryEntry
              preview: File.DirectoryEntry
            dataURL:
              '[version]':

          return {
            fileEntry:
              'preview': File.FileEntry
          }
          ###
          # TODO: complete preview==false
          $snappiAssetsPicker.log "writeDataURL2File(): WARNING: write full-res dataURL to file not yet implemented!" if version != 'preview'
          $snappiAssetsPicker.log "writeDataURL2File(): filename=" + o.uuid 

          folder = version
          if o.dataURL[folder].indexOf('data:image/jpeg')==0
            extension = 'JPG'
          else if o.dataURL[folder].indexOf('data:image/png')==0
            extension = 'PNG'
          else 
            $snappiAssetsPicker.log "writeDataURL2File(): ERROR: unknown mimetype, dataurl=" + o.dataURL[folder][0...60]

          filename = o.uuid  + "." + version + "." + extension
          # $snappiAssetsPicker.log "o.directoryEntry" + JSON.stringify( o )[0..300]
          try 
            dfd = $q.defer()
            $snappiAssetsPicker.log "writeDataURL2File(): destination=" + o.directoryEntry[folder].name
            _writeDataUrl2File o.directoryEntry[folder]
              , filename
              , o.dataURL[folder]
              , (fileEntry)->
                o.fileEntry = o.fileEntry || {}
                o.fileEntry[folder] = fileEntry   # o.fileEntry['preview']
                dfd.resolve o
          catch error
            $snappiAssetsPicker.log "writeDataURL2File(): *****  EXCEPTION : reject & try dataURLPipeline"
            $snappiAssetsPicker.log "writeDataURL2File(): directoryEntry not defined for version=" + folder if !o.directoryEntry?[folder]
            $snappiAssetsPicker.log error
            dfd.reject(o) # goto .catch() and try dataUrlPipeline

          return dfd.promise  

        resolveLocalFileSystemURI : (o, fileURI, name='selected')->
          ### 
          call: then (o)->
              return resolveLocalFileSystemURI(o, fileURI, 'chosen')

          expecting o = {}

          return {
            fileEntry:
              [name]: File.FileEntry
          }
          ###
          $snappiAssetsPicker.log "resolveLocalFileSystemURI(): fileURI="+fileURI[0..120]
          dfd = $q.defer()
          window.resolveLocalFileSystemURI fileURI
            , (fileEntry)->
              $snappiAssetsPicker.log "resolveLocalFileSystemURI(): fileEntry=" + fileEntry.name
              o.fileEntry = o.fileEntry || {}
              o.fileEntry[name] = fileEntry   # o.fileEntry['selected']
              dfd.resolve o
            , ()->
              $snappiAssetsPicker.log "resolveLocalFileSystemURI(): CATCH: resolveLocalFileSystemURI="+fileURI
              # self.fileError
              throw "Error:  resolveLocalFileSystemURI fileURI"
          return dfd.promise

        fileEntryMoveTo : (o, fileEntry, directoryEntry, filename, label='original')->
          ### 
          call: then (o)->
              return fileEntryMoveTo(o, o.fileEntry['selected'], o.directoryEntry['root'], uuid, 'original')

          expecting o =
            uuid:
            orig_ext: 
            directoryEntry:
              root: File.DirectoryEntry
              preview: File.DirectoryEntry
            fileEntry: {}

          return {
            filename: string, UUID
            fileEntry:
              '[label]': File.FileEntry
          }
          ###
          # $snappiAssetsPicker.log "fileEntryMoveTo()"
          dfd = $q.defer()
          
          if label == 'original'
            filename += "." + o.orig_ext 
          else filename +=  "." + label + "." + o.orig_ext

          source = fileEntry.fullPath
          dest = directoryEntry.fullPath + '/' + filename

          if source == dest 
            $snappiAssetsPicker.log "fileEntryMoveTo SKIP"
            o.fileEntry[label] = fileEntry
            dfd.resolve o
            return dfd.promise
          
          $snappiAssetsPicker.log "fileEntryMoveTo():  fileEntry=" + fileEntry.fullPath + ", target=dirEntry=" + dest

          fileEntry.moveTo directoryEntry
            , filename
            , (fileEntry)->
              $snappiAssetsPicker.log "fileEntryMoveTo(): COMPLETE"
              o.fileEntry[label] = fileEntry
              dfd.resolve o       
            , (o)->
              # self.fileError
              $snappiAssetsPicker.log "fileEntryMoveTo(): Error:  o.fileEntry.chosen.moveTo, dirEntry=" + directoryEntry.fullPath
              $snappiAssetsPicker.log o
              throw "Error:  o.fileEntry.chosen.moveTo"
          return dfd.promise

        fileEntryCopyTo : (o, fileEntry, directoryEntry, filename, label='copy')->
          ### 
          call: then (o)->
              return fileEntryCopyTo(o, o.fileEntry['original'], o.directoryEntry['preview'], uuid, 'preview')

          expecting o = 
            uuid:
            orig_ext:
            directoryEntry:
              root: File.DirectoryEntry
              preview: File.DirectoryEntry
            fileEntry: {}

          return {
            filename: string
            fileEntry:
              '[label]': File.FileEntry
          }
          ###
          filename = filename + "." + label + "." + o.orig_ext
          dfd = $q.defer()
          fileEntry.copyTo directoryEntry
            , filename
            , (fileEntry)->
              o.fileEntry[label] = fileEntry
              o['filename'] = filename
              dfd.resolve o       
            , ()->
              # self.fileError
              $snappiAssetsPicker.log "Error:  o.fileEntry.chosen.copyTo"
              throw "Error:  o.fileEntry.chosen.copyTo"
          return dfd.promise


        formatResult : (o)->
          ### 
          call: then formatResult

          expecting o = 
            uuid:
            orig_ext: [JPG | PNG]
            directoryEntry:
              root: File.DirectoryEntry
              preview: File.DirectoryEntry
            fileEntry: 
              original: File.FileEntry
              preview: File.FileEntry

          ###
          retval = {
            # originalSrc: '/' + o.fileEntry['original'].name
            id: o.uuid
            label: o['label']
            orig_ext: o.orig_ext
            extension: o.extension
            originalSrc: null
            previewSrc: null
          }
          retval.originalSrc = '/' + o.fileEntry['original'].name if o.fileEntry?['original']
          retval.previewSrc = '/' + o.fileEntry['preview'].name if o.fileEntry?['preview']
          return retval

        mapPhotos : ( options = {} )->
          ###
          options.pluck = ['DateTimeOriginal', 'PixelXDimension', 'PixelYDimension', 'Orientation']
          options.fromDate/toDate: String Date().toJSON() in local time
          ###


          dfd = $q.defer()
          _getAsLocalTimeJSON = (d)->
            d = new Date() if !d
            throw "_getAsLocalTimeJSON: expecting a Date param" if !_.isDate(d)
            d.setHours(d.getHours() - d.getTimezoneOffset() / 60)
            return d.toJSON()



          # options.fromDate = moment().startOf('day').set('hours',13).subtract(6,'days').toDate()  # test
          # options.toDate = moment().startOf('day').set('hours',18).subtract(6,'days').toDate()  # test

          options.fromDate = _getAsLocalTimeJSON(options.fromDate) if options.fromDate? && _.isDate(options.fromDate)
          options.toDate = _getAsLocalTimeJSON(options.toDate) if options.toDate? && _.isDate(options.toDate)
          start = new Date().getTime()
          $timeout ()->
              window.plugin.snappi?.assetspicker?.mapAssetsLibrary (mapped)->
                  end = new Date().getTime()
                  $snappiAssetsPicker.log '*** mapped.lastDate='+mapped.lastDate + ', count='+mapped.assets.length + ', elapsed=' + ((end-start)/1000)
                  # $snappiAssetsPicker.log JSON.stringify mapped.assets[-20..-1]

                  return dfd.resolve mapped
                , (error)->
                  $snappiAssetsPicker.log "mapAssetsLibrary FAILED"
                  $snappiAssetsPicker.log error
                  return dfd.reject error
                , options
            , 100

          $snappiAssetsPicker.log "*** mapAssetsLibrary(), options="+JSON.stringify options

          return dfd.promise
          

      }
      # end _pipelinePromises 



      # Public API here
      $snappiAssetsPicker = {
        type : "snappiAssetsPickerService"
        log: (o)->
          return steroids.logger.log o if window.deviceReady 
          return console.log o
        cameraOptions: _defaultCameraOptions
        # Camera failure callback
        cameraError : (message)->
          # navigator.notification.alert 'Cordova says: ' + message, null, 'Capturing the photo failed!'
          if _deferred?
            _deferred.reject( message )
             

        # File system failure callback
        fileError : (error)->
          # navigator.notification.alert "Cordova error code: " + error.code, null, "File system error!"
          $snappiAssetsPicker.log  "Cordova error code: " + error.code + " fileError. " 
          if _deferred?
            _deferred.reject( "Cordova error code: " + error.code + " fileError. "  )

        dataURLPipeline: (o, options)->
          return

        fileURIPipeline: (o, options)->
          return  

        mapPhotos: (options)->
          promise = _initFileStore().then (o)->
              $snappiAssetsPicker.log "filestore initialized" 
              return o
            , (error)->
              $snappiAssetsPicker.log "filestore init failed, error="+JSON.stringify error 
          .then (o)->
            $snappiAssetsPicker.log _.keys o
            $snappiAssetsPicker.log _.keys o["directoryEntry"] 
            $snappiAssetsPicker.log "getLocalFilesystem()"
            return _pipelinePromises.getLocalFilesystem(o) # _.pluck o, "directoryEntry"  
          .then (o)->
            $snappiAssetsPicker.log _.keys o
            $snappiAssetsPicker.log "snappiAssetsPicker.mapPhotos() " 
            options = {
              pluck:["DateTimeOriginal"]
              fromDate: new Date("2014-04-10")
              toDate: new Date("2014-04-30")
            }
            $snappiAssetsPicker.log "mapPhotos, options=" + JSON.stringify options
            return _pipelinePromises.mapPhotos(options)
          .then (mapped)->
            $snappiAssetsPicker.log "Pipeline DONE!!!!!"
            $snappiAssetsPicker.log JSON.stringify(mapped)[0..200]
            return mapped
          .catch (error)->
            $snappiAssetsPicker.log "CATCH!!!!!"
            $snappiAssetsPicker.log error

        getPreviewSrc : (uuidExt)->
          promise = _initFileStore().then (o)->
            return _pipelinePromises.getLocalFilesystem(o)
          .then (o)->
            uuid = uuidExt.split('.')
            asset = {
              uuid: uuid[0]
              orig_ext: uuid[1]
              directoryEntry: o.directoryEntry.preview
            }
            console.log asset
            #   uuid: 
            #   orig_ext:
            #   data: 
            #   directoryEntry:
            return _pipelinePromises.getPreviewAsDataURL( asset, {thumbnail: true} )
          .then (o)->
            console.log "DONE getPreviewSrc!!!!"
            console.log o
            return o
          return promise
              
      }

      return $snappiAssetsPicker
  ])
