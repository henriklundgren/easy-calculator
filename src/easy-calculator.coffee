# @author
# @license {@link http://github.com|MIT}

angular.module 'app', []

class Calculator extends Directive

  constructor: ($log) ->
    directiveDefinitionObject =
      restrict: 'E'
      scope: {}
      template: '<h1>Test</h1><input type="number" ng-model="numberField" number-field /><button type="button" ng-repeat="num in nums" ng-click="addNumber(num)">{{num}}</button><button type="button" ng-class="{\'active\': activeOperator == \'add\'}" ng-click="operator(\'add\')">+</button><button type="button" ng-class="{\'active\': activeOperator == \'subsctract\'}" ng-click="operator(\'substract\')">-</button><button type="button" ng-class="{\'active\': activeOperator == \'multiply\'}" ng-click="operator(\'multiply\')">*</button><button type="button" ng-class="{\'active\': activeOperator == \'divide\'}" ng-click="operator(\'divide\')">/</button><button type="button" ng-click="resetCalculator()" ng-bind="resetText">C</button><button type="button" ng-click="equals()">=</button>'
      link: (scope, element, attrs) ->

        dirty           = no
        dirtyResetState = no
        numbers         = new Array

        # operators
        # @property add
        # @property substract
        # @property multiply
        # @property divide
        operators =
          add: (x, y) ->
            return x + y
          substract: (x, y) ->
            return x - y
          multiply: (x, y) ->
            return x * y
          divide: (x, y) ->
            return x / y

        # ngScope
        # @property nums The digits.
        # @property activeOperator If view has active operator e.i. add, substract.
        # @property resetText The reset button text.
        scope.nums = (num for num in [0...10])
        scope.activeOperator = null
        scope.resetText = 'C'


        scope.equals = ->
          scope.operator(scope.activeOperator)
          numbers.length = 0

        ###
         * Reset calculator
         * Keep active calculation on C but clear current display value.
         ###

        # Toggle resetText and state
        toggleReset = (x, y) ->
          dirtyResetState = x
          scope.resetText = y

        # Do stuff
        scope.resetCalculator = ->
          # Clear the current display number but keep active calc
          if not dirtyResetState
            scope.numberField = ''
            toggleReset(yes, 'AC')

          # Reset calculator to pristine state.
          else if dirtyResetState
            numbers.length = 0
            scope.numberFieldModel.$setViewValue('')
            scope.numberFieldModel.$render()
            toggleReset(no, 'AC')



        # hasInputFieldNumbers
        # @param view The current input view value.
        # @param num The click event value.
        # @return {Number} Number to set as view value
        hasInputFieldNumbers = (view, num) ->
          return if angular.isUndefined num
          if view isnt null
            return view + num
          else
            return num


        # addNumber
        # Add number to view when user click button.
        # @param x The click event number
        scope.addNumber = (x) ->

          # Reset value is returned to primary state
          toggleReset(no, 'C') if dirtyResetState

          # 
          if numbers.length > 0 and dirty
            scope.numberFieldModel.$setViewValue('')
            scope.numberFieldModel.$render()
            dirty = no

          # Get value from input field if exists
          value = scope.numberFieldModel.$viewValue or null

          # Set new view value (take current view value and append user input value)
          scope.numberFieldModel.$setViewValue(hasInputFieldNumbers(value, x.toString()))
          scope.numberFieldModel.$render()

        # operator
        # @param operator The click event operator to use.
        scope.operator = (operator) ->
          # Get the view value from input field.
          value = scope.numberField

          # Make sure it is empty
          if numbers.length is 0 or not dirty
            numbers.push(value)
            dirty = yes

          # Set current operator property
          scope.activeOperator = operator

          if numbers.length > 0 and dirty
            result = operators[operator](numbers[0], value)
            scope.numberFieldModel.$setViewValue(result)
            scope.numberFieldModel.$render()
            numbers.length = 0
            numbers.push(result)
            dirty = no


        return

    return directiveDefinitionObject

