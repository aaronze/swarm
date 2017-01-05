'use strict'

###*
 # @ngdoc directive
 # @name swarmApp.directive:playfab
 # @description
 # # playfab
###
angular.module('swarmApp').directive 'playfaboptions', (playfab, options, session, game, playfabSyncer) ->
  templateUrl: 'views/playfab/options.html'
  restrict: 'EA'
  link: (scope, element, attrs) ->
    scope.form =
      autopush: options.autopush()
    scope.name = playfab.auth.email
    #scope.fetched = {state: 'abcde', lastUpdated: moment(999)}
    scope.fetched =
      state: -> playfab.auth?.state
      lastUpdated: -> moment(playfab.auth.lastUpdated)
    scope.isFetched = -> !!scope.fetched.state()

    playfabSyncer.initAutopush(options.autopush())
    scope.setAutopush = (val) ->
      options.autopush(val)
      playfabSyncer.initAutopush(val)

    scope.push = -> playfab.push(session.exportSave())
    scope.fetch = -> playfab.fetch().then(handleFetched)
    scope.pull = -> playfab.fetch().then(
      (auth) =>
        handleFetched(auth)
        game.importSave(auth.state)
    )
    scope.clear = -> playfab.clear().then(handleFetched)
    scope.logout = -> playfab.logout()
    scope.autopushError = -> playfabSyncer.getAutopushError()
