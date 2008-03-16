# COPYRIGHT: 2008 Ryan McGeary (ryanonruby -[at]- mcgeary [*dot*] org)
# LICENSE: MIT (http://en.wikipedia.org/wiki/MIT_License)
#
# This makes it easy to protect email addresses from spam bots by converting
# plain text email links into a bit of obfuscated javascript.  Disclaimer: This
# technique does not guarantee spam-free email, but it certainly helps.
#
# Usage:
#   obfuscated_mail_to "no.spam@example.com"
#   obfuscated_mail_to "no.spam@example.com", "Contact me"
#   obfuscated_mail_to "no.spam@example.com", nil, :class => "email"
module ObfuscatedEmailHelper
  def obfuscated_mail(email, title = email, options = {})
    obfuscated_link(title || email, "mailto:#{email}", options)
  end
  alias obfuscated_mail_to obfuscated_mail
  
  def obfuscated_link(title, href = "", options = {})
    chars, random = [], rand(255)
    plain = link(title, href, options)
    plain.each_byte { |c| chars << c + random }
    chars.map! { |c| "#{c}-#{random}"}
    tag(:script, :type => "text/javascript") do
      "document.write(String.fromCharCode(#{chars.join(',')}));"
    end
  end
  alias obfuscated_link_to obfuscated_link
end
