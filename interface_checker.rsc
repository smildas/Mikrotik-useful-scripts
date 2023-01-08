##############################################
#  This script is for automatic interface    #
#  checking if all checked interface has     #
#  proper link speed: 8.1.2023               #
#                             Autor: Ramik   #
##############################################

#Add scheduler rule
/system scheduler add interval=5m name=interface-checker on-event=interface-checker policy=read,write start-date=jan/07/2023 start-time=22:15:03

#Add interfaces which should be checked
###############################
#######Add interfaces##########
###############################
/system script add name=interface-checker policy=read,write source={
    :global checkedInterface {"eth8-alc-vstis-142"; "eth9-alc-chlc-dlouha"; "eth10-alc-lhota-medova"; "eth12-alc-dobr-fxn"}
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
        }
    };
}

