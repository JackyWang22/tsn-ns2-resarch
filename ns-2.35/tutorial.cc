all the file locations are here.

1. To add a packet data

~ns-allinone-2.35/ns-2.35/common/packet.h

.. packet.h

 a. static const packet_t PT_name = 73;
 b. static bool data_packet(packet_t type) {
 			         (type) == PT_name \
 c. name_[PT_name]= "name";

----------------------------------------------------------


to add OTCL Data

~ns-allinone-2.35/ns-2.35/tcl/lib/ns-packet.tcl


 a. Add NAME in it set protolist { }

~ns-allinone-2.35/ns-2.35/tcl/lib/ns-default.tcl

 a. Agent/Name set var_ true/"value"

~ns-allinone-2.35/ns-2.35/tcl/lib/ns-lib.tcl
 
 a. 
		    Name {
			    set ragent [$self create-name-agent $node]
		    }
 b.
	Simulator instproc create-name-agent { node } {
        #  Create Name routing agent
		set ragent [new Agent/NAME [$node node-addr]]
        	$self at 0.0 "$ragent start"     ;# start BEACON/HELLO Messages
        	$node set ragent_ $ragent
        	return $ragent
		}


-------------------------------------------------------------------
To add Tracing data

~ns-allinone-2.35/ns-2.35/trace/cmu-trace.h

	void    format_name(Packet *p, int offset);


~ns-allinone-2.35/ns-2.35/trace/cmu-trace.cc

	a. #include "names/name_pkt.h"
	b. case PT_ACK:
			format_tcp(p, offset);
			break;
	c. void CMUTrace::format_name(Packet *p, int offset)



----------------------------------------------------------------q
To maintain or add a queue

~ns-allinone-2.35/ns-2.35/queue/priqueue.cc
 a. PriQueue::recv(Packet *p, Handler *h)
{
        struct hdr_cmn *ch = HDR_CMN(p);

        if(Prefer_Routing_Protocols) {

                switch(ch->ptype()) {
		case PT_DSR:
		case PT_MESSAGE:
                case PT_TORA:
                case PT_AODV:
		case PT_AOMDV:
		case PT_MDART:
		case PT_NAME:


-----------------------------------
makefile.in
add .o file

./configure
make
