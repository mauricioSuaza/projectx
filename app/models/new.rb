class New < ApplicationRecord
    mount_uploader :invoice, InvoiceUploader
end
