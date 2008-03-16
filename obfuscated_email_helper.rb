# Copyright (C) 2008 Ryan McGeary (ryanonruby -[at]- mcgeary [*dot*] org)
# MIT License (http://en.wikipedia.org/wiki/MIT_License)
# http://github.com/rmm5t/smhelper-obfuscated-email/tree/master
#
# This makes it easy to protect email addresses from spam bots by converting
# plain text email links into a bit of obfuscated javascript.  Disclaimer: This
# technique does not guarantee spam-free email, but it certainly helps.
#
# Usage:
#   obfuscated_mail_to "no.spam@example.com"
#   obfuscated_mail_to "no.spam@example.com", "Contact me"
#   obfuscated_mail_to "no.spam@example.com", nil, :class => "email"
#
# Outputs:
#   <script type="text/javascript">
#     document.write(String.fromCharCode(204-144,241-144,176-144, ... ,206-144));
#   </script>
module ObfuscatedEmailHelper
  def obfuscated_mail(email, title = email, options = {})
    obfuscated_link(title || email, "mailto:#{email}", options)
  end
  alias obfuscated_mail_to obfuscated_mail
  
  def obfuscated_link(title, href = "", options = {})
    chars, random = [], rand(255)
    plain = link(title, href, options)
    plain.each_byte { |c| chars << "#{c + random}-#{random}" }
    tag(:script, :type => "text/javascript") do
      "document.write(String.fromCharCode(#{chars.join(',')}));"
    end
  end
  alias obfuscated_link_to obfuscated_link
end
