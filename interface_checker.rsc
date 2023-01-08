
#Add interfaces which should be checked
:global checkedInterface {""; ""; ""; ""}
:global resetInterface do={
    :log info "Reset interface $interface $reason" 
    /interface disable $interface;
    :delay 1s
    /interface enable $interface  
}

:foreach interface in=$checkedInterface do={

    /interface ethernet monitor $interface once do={
        :if ($rate = "100Mbps") do={
            $resetInterface interface=$interface reason="wrong link speed"
        }

        :if ($full-duplex = true) do={
            :log info "duplex" 
        }
    }
};

