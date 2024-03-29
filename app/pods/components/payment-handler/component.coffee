`import Ember from 'ember'`
`import authorization from 'ordering-app/constants/brain-tree-auth'`

PaymentHandlerComponent = Ember.Component.extend
  willInsertElement: ->
    form = $('#checkout-form')
    submit = $('input[type="submit"]')

    braintree.client.create({
      authorization: authorization
    }, (clientErr, clientInstance) ->
      if (clientErr)
        # Handle error in client creation
        return

      braintree.hostedFields.create({
        client: clientInstance,
        styles: {
          'input': {
            'font-size': '14pt'
          },
          'input.invalid': {
            'color': 'red'
          },
          'input.valid': {
            'color': 'green'
          }
        },
        fields: {
          number: {
            selector: '#card-number',
            placeholder: '4111 1111 1111 1111'
          },
          cvv: {
            selector: '#cvv',
            placeholder: '123'
          },
          expirationDate: {
            selector: '#expiration-date',
            placeholder: '10 / 2019'
          }
        }
      }, (hostedFieldsErr, hostedFieldsInstance) ->
        if (hostedFieldsErr)
          # Handle error in Hosted Fields creation
          return

        submit.removeAttribute('disabled')

        form.addEventListener('submit', (event) ->
          event.preventDefault()

          hostedFieldsInstance.tokenize((tokenizeErr, payload) ->
            if (tokenizeErr)
              # Handle error in Hosted Fields tokenization
              return

            #Put `payload.nonce` into the `payment-method-nonce` input, and then
            #submit the form. Alternatively, u could send the nonce to ur server
            #with AJAX.

            # coffeelint: disable=max_line_length
            document.querySelector('input[name="payment-method-nonce"]').value = payload.nonce
            form.submit()
          )
        , false)
      )
    )

  actions:
    submit: ->
      console.log 'submitted'

`export default PaymentHandlerComponent`
