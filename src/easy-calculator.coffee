# @author heni@twitter
# @copyright (c)2014 Henrik Lundgren
# @license {@link http://github.com/henriklundgren|MIT}

class Calculator extends Directive

  constructor: ($log, $window) ->
    window = $window

    directiveDefinitionObject =
      restrict: 'E'
      scope: {}
      replace: yes
      controller: ($scope, $element) ->

        # Get height
        # Maybe have a service?
        #elemHeight = document[0].getElementsByClassName(attrs.class)[0].clientHeight
        elemHeight = $element[0].clientHeight
        winHeight = window.innerHeight
        elemWidth = $element[0].clientWidth

        # Get percentage
        elemPercentage = (win, el) ->
          if win > el
            return win / el
          else
            return el / win

        # Get the height available for each button (if 5 buttons height)
        getInputFieldHeight = (win, buttons) ->
          return (win - $element.children()[0].clientHeight) / buttons

        #if not 'ontouchstart' in window
        $element.css
          'minHeight': winHeight + 'px'
          'minWidth': elemWidth * elemPercentage(winHeight, elemHeight) + 'px'

        this.adjustButtons = ->
          $element
            .find('button')
            .css 'height', getInputFieldHeight(winHeight, 5) + 'px'


      templateUrl: 'calculator.tmpl.html'
      compile: (elem, att, transclude) ->
          pre: (scope, element, attrs) ->


            # ngScope
            # @property nums The digits.
            # @property activeOperator If view has active operator e.i. add, substract.
            # @property resetText The reset button text.
            scope.nums = [
              {name:7}, {name:8}, {name:9},
              {name:4}, {name:5}, {name:6},
              {name:1}, {name:2}, {name:3},
              {name:0, className: 'zero'}, {name:'.'}]
            scope.activeOperator = null
            scope.resetText = 'C'



            return

          post: (scope, element, attrs) ->


            dirty           = no
            dirtyResetState = no
            memory          = new Array

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


            scope.equals = ->
              scope.operator(scope.activeOperator)
              memory.length = 0

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
                memory.length = 0
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
              toggleReset(no, 'C')

              # Reset view value if second value input
              if memory.length > 0 and dirty
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
              return if angular.isUndefined operator

              # Get the view value from input field.
              value = scope.numberField
              # Set the active operator
              this.activeOperator = operator

              if memory.length isnt 0
                result = operators[operator] memory[0], value
                # Update view with new value
                scope.numberFieldModel.$setViewValue(result)
                scope.numberFieldModel.$render()
                memory.length = 0
                memory.push(result)
                dirty = yes
              else
                memory.push value
                dirty = yes # tell addNumbers to clear the field

            return

    return directiveDefinitionObject

