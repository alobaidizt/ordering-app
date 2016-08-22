`import Ember from 'ember'`

FoodTableComponent = Ember.Component.extend
  actions:
    order: (name) ->
      console.log 'order sent'

`export default FoodTableComponent`
