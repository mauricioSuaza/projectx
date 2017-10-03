class Article < ApplicationRecord
    mount_uploader :invoice, InvoiceUploader
    resourcify
end
