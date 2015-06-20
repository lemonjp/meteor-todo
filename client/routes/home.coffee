# client/routes/home.coffee
Router.route '/', name: 'home'
class @HomeController extends PagableRouteController
  # is the user authorized?
  isUserPresent: ->
    !!Meteor.userId()
  # subscribe to the profile in case the user is authorized
  waitOn: ->
    if @isUserPresent()
      @subscribe 'profile'
  # return data about the current user, if present
  data: ->
    if @isUserPresent()
      { user: UsersCollection.findOne Meteor.userId() }
  # render the profile template in case the user is authorized
  # and the homepage if otherwise
  action: ->
    if @isUserPresent()
      @render 'profile'
    else
      @render 'home'
