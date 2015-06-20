# client/routes/users.coffee
Router.route '/users', name: 'users'
class @UsersController extends PagableRouteController
  # number of users per one page
  perPage: 20
  # subscribe to the user collection, with the specified limit,
  # so that we would not get unnecessary data
  #
  # subscription is carried via this method, so iron:router
  # would not render the page loading template each time during the subscription
  # update
  subscriptions: ->
    @subscribe 'users', @limit()
  # return all users from the local collection
  data: ->
    users: UsersCollection.find()
  # are all users loaded?
  loaded: ->
    @limit() > UsersCollection.find().count()
  # reset the limit each time during the page loading
  onRun: ->
    @resetLimit()
    @next()
