# msi_dn1

# Operacijski sistem
Izbrala sem Ubuntu 20.04 LTS, ker je najhitreje najti način inštalacije za večino zadev. 
Probala sem z sistemom Alpine Linux, ki je manjši in bi se zato virtualka hitreje postavila. Vendar sem hitro prišla do težave, da ne znam inštalirali gns3-gui in gns3-server gor.

# Vagrant

Pojdi v datoteko Vagrant_way in poženi ukaz `vagrant up`. 
```Shell
cd msi_dn1/Vagrant_way
vagrant up
```
S tem boš generiral virtualko in lahko traja okoli 10 minut. 

```
ip: 127.0.0.1:3389
user_name: vagrant
password: vagrant
```

### Grafični vmesnik
Za grafični vmesnik sem izbrala i3 window maganager. Saj prvi poskusi so bili s XFCE4 grafičnim vmesnikom, ki je provision time povečal za povprečno 5 minut.

### Tipkovnica
S Ctrl + Alt se lahko premikate med slovnesko in ameriško tipkovnico.

### Aplikacije
Naložene so aplikacije:
- gns3
- wireshark
- Docker, ki je potreben za pravilno delovanje gns3
- Midori (web browser za lažje oddajanje domačih nalog :) )
- xrdp

Gns3 pride z Wireshark-om v paketu, ki se ga inštalira. Docker se je naložilo iz njihovega repozotorija. Midori browser sem izbrala ker je med lightweight browserji.
xrdp je za RDP protokol izvajati, torej za Remote Access.

### Problemi, ki sem jih srečala
Pri xfce4 paketu je vmes interaktivni izbor, ki je bil problematičen, ker če ni nastavilo DEBIAN_FRONTEND=noninteractive provisioning ni deloval. Prav tako je to pri inštalaciji gns3 in Docker-ja. To sem probala rešiti s pisanjem v debconf-set-selections. Večinoma se mi je pa izbralo default odgovor, ki se izbere, če imaš nastavilo DEBIAN_FRONTEND=noninteractive. Zato je bilo potrebno dodati vagrant uporabnika v skupino ubridge in Docker. Drugače ju uporabnik ne bi moral uporabljati. 
Naslednji problem je bil, da i3wm nastavi tipkovnico po defaultu na ameriško, kar predstavlja problem, če nisi navajen na njo in ugibaš kje je kateri znak. To sem rešila z dodajanjem v config datoteko.
```bash
# keyboard layout
exec "setxkbmap -layout si,us"
exec "setxkbmap -option 'grp:ctrl_alt_toggle'" 
```
Tako lahko uporabniki preklopljajo med slovensko in ameriško tipkovnico, glede na njihove želje.

# Cloud-init

### Problemi, ki sem jih srečala
Prvi problem je bil že kako sploh vitrualko bootstrapat z cloud-initom na Azure-ju. To sem ugotovila, da je en izmed najmanjših kradratkov pravi prostor za kopiranje code od cloud-config.yml.
Drugi problem je bil, da se nisem mogla povezati gor. Ne preko RDP, kljub temu da naj bi bil port odprt in xrdp naložen, ne preko ssh, prav tako ne z Bastion, ki je nek interni sistem. Zato sem probala s čisto prazno virtualko Ubuntu 20.04 gen 1, to je delovalo. Nato sem nadaljevala postopoma. Tako sem odkrila, da Docker pravilno naloži in deluje. Prav tako mi naloži pakete xorg, xinit, i3, vendar me ne poveže več gor, če v runcmd spreminjam karkoli glede tega. Če pa tam ne zaženem ustreznih zadev, mi ne dovoli zagnati z ukazom `startx`. xrdp tudi vse obesi. 