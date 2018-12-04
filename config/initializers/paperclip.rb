require "paperclip"

Paperclip.options[:command_path] = 'C:\Program Files\ImageMagick-6.9.1-Q16'
Paperclip.options[:swallow_stderr] = false
Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
Paperclip::Attachment.default_options[:s3_host_name] = 's3-ca-central-1.amazonaws.com'