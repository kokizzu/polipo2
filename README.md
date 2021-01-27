Polipo2 is a single-threaded, non blocking caching web proxy that has
very modest resource needs.  See the file INSTALL for installation
instructions.  See the texinfo manual (available as HTML after
installation) for more information.

The original Polipo was developed by Juliusz Chroboczek from
2003 and was maintained by him up until November 2016.

This Polipo2 fork is maintained by Silas S. Brown.  It is **not**
intended for general use—as Juliusz said when he stepped
down, caching proxies are becoming obsolete for general use
due to the increasing prevalence of encrypted alternatives to
HTTP that reduce caching proxies to simple relays.  If all
you want is a simple relay (for example so your Web traffic
originates from a remote IP address), then you can do better
by using a VPN or a SOCKS5 proxy.

Polipo2 is now intended as a drop-in caching layer for
experimental HTTP proxies such as Web Adjuster.
