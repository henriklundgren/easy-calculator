# @author heni@twitter
# @copyright (c)2014 Henrik Lundgren
# @license {@link http://github.com/henriklundgren|MIT}

class Digits extends Directive
  constructor: ->
    directiveDefinitionObject =
      require: ['^calculator']
      link: (scope, element, attributes, ctrl) ->
        if scope.$last
          ctrl[0]()

        return

    return directiveDefinitionObject
