def patch_external_invoice_status(id, status, token)
  invoice_url = "#{Rails.configuration.external_apis['comparator_api_invoices_endpoint']}#{id}"
  params = { status:, token: }
  response = Faraday.patch(invoice_url, params)
  return [] if response.status == 204
  raise ActiveRecord::QueryCanceled if response.status == 500

  response
end
