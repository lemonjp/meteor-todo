# client/routers/user_show.coffee
Router.route '/users/:id', name: 'users_show'
class @UsersShowController extends PagableRouteController
  # use the same ready template
  template: 'profile'
  # subscribe to the necessary user
  waitOn: ->
    @subscribe 'user', @params.id
  # find the necessary user
  data: ->
    user: UsersCollection.findOneUser(@params.id)
