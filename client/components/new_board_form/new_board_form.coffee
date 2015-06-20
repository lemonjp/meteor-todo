# client/components/new_board_form/new_board_form.coffee
# variables for the current user image
currentImage = null
currentImageUrl = null
currentImageDepend = new Tracker.Dependency
# reset the user image
resetImage = ->
  currentImage = null
  currentImageUrl = null
  currentImageDepend.changed()
# upload the image to the server
uploadImage = (boardId) ->
  if currentImage
    reader = new FileReader
    reader.onload = (e) ->
      # call the server method
      Meteor.call 'uploadBoardImage', boardId, e.target.result, (error) ->
        if error
          alertify.error error.message
        else
          alertify.success 'Image uploaded'
    reader.readAsBinaryString currentImage
# helpers of the following form template
Template.newBoardForm.helpers
  # set the background image for the form,
  # the function will be automatically called, as it has a dependency
  panelStyle: ->
    currentImageDepend.depend()
    currentImageUrl && "background-image: url(#{currentImageUrl})" || ''
# this callback is activated every time when the form is rendered to the page
Template.newBoardForm.rendered = ->
  resetImage()
# events of the form
Template.newBoardForm.events
  # when submitting the form, we create a new entry
  # if all went well, upload the image,
  # and reset the form
  'submit form': (event, template) ->
    event.preventDefault()
    form = event.target
    data = $(form).serializeJSON()
    BoardsCollection.create data.board, (error, id) ->
      if error
        alertify.error error.message
      else
        form.reset()
        alertify.success 'Board created'
        resetUsers()
        uploadImage(id)
        resetImage()
  # when selecting an image, we change the background of the form
  # and remember the current selection
  'change #newBoardImage': (event, template) ->
    files = event.target.files
    image = files[0]
    unless image and image.type.match('image.*')
      resetImage()
      return
    currentImage = image
    reader = new FileReader
    reader.onload = (e) =>
      currentImageUrl = e.target.result
      currentImageDepend.changed()
    reader.readAsDataURL(image)
