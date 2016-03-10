module Amiando
  class Payment < Resource

    ##
    # Create a payment for an event
    #
    # @param event_id
    #
    def self.create(event_id, attributes)
      object = new

      post object, "api/event/#{event_id}/payment/create",
        :params => attributes,
        :populate_method => :populate_create

      object
    end

    ##
    # Find a Payment
    #
    # @param payment_id
    #
    # @return [Payment] the payment with that id
    def self.find(payment_id)
      object = new
      get object, "api/payment/#{payment_id}"
      object
    end

    ##
    # Apply discount code
    #
    # @params payment_id, discount_code
    #
    # @return [Payment]


    def self.apply_discount_code(payment_id, discount_code)
      object = Boolean.new('success')
      post object, "api/payment/#{payment_id}/applyDiscountCode?discountCode=#{discount_code}"
      object
    end

    ##
    # Set ticket count
    #
    # @params payment_id
    # @param [Hash] amount of tickets you want to buy for this ticket category. It is possible to set the ticket count for more than one ticket category in a single request.
    #
    # @return [Payment]

    def self.set_ticket_count(payment_id, attributes)
      object = Boolean.new('success')
      post object, "api/payment/#{payment_id}/setTicketCount", :params => attributes
      object
    end

    ##
    # Start payemnt
    #
    # @params payment_id
    #
    # @return {"startIdentifier":"<start id>","startUrl":"<url to start the payment process>","queueIdentifier":"<queue id>","success":true}

    def self.start_payment(payment_id)
      object = Result.new do |response_body, result|
        if response_body['success']
          OpenStruct.new(
            :start_identifier => response_body['startIdentifier'],
            :start_url => response_body['startUrl'],
            :queue_identifier => response_body['queueIdentifier']
          )
        else
          result.errors = response_body['errors']
          false
        end
      end
      post object, "/api/payment/#{payment_id}/start"
      object
    end

    ##
    # This request will update the properties of the buyer address of the payment with the internal id <id>. Only properties which are provided as parameters will be updated.
    #
    # @params payment_id
    # @params attributes

    def self.fill_in_buyer_address(payment_id, attributes)
      object = Boolean.new('success')
      post object, "api/payment/#{payment_id}/address/buyer", :params => attributes
      object
    end

    def populate_create(response_body)
      super
      if response_body["payment"].is_a? Hash
        @attributes[:application_data] = response_body["payment"]["applicationData"]
      end
    end

    protected

    def populate(response_body)
      extract_attributes_from(response_body, 'payment')
    end
  end
end
