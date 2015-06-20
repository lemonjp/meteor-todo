# client/routes/about.coffee
Router.route '/about', name: 'about'
class @AboutController extends RouteController
  action: ->
    console.log 'About Controller'
    super()
