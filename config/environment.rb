# Load the rails application
require File.expand_path('../application', __FILE__)

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
# Initialize the rails application
ProyectoBase::Application.initialize!

ENV['RECAPTCHA_PUBLIC_KEY']  = '6LcKbYwUAAAAAH47pvI2TZkjTg2eOyShv_zHeFTe'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LcKbYwUAAAAAE32PKyiEitD3yNCEqQCOubrOoLJ'

