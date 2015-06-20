# server/methods/upload_board_image.coffee
# connect up the library to process the image
gm = Meteor.npmRequire 'gm'
# resize and save the image
resizeAndWriteAsync = (buffer, path, w, h, cb) ->
  gm(buffer)
  .options({imageMagick: true})
  .resize(w, "#{h}^", ">")
  .gravity('Center')
  .crop(w, h, 0, 0)
  .noProfile()
  .write(path, cb)
# perform the image processing with the synchronous
resizeAndWrite = Meteor.wrapAsync resizeAndWriteAsync
# register the method to load the image to the board
Meteor.methods
  uploadBoardImage: (boardId, data) ->
    board = BoardsCollection.findOne(boardId)
    if board.owner != @userId
      throw new Meteor.Error('notAuthorized', 'Not authorized')
    data  = new Buffer data, 'binary'
    name  = Meteor.uuid() # a unique name for the image
    path  = Meteor.getUploadFilePath name
    resizeAndWrite data, "#{path}.jpg", 1920, 1080
    resizeAndWrite data, "#{path}_thumb.jpg", 600, 400
    # save the data to the board
    BoardsCollection.update { _id: boardId },
      $set:
        background:
          url:   "/uploads/#{name}.jpg"
          thumb: "/uploads/#{name}_thumb.jpg"
    return
