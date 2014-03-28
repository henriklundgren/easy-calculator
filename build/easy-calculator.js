/**
 * @author heni@twitter
 * @copyright (c)2014 Henrik Lundgren
 * @license: {@link http://github.com/henriklundgren|MIT}
 */

(function(window) {
  'use strict';

  angular.module('app', []);

(function() {
  var Digits;

  Digits = (function() {
    function Digits() {
      var directiveDefinitionObject;
      directiveDefinitionObject = {
        require: ['^calculator'],
        link: function(scope, element, attributes, ctrl) {
          if (scope.$last) {
            ctrl[0]();
          }
        }
      };
      return directiveDefinitionObject;
    }

    return Digits;

  })();

  angular.module('app').directive('digits', [Digits]);

}).call(this);

(function() {
  var Calculator;

  Calculator = (function() {
    function Calculator($log, $window) {
      var directiveDefinitionObject, window;
      window = $window;
      directiveDefinitionObject = {
        restrict: 'E',
        scope: {},
        replace: true,
        controller: function($scope, $element) {
          var elemHeight, elemPercentage, elemWidth, getInputFieldHeight, winHeight;
          elemHeight = $element[0].clientHeight;
          winHeight = window.innerHeight;
          elemWidth = $element[0].clientWidth;
          elemPercentage = function(win, el) {
            if (win > el) {
              return win / el;
            } else {
              return el / win;
            }
          };
          getInputFieldHeight = function(win, buttons) {
            return (win - $element.children()[0].clientHeight) / buttons;
          };
          $element.css({
            'minHeight': winHeight + 'px',
            'minWidth': elemWidth * elemPercentage(winHeight, elemHeight) + 'px'
          });
          return this.adjustButtons = function() {
            return $element.find('button').css('height', getInputFieldHeight(winHeight, 5) + 'px');
          };
        },
        templateUrl: 'calculator.tmpl.html',
        compile: function(elem, att, transclude) {
          return {
            pre: function(scope, element, attrs) {
              scope.nums = [
                {
                  name: 7
                }, {
                  name: 8
                }, {
                  name: 9
                }, {
                  name: 4
                }, {
                  name: 5
                }, {
                  name: 6
                }, {
                  name: 1
                }, {
                  name: 2
                }, {
                  name: 3
                }, {
                  name: 0,
                  className: 'zero'
                }, {
                  name: '.'
                }
              ];
              scope.activeOperator = null;
              scope.resetText = 'C';
            },
            post: function(scope, element, attrs) {
              var dirty, dirtyResetState, hasInputFieldNumbers, memory, operators, toggleReset;
              dirty = false;
              dirtyResetState = false;
              memory = new Array;
              operators = {
                add: function(x, y) {
                  return x + y;
                },
                substract: function(x, y) {
                  return x - y;
                },
                multiply: function(x, y) {
                  return x * y;
                },
                divide: function(x, y) {
                  return x / y;
                }
              };
              scope.equals = function() {
                scope.operator(scope.activeOperator);
                return memory.length = 0;
              };

              /*
               * Reset calculator
               * Keep active calculation on C but clear current display value.
               */
              toggleReset = function(x, y) {
                dirtyResetState = x;
                return scope.resetText = y;
              };
              scope.resetCalculator = function() {
                if (!dirtyResetState) {
                  scope.numberField = '';
                  return toggleReset(true, 'AC');
                } else if (dirtyResetState) {
                  memory.length = 0;
                  scope.numberFieldModel.$setViewValue('');
                  scope.numberFieldModel.$render();
                  return toggleReset(false, 'AC');
                }
              };
              hasInputFieldNumbers = function(view, num) {
                if (angular.isUndefined(num)) {
                  return;
                }
                if (view !== null) {
                  return view + num;
                } else {
                  return num;
                }
              };
              scope.addNumber = function(x) {
                var value;
                toggleReset(false, 'C');
                if (memory.length > 0 && dirty) {
                  scope.numberFieldModel.$setViewValue('');
                  scope.numberFieldModel.$render();
                  dirty = false;
                }
                value = scope.numberFieldModel.$viewValue || null;
                scope.numberFieldModel.$setViewValue(hasInputFieldNumbers(value, x.toString()));
                return scope.numberFieldModel.$render();
              };
              scope.operator = function(operator) {
                var result, value;
                if (angular.isUndefined(operator)) {
                  return;
                }
                value = scope.numberField;
                this.activeOperator = operator;
                if (memory.length !== 0) {
                  result = operators[operator](memory[0], value);
                  scope.numberFieldModel.$setViewValue(result);
                  scope.numberFieldModel.$render();
                  memory.length = 0;
                  memory.push(result);
                  return dirty = true;
                } else {
                  memory.push(value);
                  return dirty = true;
                }
              };
            }
          };
        }
      };
      return directiveDefinitionObject;
    }

    return Calculator;

  })();

  angular.module('app').directive('calculator', ['$log', '$window', Calculator]);

}).call(this);

(function() {
  var NumberField;

  NumberField = (function() {
    function NumberField() {
      var directiveDefinitionObject;
      directiveDefinitionObject = {
        require: ['ngModel'],
        link: function(scope, element, attributes, controllers) {
          scope.numberFieldModel = controllers[0];
        }
      };
      return directiveDefinitionObject;
    }

    return NumberField;

  })();

  angular.module('app').directive('numberField', [NumberField]);

}).call(this);

angular.module("app").run(["$templateCache", function($templateCache) {$templateCache.put("calculator.tmpl.html","<div class=\"calc-container clearfix\"><div class=\"input-group\"><input type=\"number\" ng-model=\"numberField\" data-number-field=\"data-number-field\"/></div><div class=\"digits\"><button type=\"button\" data-digits=\"data-digits\" ng-repeat=\"num in nums\" ng-click=\"addNumber(num.name)\" ng-class=\"{ \'{{num.className}}\': num.className}\" class=\"btn\">{{num.name}}</button><button type=\"button\" ng-click=\"resetCalculator()\" ng-bind=\"resetText\" class=\"btn reset\">C</button></div><div class=\"operators\"><button type=\"button\" ng-class=\"{\'active\': activeOperator == \'divide\'}\" ng-click=\"operator(\'divide\')\" class=\"btn\">/</button><button type=\"button\" ng-class=\"{\'active\': activeOperator == \'multiply\'}\" ng-click=\"operator(\'multiply\')\" class=\"btn\">*</button><button type=\"button\" ng-class=\"{\'active\': activeOperator == \'subsctract\'}\" ng-click=\"operator(\'substract\')\" class=\"btn\">-</button><button type=\"button\" ng-class=\"{\'active\': activeOperator == \'add\'}\" ng-click=\"operator(\'add\')\" class=\"btn\">+</button><button type=\"button\" ng-click=\"equals()\" class=\"btn\">=</button></div></div>");}]);
})(window);
