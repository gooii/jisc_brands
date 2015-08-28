(function() {
  var lib;

  lib = angular.module('jisc.brands', []);

}).call(this);
;(function() {
  var app;

  this.JiscBrandService = (function() {
    JiscBrandService.$inject = ['gooii.ng.loggerService', '$rootScope', '$location', 'rx', '$window'];

    function JiscBrandService(logFactory, $rootScope, $location, rx, $window) {
      this.$rootScope = $rootScope;
      this.$location = $location;
      this.rx = rx;
      this.$window = $window;
      if (logFactory) {
        this.log = logFactory.getLogger('jisc.brandService');
      }
      this.currentBrand = void 0;
      if (this.$window.brands) {
        this.brands = this.$window.brands;
      } else {
        this.brands = {};
        this.log.error('Brands config missing from window');
      }
      this.initEvent();
      this.bindEvent();
      this.getBrand();
    }

    JiscBrandService.prototype.initEvent = function() {
      var _this = this;
      return this._brandChangeObservable = this.rx.Observable.create(function(observer) {
        return _this.$rootScope.$on('$locationChangeSuccess', function() {
          return observer.onNext(_this.$location.path());
        });
      })["do"](function() {
        return _this.log.info("Location change ...");
      }).map(function(path) {
        _this.currentBrand = _.find(_this.brands, function(brand) {
          return _.startsWith(path, brand.url);
        });
        return _this.currentBrand;
      }).shareReplay(1);
    };

    JiscBrandService.prototype.bindEvent = function() {
      var _this = this;
      return this._brandChangeObservable.subscribe(function(brand) {
        return _this.log.info("New brand: %s", (brand != null ? brand.title : void 0) || "no branding");
      });
    };

    JiscBrandService.prototype.getBrandChangeObservable = function() {
      return this._brandChangeObservable;
    };

    JiscBrandService.prototype.getBrand = function() {
      var path;
      if (angular.isDefined(this.currentBrand)) {
        return this.currentBrand;
      }
      path = this.$location.path();
      this.currentBrand = _.find(this.brands, function(brand) {
        return _.startsWith(path, brand.url);
      });
      return this.currentBrand;
    };

    JiscBrandService.prototype.getBrandUrl = function() {
      var brand;
      brand = this.getBrand();
      if (brand) {
        return brand.url;
      } else {
        return "";
      }
    };

    JiscBrandService.prototype.getBrandById = function(id) {
      return _.find(this.brands, function(brand) {
        return brand.id === id;
      });
    };

    return JiscBrandService;

  })();

  app = angular.module('jisc.brands');

  app.service('jisc.brandService', JiscBrandService);

}).call(this);
;(function() {
  var app;

  app = angular.module('jisc.brands', []);

  app.provider("staticContentRouting", function() {
    var dummy, setup;
    setup = function($routeProvider, window) {
      var brands, staticPageMap,
        _this = this;
      staticPageMap = {};
      if (window.routes) {
        staticPageMap = window.routes;
        _.forEach(staticPageMap, function(template, path) {
          return $routeProvider.when("/" + path, {
            templateUrl: "/templates/" + template,
            reloadOnSearch: false
          });
        });
      }
      if (window.brands) {
        brands = window.brands;
        return _.forEach(brands, function(brand) {
          var _this = this;
          $routeProvider.when("" + brand.url, home);
          $routeProvider.when("" + brand.url + "/results", results);
          return _.forEach(staticPageMap, function(template, path) {
            console.log('Mapping brand', "" + brand.url + "/" + path, ("/templates/" + brand.id + "/") + template);
            return $routeProvider.when("" + brand.url + "/" + path, {
              templateUrl: ("/templates/" + brand.id + "/") + template,
              reloadOnSearch: false
            });
          });
        });
      }
    };
    dummy = function() {
      if (false) {
        return false;
      }
    };
    return {
      setup: setup,
      $get: dummy
    };
  });

}).call(this);
