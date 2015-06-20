# collections/users.coffee
Users = Meteor.users
# static methods and properties
_.extend Users,
  # the list of fields available for editing
  allowFieldsForUpdate: ['profile', 'username']
  # ...
  findUser: (id, options) ->
    Users.find { $or: [ { _id: id }, { username: id } ] }, options
  findOneUser: (id, options) ->
    Users.findOne { $or: [ { _id: id }, { username: id } ] }, options
# add methods and properties to the model
Users.helpers
  # the method of updating the user, we can call it on the client
  update: (data) ->
    Users.update @_id, data
  # the method for updating that will only set data
  # take care of forbidden fields
  set: (data) ->
    d = {}
    f = _(Users.allowFieldsForUpdate)
    for key, value of data when f.include(key)
      d[key] = value
    @update $set: d
  # the method merges the current data with the passed one,
  # so that we could use it later for the update
  # and lose nothing
  merge: (data) ->
    current = @get()
    @set _.deepExtend(current, data)
  # receiving the model data only, all methods and properties
  # declared here are in the prototype
  get: ->
    r = {}
    r[key] = @[key] for key in _(@).keys()
    r
  # the list of all the email addresses
  getEmails: ->
    p = [@profile?.email]
    s = _(@services).map (value, key) -> value?.email
    e = _(@emails).map (value, key) -> value?.address
    _.compact p.concat(e, s)
  # the primary address
  getEmail: ->
    @getEmails()[0]
  # the public information
  getUsername    : -> @username || @_id
  getName        : -> @profile?.name || "Anonymous"
  getPublicEmail : -> @profile?.email
  urlData: ->
    id: @getUsername()
  # determine the link to Gravatar on the basis of the email address
  # or the hash that has been determined automatically during the registration
  getAvatar: (size) ->
    size = Number(size) || 200
    options =
      s: size
      d: 'identicon'
      r: 'g'
    hash = "00000000000000000000000000000000"
    if email = @getPublicEmail()
      hash = Gravatar.hash(email)
    else
      hash = @profile?.emailHash || hash
    Gravatar.imageUrl hash, options
  # checking the service being used during the registration
  isFromGithub:   -> @service == 'github'
  isFromGoogle:   -> @service == 'google'
  isFromPassword: -> @service == 'password'
  # the current user can edit
  # some data about himself
  isEditable: -> @_id == Meteor.userId()
# Export the collection
@UsersCollection = Users
