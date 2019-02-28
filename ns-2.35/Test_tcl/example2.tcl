set ns [new Simulator]

#open a nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#open a trace file
set tf [open out.tr w]
$ns trace-all $tf

#finish procedure
proc finish {} {
 global ns nf tf
 $ns flush-trace
 close $nf
 close $tf
 exec nam out.nam &
 exit 0
}

#create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#create links
$ns duplex-link $n0 $n3 10Mb 10ms DropTail
$ns duplex-link $n1 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n2 10Mb 10ms DropTail


#relayout nodes
$ns duplex-link-op $n0 $n3 orient right-down
$ns duplex-link-op $n1 $n3 orient right-up
$ns duplex-link-op $n3 $n2 orient right


#set colors
$ns color 1 blue
$ns color 2 red

#set label
$ns at 0.0 "$n0 label Host1"
$ns at 0.0 "$n1 label Host2"
$ns at 0.0 "$n3 label Switch1"
$ns at 0.0 "$n2 label Host3"

#set h1->s1 tcp connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 1

#set a cbr above tcp connection
set cbr(h1) [new Application/Traffic/CBR]
$cbr(h1) attach-agent $tcp1
$cbr(h1) set type_ CBR
$cbr(h1) set packet_size_ 1000
$cbr(h1) set rate_ 50mb
$cbr(h1) set random_ false


#set h2->s1 tcp connection
set tcp2 [new Agent/TCP]
$ns attach-agent $n1 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 2

#set a cbr above tcp connection
set cbr(h2) [new Application/Traffic/CBR]
$cbr(h2) attach-agent $tcp2
$cbr(h2) set type_ CBR
$cbr(h2) set packet_size_ 1000
$cbr(h2) set rate_ 50mb
$cbr(h2) set random_ false

#schedule
$ns at 0.1 "$cbr(h1) start"
$ns at 0.1 "$cbr(h2) start"
$ns at 4.0 "$cbr(h2) stop"
$ns at 4.0 "$cbr(h1) stop"
$ns at 4.1 "finish"

$ns run
