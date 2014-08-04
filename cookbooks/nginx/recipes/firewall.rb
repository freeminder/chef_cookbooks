simple_iptables_rule "Allow_any_to_APP" do
  rule [ "--proto tcp --dport 80",
         "--proto tcp --dport 443" ]
  jump "ACCEPT"
end
