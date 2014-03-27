class NumberField extends Directive
  constructor: ->
    directiveDefinitionObject =
      require: ['ngModel']
      link: (scope, element, attributes, controllers) ->
        scope.numberFieldModel = controllers[0]
        return

    return directiveDefinitionObject

