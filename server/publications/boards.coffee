# server/publications/boards.coffee
Meteor.publish 'boards', (userId, limit = 20) ->
  findOptions =
    limit: limit
    sort: { createdAt: -1 }
  if userId
    # boards of a specific user
    cursor = BoardsCollection.findByUser userId, findOptions
  else
    # all boards
    cursor = BoardsCollection.find {}, findOptions
  inited = false
  userFindOptions =
    fields:
      service: 1
      username: 1
      profile: 1
  # the callback for adding the board owner to subscription
  addUser = (id, fields) =>
    if inited
      userId = fields.owner
      @added 'users', userId, UsersCollection.findOne(userId, userFindOptions)
  # monitor changes in the collection,
  # so that we could add users to the subscription
  handle = cursor.observeChanges
    added: addUser
    changed: addUser
  inited = true
  # immediately add users during the initialization,
  # with a single query to the database
  userIds = cursor.map (b) -> b.owner
  UsersCollection.find({_id: { $in: userIds }}, userFindOptions).forEach (u) =>
    @added 'users', u._id, u
  # stop listening to the collection’s cursor, when the subscription is stopped
  @onStop ->
    handle.stop()
  return cursor
