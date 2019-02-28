set ns [new Simulator]

$ns color 1 blue
$ns color 2 red

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {}{
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
}

#Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#create link
$ns duplex-link $n0 $n2 1 Mb 10ms DropTail
$ns duplex-link $n1 $n2 1 Mb 10ms DropTail
$ns duplex-link $n3 $n2 1 Mb 10ms SFQ

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n0 $n2 orient right-down

#Monitor
$ns duplex-link-op $n2 $n3 queuePos 0.5

#Create a agent
set udp0 [new Agent/UDP]
$udp0 set class_ 1
$ns attach-agent $n0 $udp0

#Create a CBR traffice source and attach
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#Create a agent
set udp1 [new Agent/UDP]
$udp0 set class_ 2
$ns attach-agent $n1 $udp1

#Create a CBR traffice source and attach
set cbr1 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp1

#Create a agent
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0

#Connect
$ns connect $udp0 $null0
$ns connect $udp1 $null0

#Schedule
$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$cbr1 start"
$ns at 4.0 "$cbr1 stop"
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"

#run
$ns run



