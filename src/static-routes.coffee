app = angular.module('jisc.brands')

app.provider "staticContentRouting", () ->
  setup = ($routeProvider, window) ->
#    console.log('Setup route provider', window.routes, window.brands)

    staticPageMap = {
    }

    if(window.routes)
      staticPageMap = window.routes

      # the static page map is configured via a global js var which comes from the routes.js file in jja_content
      _.forEach staticPageMap, (template, path) =>
        $routeProvider.when("/#{path}", {
          templateUrl   : "/templates/" + template,
          reloadOnSearch: false
        })

    ###############################################################################
    # Branded URL handling                                                        #
    ###############################################################################

    if window.brands
      brands = window.brands

      _.forEach brands, (brand) ->
        # map the branded URL to our /home route
        #
        $routeProvider.when "#{brand.url}", home
        # map the branded URL + /results to our results route
        #
        $routeProvider.when "#{brand.url}/results", results

        # map all static routes to the brand as well
        _.forEach staticPageMap, (template, path) =>
          console.log('Mapping brand',"#{brand.url}/#{path}","/templates/#{brand.id}/" + template)
          $routeProvider.when("#{brand.url}/#{path}", {
            templateUrl   : "/templates/#{brand.id}/" + template,
            reloadOnSearch: false
          })

  dummy = () ->
    # Do nothing
    if false then false

  return {setup:setup, $get:dummy}
