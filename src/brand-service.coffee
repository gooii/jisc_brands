class JiscBrandService
  @$inject: ['gooii.ng.loggerService', '$rootScope', '$location', 'rx', '$window']
  constructor: (logFactory, @$rootScope, @$location, @rx, @$window) ->
    if logFactory
      @log = logFactory.getLogger('jisc.brandService')

    @currentBrand = undefined

    if @$window.brands
      @brands = @$window.brands
    else
      @brands = {}
      @log.error('Brands config missing from window')

    @initEvent()
    @bindEvent()
    @getBrand()

  ###############################################################################
  # Private API                                                                 #
  ###############################################################################
  initEvent: () ->
    @_brandChangeObservable = @rx.Observable.create (observer) =>
      @$rootScope.$on '$locationChangeSuccess', () => observer.onNext(@$location.path())
    .do () =>
      @log.info "Location change ..."
    .map (path) =>
      # locate the new branch from the given location path
      @currentBrand = _.find @brands, (brand) -> return _.startsWith(path, brand.url)
      return @currentBrand
    .shareReplay(1)

  bindEvent: () ->
    @_brandChangeObservable
    .subscribe (brand) =>
      @log.info "New brand: %s", brand?.title or "no branding"

  ###############################################################################
  # Public API                                                                  #
  ###############################################################################

  # returns the internal brand observable so clients can themselves subscribe to
  # brand changes
  getBrandChangeObservable: () ->
    return @_brandChangeObservable

  # returns an object representing the current brand (when accessing an App via a
  # branded URL e.g., /britishlibrary/sparerib
  getBrand: () ->
    if angular.isDefined @currentBrand
      return @currentBrand

    path = @$location.path()

    @currentBrand = _.find @brands, (brand) ->
      return _.startsWith(path, brand.url)

    return @currentBrand

  getBrandUrl: () ->
    brand = @getBrand()
    if brand
      return brand.url
    else
      return ""

  getBrandById: (id) ->
    return _.find @brands, (brand) ->
      return brand.id is id

app = angular.module 'jisc.brands'

app.service 'jisc.brandService', JiscBrandService
