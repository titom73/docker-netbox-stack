#! /usr/bin/env python

import sys
from scapy.all import sr,sr1,IP,ICMP, Ether, ls
import socket

dst_ip = sys.argv[1]


print(f"Checking: {dst_ip}")
ans, unans = sr(IP(dst=dst_ip)/ICMP(),inter=0.5, retry=1, timeout=0.1, verbose=0)
if ans:
    rdns = socket.gethostbyaddr(str(dst_ip))
    print(rdns[0])
    ans.summary(lambda s,r: r.sprintf(f"%IP.src% ({rdns[0]}) is alive") )
else:
    print('Host is down !')
