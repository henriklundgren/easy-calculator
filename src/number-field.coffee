# @author heni@twitter
# @copyright (c)2014 Henrik Lundgren
# @license {@link http://github.com/henriklundgren|MIT}

class NumberField extends Directive
  constructor: ->
    directiveDefinitionObject =
      require: ['ngModel']
      link: (scope, element, attributes, controllers) ->
        scope.numberFieldModel = controllers[0]
        return

    return directiveDefinitionObject

