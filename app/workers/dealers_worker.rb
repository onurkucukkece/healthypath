class DealersWorker
  include Sidekiq::Worker
  sidekiq_options queue: "dealers"
  # sidekiq_options retry: false

  def perform()
    Dealer.empty_statuses
    dealers = Dealer.all.each do |dealer|
      redirect = ''
      uri = URI.parse("http://#{dealer.website}/#{dealer.path}")
      if dealer.post == true
        params = CGI.parse(uri.query)
        uri.query = ''
        res = Net::HTTP.post_form(uri, params)
      else
        res = Net::HTTP.get_response(uri)
      end

      status = res.inspect.match(/\w+[0-9] [a-zA-Z ]+ /)

      if res['location'].present?
        status = get_request(URI.parse("#{res['location']}"))
        redirect = res['location'].match(/#{dealer.website}\/(.*)/)[1]
      end

      dealer.update_attributes({status: status, redirect: redirect})
    end
    failed_dealers = Dealer.failed_dealers
    DealerMailer.failed_path(failed_dealers).deliver_later if failed_dealers.length > 0
  end

  def get_request(uri)
    response = Net::HTTP.get_response(uri)
    status = response.inspect.match(/\w+[0-9] [a-zA-Z ]+ /)
    return status
  end
end