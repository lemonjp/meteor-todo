# collections/boards.coffee
# the data schema
boardsSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true
  'description':
    type: String
    optional: true # an optional field
  # automatically generate the board owner
  'owner':
    type: String
    autoValue: (doc) ->
      if @isInsert
        return @userId
      if @isUpsert
        return { $setOnInsert: @userId }
      @unset()
  # the list of board users
  'users':
    type: [String]
    defaultValue: []
  'users.$':
    type: String
    regEx: SimpleSchema.RegEx.Id
# register the collection and add the schema
Boards = new Mongo.Collection 'boards'
Boards.attachSchema boardsSchema
# data protection
Boards.allow
  # any authorized user can create boards
  insert: (userId, doc) ->
    userId && true
  # only the board owner can update data
  update: (userId, doc) ->
    userId && userId == doc.owner
# static methods
_.extend Boards,
  findByUser: (userId = Meteor.userId(), options) ->
    Boards.find
      $or: [
        { users: userId }
        { owner: userId }
      ]
    , options
  create: (data, cb) ->
    Boards.insert data, cb
# object methods
Boards.helpers
  update: (data, cb) ->
    Boards.update @_id, data, cb
  addUser: (user, cb) ->
    user = user._id if _.isObject(user)
    @update
      $addToSet:
        users: user
    , cb
  removeUser: (user, cb) ->
    user = user._id if _.isObject(user)
    @update
      $pop:
        users: user
    , cb
  updateName: (name, cb) ->
    @update { $set: {name: name} }, cb
  updateDescription: (desc, cb) ->
    @update { $set: {description: desc} }, cb
  # joins
  getOwner: ->
    UsersCollection.findOne @owner
  getUsers: (options) ->
    UsersCollection.find
      $or: [
        { _id: @owner }
        { _id: { $in: @users } }
      ]
    , options
  urlData: ->
    id: @_id
# export
@BoardsCollection = Boards
