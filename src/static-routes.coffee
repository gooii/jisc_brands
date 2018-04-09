app = angular.module('jisc.brands')

app.provider "staticContentRouting", () ->
  # brandMapper is an optional function for custom brand route mapping, its called like :
  # brandMapper(brand, $routeProvider)
  setup = ($routeProvider, window, controller, resolver, brandMapper) ->
    staticPageMap = {
    }

    if(window.routes)
      staticPageMap = window.routes

      # the static page map is configured via a global js var which comes from the routes.js file in jja_content
      _.forEach staticPageMap, (template, path) =>
        $routeProvider.when("/#{path}", {
          templateUrl    : "/templates/" + template,
          reloadOnSearch : false
          controller     : controller
          resolve        : resolver})
    else
      console.info 'No routes found on window'

    ###############################################################################
    # Branded URL handling                                                        #
    ###############################################################################

    if window.brands
      brands = window.brands

      _.forEach brands, (brand) ->
        if brandMapper
          brandMapper(brand, $routeProvider)

        # map all static routes to the brand as well
        _.forEach staticPageMap, (template, path) =>
          console.log('Mapping brand',"#{brand.url}/#{path}","/templates/#{brand.id}/" + template)
          $routeProvider.when("#{brand.url}/#{path}", {
            templateUrl    : "/templates/#{brand.id}/" + template,
            reloadOnSearch : false
            resolve        : resolver})

  dummy = () ->
    # Do nothing
    if false then false

  return {setup:setup, $get:dummy}
