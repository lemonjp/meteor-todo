# server/publications/profile.coffee
Meteor.publish 'profile', ->
  # check whether the user requesting subscription
  # is authorized
  if @userId
    # subscribe him to his entry in the database
    UsersCollection.find { _id: @userId },
      fields:
        service: 1
        username: 1
        profile: 1
        emails: 1
  else
    # just say that it’s ready
    @ready()
    return
